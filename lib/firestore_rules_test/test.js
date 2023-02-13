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

function getAdminFirestore(auth) {
    return firebase.initializeAdminApp({projectId:MY_PROJECT_ID}).firestore();
}

// Clears the emulator before each test so they each run on an empty database.
beforeEach( async () => {
    await firebase.clearFirestoreData({projectId:MY_PROJECT_ID});
})

// Tests for the Items collection
describe("Items", () => {
    it("can not be read by a user that is not their author", async() => {
        const db = getFirestore(null);
        const testDoc = db.collection("items").doc("testItem1");
        await firebase.assertFails(testDoc.get()) 
    })

    it("can be read by their author", async() => {
        const db = getFirestore(myAuth);
        const testDoc = db.collection("items").where("userId","==",myId);
        await firebase.assertSucceeds(testDoc.get()) 
    })

    it("can be edited by their author", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const setupDoc = db.collection("items").doc(itemID);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,name:"name_before",illustration:"not_an_url"}))

        const testDoc = db.collection("items").doc(itemID);
        await firebase.assertSucceeds(testDoc.update({name:"new_name"})) 
        
        var updatedDocRef = db.collection("items").doc(itemID);
        updatedDocRef.get().then((doc) => {
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
        // Creating an item where the userId is the id of the other user.
        const admin = getAdminFirestore();
        const itemID = "item_xyz"
        const setupDoc = admin.collection("items").doc(itemID);
        await setupDoc.set({userId:theirId,name:"name_before",illustration:"not_an_url"})

        // Verify that updating is forbidden for the user that is not the author.
        const db = getFirestore(myAuth);
        const testDoc = db.collection("items").doc(itemID);
        await firebase.assertFails(testDoc.update({name:"new_name"})) 

        // Verify that the value was actually not changed.
        const db_as_other = getFirestore(theirAuth);
        var notIpdatedDocRef = db_as_other.collection("items").doc(itemID);
        notIpdatedDocRef.get().then((doc) => {
            if (doc.exists) {
                assert.equal(doc.data().name,"name_before")
            } else {
                assert.equal(true,false)
                console.log("No such document!");
            }
        }).catch((error) => {
            console.log("Error getting document:", error);
        });
    })

    it("can not create an item if not logged in", async() => {
        const db = getFirestore(null);
        const itemID = "item_xyz"
        const setupDoc = db.collection("items").doc(itemID);
        await firebase.assertFails(setupDoc.set({userId:theirId,name:"a_name",illustration:"not_an_url"}))
    })

    it("can be created by their author", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const setupDoc = db.collection("items").doc(itemID);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,name:"a_name",illustration:"not_an_url"}))
    })

    it("can not create an item for a user that is not us", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_xyz"
        const setupDoc = db.collection("items").doc(itemID);
        await firebase.assertFails(setupDoc.set({userId:theirId,name:"a_name",illustration:"not_an_url"}))
    })

    it("has to be created with a name field", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const setupDoc = db.collection("items").doc(itemID);
        await firebase.assertFails(setupDoc.set({userId:myId,illustration:"not_an_url"}))
    })

    it("has to be created with an illustration field", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const setupDoc = db.collection("items").doc(itemID);
        await firebase.assertFails(setupDoc.set({userId:myId,name:"a_name"}))
    })

    it("has to be created with a userId field", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const setupDoc = db.collection("items").doc(itemID);
        await firebase.assertFails(setupDoc.set({name:"a_name",illustration:"not_an_url"}))
    })

    it("field name has to be a string", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_xyz"
        const setupDoc = db.collection("items").doc(itemID);
        await firebase.assertFails(setupDoc.set({userId:myId,name:12,illustration:"not_an_url"}))
    })

    it("field name can not be more than 100 characters long", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_xyz"
        const setupDoc = db.collection("items").doc(itemID);
        await firebase.assertFails(setupDoc.set({userId:myId,name:"a".repeat(101),illustration:"not_an_url"}))
    })

    it("field name can be 99 characters long", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_xyz"
        const setupDoc = db.collection("items").doc(itemID);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,name:"a".repeat(99),illustration:"not_an_url"}))
    })

    it("field illustration has to be a string", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_xyz"
        const setupDoc = db.collection("items").doc(itemID);
        await firebase.assertFails(setupDoc.set({userId:myId,name:"a_name",illustration:12}))
    })

}) 

