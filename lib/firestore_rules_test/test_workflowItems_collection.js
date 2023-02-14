const assert = require('assert')
const firebase = require('@firebase/testing')

const MY_PROJECT_ID ="seg-app-f4674";
const myId = "user_abc";
const theirId = "user_xyz";
const theirAuth = {uid:theirId,  email:"janedoe@test.com"};
const myAuth = {uid:myId,  email:"johndoe@test.com"};

function getFirestore(auth) {
    return firebase.initializeTestApp({projectId:MY_PROJECT_ID,auth:auth}).firestore();
}

async function createItemForMe(itemId)
{
    const db = getFirestore(myAuth);
    const setupDoc = db.collection("items").doc(itemId);
    await setupDoc.set({userId:myId,name:"name_before",illustration:"not_an_url"})
}

async function createItemForThem(itemId)
{
    const db = getFirestore(theirAuth);
    const setupDoc = db.collection("items").doc(itemId);
    await setupDoc.set({userId:theirId,name:"name_before",illustration:"not_an_url"})
}
async function createWorkflowForMe(workflowID)
{
    const db = getFirestore(myAuth);
    const setupDoc = db.collection("workflows").doc(workflowID);
    await firebase.assertSucceeds(setupDoc.set({userId:myId,title:"a_title",illustration:"not_an_url"}))
}

async function createWorkflowForThem(workflowID)
{
    const db = getFirestore(theirAuth);
    const setupDoc = db.collection("workflows").doc(workflowID);
    await firebase.assertSucceeds(setupDoc.set({userId:theirId,title:"a_title",illustration:"not_an_url"}))
}

