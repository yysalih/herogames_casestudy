import 'package:casestudy/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/authentication_service.dart';

class UserState {
  final UserModel userModel;
  final List hobbies;

  UserState({required this.userModel, required this.hobbies});

  UserState copyWith({
    UserModel? userModel,
    List? hobbies,
  }) {
    return UserState(
      userModel: userModel ?? this.userModel,
      hobbies: hobbies ?? this.hobbies,
    );
  }
}

class UserController extends StateNotifier<UserState> {
  UserController(super.state);

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final TextEditingController _birthDateController = TextEditingController();
  TextEditingController get birthDateController => _birthDateController;

  final TextEditingController _addHobbyController = TextEditingController();
  TextEditingController get addHobbyController => _addHobbyController;


  Future<UserModel> getCurrentUser() async {
    final documentSnapshot = await FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid).get();
    print(documentSnapshot.data());
    return const UserModel().fromJson(documentSnapshot.data()!);
  }

  addHobby(String value) async {
    state = state.copyWith(hobbies: state.hobbies..add(value));
    saveHobbies();
    _addHobbyController.clear();
    debugPrint(state.hobbies.toString());

  }

  removeHobby(String value) async {
    state = state.copyWith(hobbies: state.hobbies..remove(value));
    saveHobbies();
    debugPrint(state.hobbies.toString());

  }

  getData() async {
    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      state = state.copyWith(hobbies: value["hobbies"], userModel: UserModel().fromJson(value.data()!));
    });
  }

  saveHobbies() async {
    await FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid).update({
      "hobbies" : state.hobbies
    });
  }

  logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("uid");
    await Authentication.signOut(context: context);
  }
}

final userController = StateNotifierProvider<UserController, UserState>((ref) => UserController(UserState(
    userModel: const UserModel(),
    hobbies: []
)));