// Tests for the Categories collection
describe("Categories", () => {
    it("can not be read by a user that is not their author", async() => {
        const db = getFirestore(null);
        const testDoc = db.collection("categories").doc("testCategory1");
        await firebase.assertFails(testDoc.get()) 
    })

    it("can be read by their author", async() => {
        const db = getFirestore(myAuth);
        const testDoc = db.collection("categories").where("userId","==",myId);
        await firebase.assertSucceeds(testDoc.get()) 
    })

    it("can be edited by their author", async() => {
        const db = getFirestore(myAuth);
        const categoryId = "category_abc"
        const setupDoc = db.collection("categories").doc(categoryId);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,title:"category_title",illustration:"not_an_url",rank:2}))

        const testDoc = db.collection("categories").doc(categoryId);
        await firebase.assertSucceeds(testDoc.update({title:"new_title"})) 
        
        var updatedDocRef = db.collection("categories").doc(categoryId);
        updatedDocRef.get().then((doc) => {
            if (doc.exists) {
                assert.equal(doc.data().title,"new_title")
            } else {
                assert.equal(true,false)
                console.log("No such document!");
            }
        }).catch((error) => {
            console.log("Error getting document:", error);
        });
    })

    it("can not be edited by a user that is not their author", async() => {
        // Creating an category where the userId is the id of the other user.
        const admin = getAdminFirestore();
        const categoryId = "category_xyz"
        const setupDoc = admin.collection("categories").doc(categoryId);
        await setupDoc.set({userId:theirId,title:"category_name",illustration:"not_an_url",rank:3})

        // Verify that updating is forbidden for the user that is not the author.
        const db = getFirestore(myAuth);
        const testDoc = db.collection("categories").doc(categoryId);
        await firebase.assertFails(testDoc.update({title:"new_title"})) 

        // Verify that the value was actually not changed.
        const db_as_other = getFirestore(theirAuth);
        var notIpdatedDocRef = db_as_other.collection("categories").doc(categoryId);
        notIpdatedDocRef.get().then((doc) => {
            if (doc.exists) {
                assert.equal(doc.data().title,"category_name")
            } else {
                assert.equal(true,false)
                console.log("No such document!");
            }
        }).catch((error) => {
            console.log("Error getting document:", error);
        });
    })

    it("can not create a category if not logged in", async() => {
        const db = getFirestore(null);
        const categoryId = "category_xyz"
        const setupDoc = db.collection("categories").doc(categoryId);
        await firebase.assertFails(setupDoc.set({userId:theirId,title:"a_title",illustration:"not_an_url",rank:4}))
    })

    it("can be created by their author", async() => {
        const db = getFirestore(myAuth);
        const categoryId = "category_xyz"
        const setupDoc = db.collection("categories").doc(categoryId);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,title:"a_title",illustration:"not_an_url",rank:4}))
    })

    it("can not create a category for a user that is not us", async() => {
        const db = getFirestore(myAuth);
        const categoryId = "category_xyz"
        const setupDoc = db.collection("categories").doc(categoryId);
        await firebase.assertFails(setupDoc.set({userId:theirId,name:"a_name",illustration:"not_an_url",rank:4}))
    })

    it("has to be created with a title field", async() => {
        const db = getFirestore(myAuth);
        const categoryId = "category_xyz"
        const setupDoc = db.collection("categories").doc(categoryId);
        await firebase.assertFails(setupDoc.set({userId:myId,illustration:"not_an_url",rank:4}))
    })

    it("has to be created with an illustration field", async() => {
        const db = getFirestore(myAuth);
        const categoryId = "category_xyz"
        const setupDoc = db.collection("categories").doc(categoryId);
        await firebase.assertFails(setupDoc.set({userId:myId,name:"a_name",rank:4}))
    })

    it("has to be created with a userId field", async() => {
        const db = getFirestore(myAuth);
        const categoryId = "category_xyz"
        const setupDoc = db.collection("categories").doc(categoryId);
        await firebase.assertFails(setupDoc.set({name:"a_name",illustration:"not_an_url",rank:4}))
    })

    it("has to be created with a rank field", async() => {
        const db = getFirestore(myAuth);
        const categoryId = "category_xyz"
        const setupDoc = db.collection("categories").doc(categoryId);
        await firebase.assertFails(setupDoc.set({userId:myId,name:"a_name",illustration:"not_an_url"}))
    })

    it("field title has to be a string", async() => {
        const db = getFirestore(myAuth);
        const categoryId = "category_xyz"
        const setupDoc = db.collection("categories").doc(categoryId);
        await firebase.assertFails(setupDoc.set({userId:myId,title:12,illustration:"not_an_url",rank:4}))
    })

    it("field title can not be more than 100 characters long", async() => {
        const db = getFirestore(myAuth);
        const categoryId = "category_xyz"
        const setupDoc = db.collection("categories").doc(categoryId);
        await firebase.assertFails(setupDoc.set({userId:myId,title:"a".repeat(101),illustration:"not_an_url",rank:4}))
    })

    it("field name can be 99 characters long", async() => {
        const db = getFirestore(myAuth);
        const categoryId = "category_xyz"
        const setupDoc = db.collection("categories").doc(categoryId);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,title:"a".repeat(99),illustration:"not_an_url",rank:4}))
    })

    it("field illustration has to be a string", async() => {
        const db = getFirestore(myAuth);
        const categoryId = "category_xyz"
        const setupDoc = db.collection("categories").doc(categoryId);
        await firebase.assertFails(setupDoc.set({userId:myId,title:"a_title",illustration:12,rank:4}))
    })

    it("field rank has to be a number", async() => {
        const db = getFirestore(myAuth);
        const categoryId = "category_xyz"
        const setupDoc = db.collection("categories").doc(categoryId);
        await firebase.assertFails(setupDoc.set({userId:myId,title:"a_title",illustration:"not_an_url",rank:"FALSE"}))
    })

    it("field rank can not be negative", async() => {
        const db = getFirestore(myAuth);
        const categoryId = "category_xyz"
        const setupDoc = db.collection("categories").doc(categoryId);
        await firebase.assertFails(setupDoc.set({userId:myId,title:"a_title",illustration:"not_an_url",rank:-3}))
    })

    it("field rank can be positive", async() => {
        const db = getFirestore(myAuth);
        const categoryId = "category_xyz"
        const setupDoc = db.collection("categories").doc(categoryId);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,title:"a_title",illustration:"not_an_url",rank:2}))
    })

    it("field rank can be zero", async() => {
        const db = getFirestore(myAuth);
        const categoryId = "category_xyz"
        const setupDoc = db.collection("categories").doc(categoryId);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,title:"a_title",illustration:"not_an_url",rank:0}))
    })
}) 