// Tests for the WorkflowItems collection
describe("WorkflowItems", () => {
    it("can not be read by a user that is not the author of the workflow they qualify", async() => {
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const db = getFirestore(theirAuth);
        const testDoc = db.collection("workflowItems").doc(workflow_id);
        await firebase.assertFails(testDoc.get())
    })

    it("can be read by the author of the workflow they qualify", async() => {
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const db = getFirestore(myAuth);
        const testDoc = db.collection("workflowItems").doc(workflow_id);
        await firebase.assertSucceeds(testDoc.get())
    })

    it("can be created by their author", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/"+workflow_id+"/items").doc(itemID);
        await firebase.assertSucceeds(setupWorkflowItem.set({userId:myId,name:"item_name",illustration:"not_an_url",rank:12}))
    })

    it("can be edited by their author", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/"+workflow_id+"/items").doc(itemID);
        await setupWorkflowItem.set({userId:myId,name:"item_name",illustration:"not_an_url",rank:12})

        await firebase.assertSucceeds(setupWorkflowItem.update({name:"new_name"})) 
        setupWorkflowItem.get().then((doc) => {
            if (doc.exists) {
                assert.equal(doc.data().name,"new_name")
            } else {
                assert.equal(true,false)
                console.log("No such document!");
            }
        }).catch((error) => {
            console.log("Error getting document:", error);
        });
    })

    it("can not be edited by a user that is not their author", async() => {
        const theirDB = getFirestore(theirAuth);
        const itemID = "item_abc"
        const created_item = createItemForThem(itemID)
        const workflow_id = "workflow_abc"
        const created_workflow = createWorkflowForThem(workflow_id)
        const setupWorkflowItem = theirDB.collection("workflowItems/"+workflow_id+"/items").doc(itemID);
        await setupWorkflowItem.set({userId:theirId,name:"item_name",illustration:"not_an_url",rank:12})
        
        const myDB = getFirestore(myAuth)
        const notMineWorkflowItem = myDB.collection("workflowItems/"+workflow_id+"/items").doc(itemID);
        await firebase.assertFails(notMineWorkflowItem.update({name:"new_name"})) 
        setupWorkflowItem.get().then((doc) => {
            if (doc.exists) {
                assert.equal(doc.data().name,"item_name")
            } else {
                assert.equal(true,false)
                console.log("No such document!");
            }
        }).catch((error) => {
            console.log("Error getting document:", error);
        });
    })

    it("can not create a workflowItem if not logged in", async() => {
        const db = getFirestore(null);
        const itemID = "item_abc"
        const created_item = createItemForThem(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForThem(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/"+workflow_id+"/items").doc(itemID);
        await firebase.assertFails(setupWorkflowItem.set({userId:theirId,name:"item_name",illustration:"not_an_url",rank:12}))
    })

    it("can not create a workflowItem for a user that is not us", async() => {
        const db = getFirestore(theirAuth);
        const itemID = "item_abc"
        const created_item = createItemForThem(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForThem(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/"+workflow_id+"/items").doc(itemID);
        await firebase.assertFails(setupWorkflowItem.set({userId:myId,name:"item_name",illustration:"not_an_url",rank:12}))
    })

    it("has to be created with a name field", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/"+workflow_id+"/items").doc(itemID);
        await firebase.assertFails(setupWorkflowItem.set({userId:myId,illustration:"not_an_url",rank:12}))
    })

    it("has to be created with an illustration field", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/"+workflow_id+"/items").doc(itemID);
        await firebase.assertFails(setupWorkflowItem.set({userId:myId,name:"a_name",rank:12}))
    })

    it("has to be created with a rank field", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/"+workflow_id+"/items").doc(itemID);
        await firebase.assertFails(setupWorkflowItem.set({userId:myId,illustration:"not_an_url",illustration:"not_an_url"}))
    })

    it("has to be created with a userId field", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/"+workflow_id+"/items").doc(itemID);
        await firebase.assertFails(setupWorkflowItem.set({rank:12,illustration:"not_an_url",illustration:"not_an_url"}))
    })

    it("field name has to be a string", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/"+workflow_id+"/items").doc(itemID);
        await firebase.assertFails(setupWorkflowItem.set({userId:myId,name:12,illustration:"not_an_url",rank:12}))
    })

    it("field illustration has to be a string", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/"+workflow_id+"/items").doc(itemID);
        await firebase.assertFails(setupWorkflowItem.set({userId:myId,name:"a_name",illustration:12,rank:12}))
    })

    it("field rank has to be a number", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/"+workflow_id+"/items").doc(itemID);
        await firebase.assertFails(setupWorkflowItem.set({userId:myId,name:"a_name",illustration:"not_an_url",rank:"not valid"}))
    })

    it("field rank can not be negative", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/"+workflow_id+"/items").doc(itemID);
        await firebase.assertFails(setupWorkflowItem.set({userId:myId,name:"a_name",illustration:"not_an_url",rank:-12}))
    })

    it("field rank can be zero", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/"+workflow_id+"/items").doc(itemID);
        await firebase.assertSucceeds(setupWorkflowItem.set({userId:myId,name:"a_name",illustration:"not_an_url",rank:0}))
    })

    it("field rank can be positive", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/"+workflow_id+"/items").doc(itemID);
        await firebase.assertSucceeds(setupWorkflowItem.set({userId:myId,name:"a_name",illustration:"not_an_url",rank:12}))
    })

    it("can not be created for a workflow that does not exist", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/workflow_xyz/items").doc(itemID);
        await firebase.assertFails(setupWorkflowItem.set({userId:myId,name:"a_name",illustration:"not_an_url",rank:12}))
    })

    it("can not be created for an item that does not exist (using set() method)", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/"+ workflow_id +"/items").doc("item_xyz");
        await firebase.assertFails(setupWorkflowItem.set({userId:myId,name:"a_name",illustration:"not_an_url",rank:12}))
    })

    it("can not be created for an item that does not exist (using update() method)", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const workflow_id = "workflow_abc"
        const created = await createWorkflowForMe(workflow_id)
        const setupWorkflowItem = db.collection("workflowItems/"+ workflow_id +"/items").doc("item_xyz");
        await firebase.assertFails(setupWorkflowItem.update({userId:myId,name:"a_name",illustration:"not_an_url",rank:12}))
    })
}) 
