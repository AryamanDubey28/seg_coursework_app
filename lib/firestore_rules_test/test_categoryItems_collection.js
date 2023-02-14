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

async function createCategoryForMe(categoryId)
{
    const db = getFirestore(myAuth);
    const setupDoc = db.collection("categories").doc(categoryId);
    await setupDoc.set({userId:myId,title:"category_title",illustration:"not_an_url",rank:2})
}

async function createItemForMe(itemId)
{
    const db = getFirestore(myAuth);
    const setupDoc = db.collection("items").doc(itemId);
    await setupDoc.set({userId:myId,name:"name_before",illustration:"not_an_url"})
}

async function createCategoryForThem(categoryId)
{
    const db = getFirestore(theirAuth);
    const setupDoc = db.collection("categories").doc(categoryId);
    await setupDoc.set({userId:theirId,title:"category_title",illustration:"not_an_url",rank:2})
}

async function createItemForThem(itemId)
{
    const db = getFirestore(theirAuth);
    const setupDoc = db.collection("items").doc(itemId);
    await setupDoc.set({userId:theirId,name:"name_before",illustration:"not_an_url"})
}


// Tests for the CategoryItems collection
describe("CategoryItems", () => {
    it("can not be read by a user that is not the author of the category they qualify", async() => {
        const category_id = "category_abc"
        const created = await createCategoryForMe(category_id)
        const db = getFirestore(theirAuth);
        const testDoc = db.collection("categoryItems").doc(category_id);
        await firebase.assertFails(testDoc.get())
    })

    it("can be read by the author of the category they qualify", async() => {
        const category_id = "category_abc"
        const created = await createCategoryForMe(category_id)
        const db = getFirestore(myAuth);
        const testDoc = db.collection("categoryItems").doc(category_id);
        await firebase.assertSucceeds(testDoc.get())
    })

    it("can be created by their author", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForMe(categoryId)
        const setupCategoryItem = db.collection("categoryItems/"+categoryId+"/items").doc(itemID);
        await firebase.assertSucceeds(setupCategoryItem.set({userId:myId,name:"item_name",illustration:"not_an_url",rank:12}))
    })

    it("can be edited by their author", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForMe(categoryId)
        const setupCategoryItem = db.collection("categoryItems/"+categoryId+"/items").doc(itemID);
        await setupCategoryItem.set({userId:myId,name:"item_name",illustration:"not_an_url",rank:12})

        await firebase.assertSucceeds(setupCategoryItem.update({name:"new_name"})) 
        setupCategoryItem.get().then((doc) => {
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
        const categoryId = "category_abc"
        const created_category = createCategoryForThem(categoryId)
        const setupCategoryItem = theirDB.collection("categoryItems/"+categoryId+"/items").doc(itemID);
        await setupCategoryItem.set({userId:theirId,name:"item_name",illustration:"not_an_url",rank:12})
        
        const myDB = getFirestore(myAuth)
        const notMineCategoryItem = myDB.collection("categoryItems/"+categoryId+"/items").doc(itemID);
        await firebase.assertFails(notMineCategoryItem.update({name:"new_name"})) 
        setupCategoryItem.get().then((doc) => {
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

    it("can not create a categoryItem if not logged in", async() => {
        const db = getFirestore(null);
        const itemID = "item_abc"
        const created_item = createItemForThem(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForThem(categoryId)
        const setupCategoryItem = db.collection("categoryItems/"+categoryId+"/items").doc(itemID);
        await firebase.assertFails(setupCategoryItem.set({userId:theirId,name:"item_name",illustration:"not_an_url",rank:12}))
    })

    it("can not create a categoryItem for a user that is not us", async() => {
        const db = getFirestore(theirAuth);
        const itemID = "item_abc"
        const created_item = createItemForThem(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForThem(categoryId)
        const setupCategoryItem = db.collection("categoryItems/"+categoryId+"/items").doc(itemID);
        await firebase.assertFails(setupCategoryItem.set({userId:myId,name:"item_name",illustration:"not_an_url",rank:12}))
    })

    it("has to be created with a name field", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForMe(categoryId)
        const setupCategoryItem = db.collection("categoryItems/"+categoryId+"/items").doc(itemID);
        await firebase.assertFails(setupCategoryItem.set({userId:myId,illustration:"not_an_url",rank:12}))
    })

    it("has to be created with an illustration field", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForMe(categoryId)
        const setupCategoryItem = db.collection("categoryItems/"+categoryId+"/items").doc(itemID);
        await firebase.assertFails(setupCategoryItem.set({userId:myId,name:"a_name",rank:12}))
    })

    it("has to be created with a rank field", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForMe(categoryId)
        const setupCategoryItem = db.collection("categoryItems/"+categoryId+"/items").doc(itemID);
        await firebase.assertFails(setupCategoryItem.set({userId:myId,name:"a_name",illustration:"this_is_not_an_url"}))
    })

    it("has to be created with a userId field", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForMe(categoryId)
        const setupCategoryItem = db.collection("categoryItems/"+categoryId+"/items").doc(itemID);
        await firebase.assertFails(setupCategoryItem.set({rank:12,name:"a_name",illustration:"this_is_not_an_url"}))
    })

    it("field name has to be a string", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForMe(categoryId)
        const setupCategoryItem = db.collection("categoryItems/"+categoryId+"/items").doc(itemID);
        await firebase.assertFails(setupCategoryItem.set({userId:myId,name:12,illustration:"not_an_url",rank:12}))
    })

    it("field illustration has to be a string", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForMe(categoryId)
        const setupCategoryItem = db.collection("categoryItems/"+categoryId+"/items").doc(itemID);
        await firebase.assertFails(setupCategoryItem.set({userId:myId,name:"a_name",illustration:12,rank:12}))
    })

    it("field rank has to be a number", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForMe(categoryId)
        const setupCategoryItem = db.collection("categoryItems/"+categoryId+"/items").doc(itemID);
        await firebase.assertFails(setupCategoryItem.set({userId:myId,name:"a_name",illustration:"not_an_url",rank:"not valid"}))
    })

    it("field rank can not be negative", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForMe(categoryId)
        const setupCategoryItem = db.collection("categoryItems/"+categoryId+"/items").doc(itemID);
        await firebase.assertFails(setupCategoryItem.set({userId:myId,name:"a_name",illustration:"not_an_url",rank:-4}))
    })

    it("field rank can be zero", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForMe(categoryId)
        const setupCategoryItem = db.collection("categoryItems/"+categoryId+"/items").doc(itemID);
        await firebase.assertSucceeds(setupCategoryItem.set({userId:myId,name:"a_name",illustration:"not_an_url",rank:0}))
    })

    it("field rank can be positive", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForMe(categoryId)
        const setupCategoryItem = db.collection("categoryItems/"+categoryId+"/items").doc(itemID);
        await firebase.assertSucceeds(setupCategoryItem.set({userId:myId,name:"a_name",illustration:"not_an_url",rank:1}))
    })


    it("can not be created for a category that does not exist", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForMe(categoryId)
        const setupCategoryItem = db.collection("categoryItems/category_xyz/items").doc(itemID);
        await firebase.assertFails(setupCategoryItem.set({userId:myId,name:"a_name",illustration:"not_an_url",rank:1}))
    })

    it("can not be created for an item that does not exist (using set() method)", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForMe(categoryId)
        const setupCategoryItem = db.collection("categoryItems/"+ categoryId +"/items").doc("item_xyz");
        await firebase.assertFails(setupCategoryItem.set({userId:myId,name:"a_name",illustration:"not_an_url",rank:1}))
    })

    it("can not be created for an item that does not exist (using update() method)", async() => {
        const db = getFirestore(myAuth);
        const itemID = "item_abc"
        const created_item = createItemForMe(itemID)
        const categoryId = "category_abc"
        const created_category = createCategoryForMe(categoryId)
        const setupCategoryItem = db.collection("categoryItems/"+ categoryId +"/items").doc("item_xyz");
        await firebase.assertFails(setupCategoryItem.update({userId:myId,name:"a_name",illustration:"not_an_url",rank:1}))
    })
}) 
