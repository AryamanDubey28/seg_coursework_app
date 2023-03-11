import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This class concentrates all method relative to communicating with the Firebase Authentication service.
class Auth {
  late final FirebaseAuth auth;

  Auth({required this.auth});

  Stream<User?> get user => auth.authStateChanges();

  Future<String?> createAccount(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  // Return the current user's email or the empty string if there is no identifiable current user.
  Future<String> getCurrentUserEmail() async {
    var user_email = await auth.currentUser!.email;
    if (user_email != null) {
      return user_email;
    } else {
      return "";
    }
  }

  Future<String> getCurrentUserPIN() async {
    try {
      final query = FirebaseFirestore.instance
          .collection('userPins')
          .where('userId', isEqualTo: await getCurrentUserId());
      final map = await query.get();
      final pin = map.docs.first.data()['pin'];
      return pin.toString();
    } on FirebaseAuthException {
      return "Error. Could not communicate with database";
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> checkPINExists() async {
    String pin = await getCurrentUserPIN();
    return pin.length == 4 &&
        num.tryParse(pin) != null; // unless PIN is 4 digits, return false
  }

  Future<String> createPIN(String pin) async {
    try {
      final docUser = FirebaseFirestore.instance.collection('userPins').doc();
      if (pin.length == 4) {
        final entry = {
          //pin is saved with user's ID
          'pin': pin,
          'userId': await getCurrentUserId(),
        };
        await docUser.set(entry); //adds PIN to database
        return "Successfully made your pin: $pin";
      } else {
        return "Please ensure that your PIN is 4 digits";
      }
    } on FirebaseAuthException {
      return "Error creating PIN. Could not communicate with database";
    } catch (e) {
      return e.toString();
    }
  }

  // Edit the current user's password and return custom error messages depending on the precise error that occured.
  Future<String> editCurrentUserPassword(
      String currentPassword, String newPassword) async {
    if (await getCurrentUser() != null) {
      try {
        var credentials = EmailAuthProvider.credential(
            email: await getCurrentUserEmail(), password: currentPassword);
        await auth.currentUser!
            .reauthenticateWithCredential(credentials)
            .then((value) {
          auth.currentUser!.updatePassword(newPassword);
        });
        return "Your password was successfully changed.";
      } on FirebaseAuthException {
        return 'Your current password is not correct. Please try again.';
      } catch (e) {
        return 'We are sorry, we could not change your password. Please try again.';
      }
    } else {
      return 'We could not verify your identity. Please log out and back in.';
    }
  }

  // Edit the current user's email and return custom error messages depending on the precise error that occured.
  Future<String> editCurrentUserEmail(String newEmail) async {
    if (await getCurrentUser() != null) {
      try {
        await auth.currentUser!.updateEmail(newEmail);
        return 'Your email was successfully changed.';
      } on FirebaseAuthException catch (e) {
        return e.message ??
            'We could not securely verify your identity. Please log out and back in to carry out this change.';
      } catch (e) {
        return 'We could not connect to the database. Please try again later.';
      }
    } else {
      return 'We could not verify your identity. Please log out and back in.';
    }
  }

  Future<String> editCurrentUserPIN(String newPIN) async {
    if (await getCurrentUser() != null) {
      if (newPIN.length != 4) {
        return "Please ensure your PIN is 4 digits";
      }
      try {
        String docId = "";
        //get the document id of the current user
        final docUser = await FirebaseFirestore.instance
            .collection('userPins')
            .where('userId', isEqualTo: await getCurrentUserId())
            .get()
            .then((value) {
          value.docs.forEach((element) {
            docId = element.id;
          });
        });

        //update the PIN to the newPIN
        final updater =
            FirebaseFirestore.instance.collection('userPins').doc(docId);
        updater.update({
          'pin': newPIN,
        });
        return "Your PIN was successfully changed to $newPIN";
      } catch (e) {
        return "There was an error: $e";
      }
    }
    return "This attempt at changing your PIN was unsuccessful";
  }

  Future<User?> getCurrentUser() async {
    var user = await auth.currentUser;
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  Future<String?> getCurrentUserId() async {
    var user = await auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      if (!validEmail(email)) {
        return "Unsuccessful";
      }
      await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return "Success";
    } on FirebaseAuthException {
      return "Unsuccessful";
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> signOut() async {
    try {
      await auth.signOut();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  bool validEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