// Tests for the Workflows collection
describe("Workflows", () => {
    it("can not be read by a user that is not their author", async() => {
        const db = getFirestore(null);
        const testDoc = db.collection("workflows").doc("testWorkflow1");
        await firebase.assertFails(testDoc.get()) 
    })

    it("can be read by their author", async() => {
        const db = getFirestore(myAuth);
        const testDoc = db.collection("workflows").where("userId","==",myId);
        await firebase.assertSucceeds(testDoc.get()) 
    })

    it("can be edited by their author", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_abc"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,title:"title_before",illustration:"not_an_url"}))

        const testDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertSucceeds(testDoc.update({title:"new_title"})) 
        
        var updatedDocRef = db.collection("workflows").doc(workflowID);
        updatedDocRef.get().then((doc) => {
            if (doc.exists) {
                assert.equal(doc.data().title,"new_title")
            } else {
                assert.equal(true,false)
                console.log("No such document!");
            }
        }).catch((error) => {
            console.log("Error getting document:", error);
        });
    })

    it("can not be edited by a user that is not their author", async() => {
        // Creating a workflow where the userId is the id of the other user.
        const admin = getAdminFirestore();
        const workflowID = "workflow_xyz"
        const setupDoc = admin.collection("workflows").doc(workflowID);
        await setupDoc.set({userId:theirId,title:"title_before",illustration:"not_an_url"})

        // Verify that updating is forbidden for the user that is not the author.
        const db = getFirestore(myAuth);
        const testDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(testDoc.update({title:"new_title"})) 

        // Verify that the value was actually not changed.
        const db_as_other = getFirestore(theirAuth);
        var notIpdatedDocRef = db_as_other.collection("workflows").doc(workflowID);
        notIpdatedDocRef.get().then((doc) => {
            if (doc.exists) {
                assert.equal(doc.data().title,"title_before")
            } else {
                assert.equal(true,false)
                console.log("No such document!");
            }
        }).catch((error) => {
            console.log("Error getting document:", error);
        });
    })

    it("can not create a workflow if not logged in", async() => {
        const db = getFirestore(null);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(setupDoc.set({userId:myId,title:"title_before",illustration:"not_an_url"}))
    })

    it("can be created by their author", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,title:"a_title",illustration:"not_an_url"}))
    })

    it("can not create a workflow for a user that is not us", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(setupDoc.set({userId:theirId,title:"a_title",illustration:"not_an_url"}))
    })

    it("has to be created with a title field", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(setupDoc.set({userId:myId,illustration:"not_an_url"}))
    })

    it("has to be created with an illustration field", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(setupDoc.set({userId:myId,title:"a_title"}))
    })

    it("has to be created with a userId field", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(setupDoc.set({title:"a_title",illustration:"not_an_url"}))
    })

    it("field title has to be a string", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(setupDoc.set({userId:myId,title:12,illustration:"not_an_url"}))
    })

    it("field title can not be more than 100 characters long", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(setupDoc.set({userId:myId,title:"a".repeat(101),illustration:"not_an_url"}))
    })

    it("field title can be 99 characters long", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,title:"a".repeat(99),illustration:"not_an_url"}))
    })

    it("field illustration has to be a string", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(setupDoc.set({userId:myId,title:"a_title",illustration:12}))
    })

}) 

// Runs at the very end of our test suite to clean up the emulator.
after( async () => {
    await firebase.clearFirestoreData({projectId:MY_PROJECT_ID});
})