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

const importTest = (path) => {
    require(path);
}

describe("Running tests for the Firestore Database rules ...", () => {
    require('./test_items_collection.js');
    require('./test_categories_collection.js');
    require('./test_workflows_collection.js');
    require('./test_categoryItems_collection.js');
    require('./test_workflowItems_collection.js');
});

// Runs at the very end of our test suite to clean up the emulator.
after( async () => {
    await firebase.clearFirestoreData({projectId:MY_PROJECT_ID});
})