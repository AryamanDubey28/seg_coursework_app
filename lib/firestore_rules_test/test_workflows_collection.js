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

    it("can be deleted by their author", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_abc"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,title:"title_before"}))

        const testDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertSucceeds(testDoc.delete()) 
    })

    it("can not be deleted by a user that is not their author", async() => {
        const setupDB = getAdminFirestore();
        const workflowID = "workflow_abc"
        const setupDoc = setupDB.collection("workflows").doc(workflowID);
        await firebase.assertSucceeds(setupDoc.set({userId:theirId,title:"title_before"}))

        const db = getFirestore(myAuth);
        const testDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(testDoc.delete()) 
    })

    it("can be edited by their author", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_abc"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,title:"title_before"}))

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
        await setupDoc.set({userId:theirId,title:"title_before"})

        // Verify that updating is forbidden for the user that is not the author.
        const db = getFirestore(myAuth);
        const testDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(testDoc.update({title:"new_title"})) 

        // Verify that the value was actually not changed.
        const db_as_other = getFirestore(theirAuth);
        var notUpdatedDocRef = db_as_other.collection("workflows").doc(workflowID);
        notUpdatedDocRef.get().then((doc) => {
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
        await firebase.assertFails(setupDoc.set({userId:myId,title:"title_before"}))
    })

    it("can be created by their author", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,title:"a_title"}))
    })

    it("can not create a workflow for a user that is not us", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(setupDoc.set({userId:theirId,title:"a_title"}))
    })

    it("has to be created with a title field", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(setupDoc.set({userId:myId}))
    })

    it("has to be created with a userId field", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(setupDoc.set({title:"a_title"}))
    })

    it("field title has to be a string", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(setupDoc.set({userId:myId,title:12}))
    })

    it("field title can not be more than 100 characters long", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(setupDoc.set({userId:myId,title:"a".repeat(101)}))
    })

    it("field title can be 99 characters long", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,title:"a".repeat(99)}))
    })


    it("can not have any field that is not expected", async() => {
        const db = getFirestore(myAuth);
        const workflowID = "workflow_xyz"
        const setupDoc = db.collection("workflows").doc(workflowID);
        await firebase.assertFails(setupDoc.set({userId:myId,title:"a_title",unexpected_field:"not_expected_value"}))
    })

    it("can not be added if field is not of the right type", async() => {
        const db = getFirestore(myAuth);
        const setupDoc = db.collection("workflows");
        await firebase.assertFails(setupDoc.add({userId:myId,title:12}))
    })

    it("can not be added with an unexpected field", async() => {
        const db = getFirestore(myAuth);
        const setupDoc = db.collection("workflows");
        await firebase.assertFails(setupDoc.add({userId:myId,title:"a_name",unexpected:"not_allowed"}))
    })

    it("can be added if all fields are correct", async() => {
        const db = getFirestore(myAuth);
        const setupDoc = db.collection("workflows");
        await firebase.assertSucceeds(setupDoc.add({userId:myId,title:"a_name"}))
    })
}) 
