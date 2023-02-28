
import 'package:firebase_auth/firebase_auth.dart';

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
        print(e);
        return 'We could not securely verify your identity. Please log out and back in to carry out this change.';
      } catch (e) {
        print(e);
        return 'We could not connect to the database. Please try again later.';
      }
    } else {
      return 'We could not verify your identity. Please log out and back in.';
    }
  }

  Future<User?> getCurrentUser() async {
    var user = await auth.currentUser;
    if (user != null) {
      return user;
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
