import 'package:casestudy/views/create_user_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/main_view.dart';

class Authentication {

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }


  static Future<void> signOut({required BuildContext context}) async {

    try {
      await FirebaseAuth.instance.signOut();
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  static Future<void> initializeFirebase({required BuildContext context}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user = FirebaseAuth.instance.currentUser;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid.toString())
          .get();
      if(prefs.getString("uid") != null && snapshot.exists) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainView(),), (route) => false);
      }
      else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CreateUserView(),), (route) => false);

      }

    }
    catch (E) {

    }

  }

  static Future<User?> signUp({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  static Future<User?> signIn({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

}
