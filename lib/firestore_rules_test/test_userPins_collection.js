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

// Tests for the userPins collection
describe("userPins", () => {
    it("can not be read by a user that is not their author", async() => {
        const db = getFirestore(null);
        const testDoc = db.collection("userPins").doc("testPin1");
        await firebase.assertFails(testDoc.get()) 
    })

    it("can be read by their author", async() => {
        const db = getFirestore(myAuth);
        const testDoc = db.collection("userPins").where("userId","==",myId);
        await firebase.assertSucceeds(testDoc.get()) 
    })


    it("can be deleted by their author", async() => {
        const db = getFirestore(myAuth);
        const userPinId = "pin_abc"
        const setupDoc = db.collection("userPins").doc(userPinId);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,pin:"1234"}))

        const testDoc = db.collection("userPins").doc(userPinId);
        await firebase.assertSucceeds(testDoc.delete()) 
    })

    it("can not be deleted by a user that is not their author", async() => {
        const setupDB = getAdminFirestore();
        const userPinId = "pin_abc"
        const setupDoc = setupDB.collection("userPins").doc(userPinId);
        await firebase.assertSucceeds(setupDoc.set({userId:theirId,pin:"1234"}))

        const db = getFirestore(myAuth);
        const testDoc = db.collection("userPins").doc(userPinId);
        await firebase.assertFails(testDoc.delete()) 
    })

    it("can be edited by their author", async() => {
        const db = getFirestore(myAuth);
        const userPinId = "pin_abc"
        const setupDoc = db.collection("userPins").doc(userPinId);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,pin:"1234"}))

        const testDoc = db.collection("userPins").doc(userPinId);
        await firebase.assertSucceeds(testDoc.update({pin:"5678"})) 
        
        var updatedDocRef = db.collection("userPins").doc(userPinId);
        updatedDocRef.get().then((doc) => {
            if (doc.exists) {
                assert.equal(doc.data().pin,"5678")
            } else {
                assert.equal(true,false)
                console.log("No such document!");
            }
        }).catch((error) => {
            console.log("Error getting document:", error);
        });
    })

    it("can not be edited by a user that is not their author", async() => {
        // Creating a userPin where the userId is the id of the other user.
        const admin = getAdminFirestore();
        const userPinID = "userPin_xyz"
        const setupDoc = admin.collection("userPins").doc(userPinID);
        await setupDoc.set({userId:theirId,pin:"1234"})

        // Verify that updating is forbidden for the user that is not the author.
        const db = getFirestore(myAuth);
        const testDoc = db.collection("userPins").doc(userPinID);
        await firebase.assertFails(testDoc.update({pin:"5678"})) 

        // Verify that the value was actually not changed.
        const db_as_other = getFirestore(theirAuth);
        var notIpdatedDocRef = db_as_other.collection("userPins").doc(userPinID);
        notIpdatedDocRef.get().then((doc) => {
            if (doc.exists) {
                assert.equal(doc.data().pin,"1234");
            } else {
                assert.equal(true,false)
                console.log("No such document!");
            }
        }).catch((error) => {
            console.log("Error getting document:", error);
        });
    })

    it("can not create an userPin if not logged in", async() => {
        const db = getFirestore(null);
        const userPinID = "pin_123"
        const setupDoc = db.collection("userPins").doc(userPinID);
        await firebase.assertFails(setupDoc.set({userId:theirId,pin:"1234"}))
    })

    it("can be created by their author", async() => {
        const db = getFirestore(myAuth);
        const userPinID = "pin_123"
        const setupDoc = db.collection("userPins").doc(userPinID);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,pin:"1234"}))
    })

    it("can not create a userPin for a user that is not us", async() => {
        const db = getFirestore(myAuth);
        const userPinID = "pin_xyz"
        const setupDoc = db.collection("userPins").doc(userPinID);
        await firebase.assertFails(setupDoc.set({userId:theirId,pin:"1234"}))
    })

    it("has to be created with a pin field", async() => {
        const db = getFirestore(myAuth);
        const userPinID = "pin_xyz"
        const setupDoc = db.collection("userPins").doc(userPinID);
        await firebase.assertFails(setupDoc.set({userId:myId}))
    })

    it("pin has to be a string", async() => {
        const db = getFirestore(myAuth);
        const userPinID = "pin_xyz"
        const setupDoc = db.collection("userPins").doc(userPinID);
        await firebase.assertFails(setupDoc.set({userId:myId,pin:1234}))
    })

    it("pin can not be 3 characters long", async() => {
        const db = getFirestore(myAuth);
        const userPinID = "pin_xyz"
        const setupDoc = db.collection("userPins").doc(userPinID);
        await firebase.assertFails(setupDoc.set({userId:myId,pin:"123"}))
    })

    it("pin can not be 5 characters long", async() => {
        const db = getFirestore(myAuth);
        const userPinID = "pin_xyz"
        const setupDoc = db.collection("userPins").doc(userPinID);
        await firebase.assertFails(setupDoc.set({userId:myId,pin:"12345"}))
    })

    it("pin can be 3 characters long", async() => {
        const db = getFirestore(myAuth);
        const userPinID = "pin_xyz"
        const setupDoc = db.collection("userPins").doc(userPinID);
        await firebase.assertSucceeds(setupDoc.set({userId:myId,pin:"1234"}))
    })

    it("can not be created with an unexpected field", async() => {
        const db = getFirestore(myAuth);
        const userPinID = "pin_xyz"
        const setupDoc = db.collection("userPins").doc(userPinID);
        await firebase.assertFails(setupDoc.set({userId:myId,pin:"1234",not_expected:"not_expected"}))
    })

    it("can be added if all fields are correct (with add method)", async() => {
        const db = getFirestore(myAuth);
        const setupDoc = db.collection("userPins");
        await firebase.assertSucceeds(setupDoc.add({userId:myId,pin:"1234"}))
    })
}) 