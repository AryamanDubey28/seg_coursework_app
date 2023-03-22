# seg_coursework_app


## C6: Communication app for developmentally delayed, non-verbal child with autism



## Authors:

- *Anton Sirgue*
- *Ali Alkhars*
- *Aryaman Dubey*
- *Aymen Berbache*
- *Dion Munipi*
- *Brendan Rogan*
- *Yousef Alhujaylan*


## Reference list:

- In file `image_picker_functions.dart`    
    The logic behind the upload/take picture library is made with the help of: https://youtu.be/MSv38jO4EJk and https://youtu.be/u52TWx41oU4

- In file `admin_choice_boards.dart`
    The implementation of the draggable lists is made with the help of https://youtu.be/HmiaGyf55ZM

- In file `loadingMixin.dart`
    Mixin taken from: https://github.com/ali2236/loader

- In file `hero_dialog_route.dart`
    Custom [PageRoute] that creates an overlay dialog (popup effect) taken from: https://youtu.be/Bxs8Zy2O4wk

- In file `loading_indicator.dart`
    This class was taken from https://medium.com/nerd-for-tech/showing-a-progress-indicator-easily-in-flutter-aa564eb0df5c.
    It was created by Rafael Perez on June 10th, 2021.

## About Firebase Firestore Schema:
This software uses the **Firebase Firestore database** deployed and maintained by Google. 

This database uses a *noSQL* paradigm, therefore, it required a different approach to structure our data. Firebase encourages to take advantage of the tree-like aspect of their database to make efficient and quick querying through **data duplication**. 

Data is therefore duplicated between the "items" collection and the "categoryItems" and "workflowItems" collection. As such, the retrieval of the items data of a "category" or a "workflow" does not require executing a query to the "items" collection itself. 

Even though no one in the team likes this approach, it is the one recommended by the Google developer support videos series called "Firebase Realtime for SQL developers" which can be found here: https://firebase.google.com/docs/database/video-series. 

Our understanding and implementation of this approach on the database structure resulted in establishing the following schema, which is enforced through a series of database rules:

![SEG Schema-1](https://user-images.githubusercontent.com/34315087/226924575-46036104-0cc3-40af-976c-b9438c49f04c.jpg)


## Deployment:
The software is deployed as an apk file, but can be created into a .app file, a macos app or a windows app on request.

## General notes about the app:
- The app is designed to be used in landscape mode (however it does work in portrait mode)
- To switch from child mode to admin mode, you need to press and hold the button on the top right (not tap)
