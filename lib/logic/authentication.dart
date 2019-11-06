import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jwel_smart/logic/objects/user.dart';

import 'on_error.dart';

class Authentication {
  static Future<bool> login(String email, String password,
      [OnErrorCallback onError]) async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (result.user == null) {
        throw Exception("User login failed.");
      }
      return true;
    } catch (e) {
      if (onError == null) {
        print(e);
      } else {
        onError(e);
      }
      return false;
    }
  }

  static Future<bool> signup(String username, String phone, String email,
      String password, String confirmPassword,
      [OnErrorCallback onError]) async {
    try {
      if (password != confirmPassword) {
        throw Exception("Password and confirm passwords are different");
      }
      AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (result.user == null) {
        throw Exception("User registration failed.");
      }

      User userObj = User(username, phone, email, false);
      await Firestore.instance
          .collection("Users")
          .document(result.user.uid)
          .setData(userObj.toMap());
      return true;
    } catch (e) {
      if (onError == null) {
        print(e);
      } else {
        onError(e);
      }
      return false;
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
