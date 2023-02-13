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

// Runs at the very end of our test suite to clean up the emulator.
after( async () => {
    await firebase.clearFirestoreData({projectId:MY_PROJECT_ID});
})