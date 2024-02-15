import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../services/authentication_service.dart';
import '../views/create_user_view.dart';
import '../views/main_view.dart';
import 'main_controller.dart';

class AuthState {
  final bool isRegister;
  final bool isUserExists;
  final bool isObscure;

  AuthState({
    required this.isRegister,
    required this.isUserExists,
    required this.isObscure,
  });

  AuthState copyWith({bool? isRegister, bool? isUserExists, bool? isObscure}) {
    return AuthState(
      isRegister: isRegister ?? this.isRegister,
      isUserExists: isUserExists ?? this.isUserExists,
      isObscure: isObscure ?? this.isObscure,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(AuthState state) : super(state);

  final User? _user = FirebaseAuth.instance.currentUser;
  User? get user => _user;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  final TextEditingController _passwordRepeatController =
      TextEditingController();
  TextEditingController get passwordRepeatController =>
      _passwordRepeatController;

  switchRegister() {
    state = state.copyWith(isRegister: !state.isRegister);
  }

  obscureChange() {
    state = state.copyWith(isObscure: !state.isObscure);
  }

  Future<bool> checkIfUserExists(User? user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (user == null) {
      return false;
    } else {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();
        if (snapshot.exists && snapshot.data()!["name"] != "null") {
          prefs.setString("uid", user.uid);
          state = state.copyWith(isUserExists: true);
          return true;
        } else {
          state = state.copyWith(isUserExists: false);
          return false;
        }
      } catch (E) {
        print(E);
        state = state.copyWith(isUserExists: false);
        return false;
      }
    }
  }

  Future createNewUser(UserModel user) async {

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set(user.toJson())
        .whenComplete(() => debugPrint("user created"))
        .onError((error, stackTrace) =>
            debugPrint("Error in create method: $error"));
  }

  handleEmailSignIn(BuildContext context, MainController mainController) async {
    if (state.isRegister) {
      User? user = await Authentication.signUp(
          email: _emailController.text, password: _passwordController.text);
      await checkExistedUser(context, mainController, user);
    } else {
      User? user = await Authentication.signIn(
          email: _emailController.text, password: _passwordController.text);
      await checkExistedUser(context, mainController, user);
    }
  }

  Future<void> checkExistedUser(
      BuildContext context, MainController mainController, User? user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (user != null) {
      prefs.setString("uid", user.uid);

      bool isUserExists = await checkIfUserExists(user);

      debugPrint("Does user exists? $isUserExists");

      if (isUserExists) {
        Navigator.push(
            context, mainController.routeToGivenScreen(const MainView()));
      } else {
        //await createNewUser(user);
        Navigator.push(
            context, mainController.routeToGivenScreen(CreateUserView()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${state.isRegister ? "Kayıt" : "Giriş"} sırasında bir hata oluştu.")));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

final authController = StateNotifierProvider<AuthController, AuthState>(
    (ref) => AuthController(AuthState(
          isRegister: false,
          isUserExists: false,
          isObscure: true,
        )));
