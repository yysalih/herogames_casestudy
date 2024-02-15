import 'package:flutter/material.dart';

import '../utils/contants.dart';

final class AppValidators {

  static String? emailValidator(String? value) {
    const emailRegex = r"^[a-zA-Z0-9.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$";

    if (value == null || value.isEmpty) {
      return Constants.kEmptyEmail;
    }

    else if (!RegExp(emailRegex).hasMatch(value)) {
      return Constants.kInvalidEmail;
    }

    else {
      return null;
    }
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return Constants.kEmptyPassword;
    } else {
      return null;
    }
  }

  static String? confirmPasswordValidator(
      String? password, String? confirmPassword) {
    if (password == null || password.isEmpty) {
      return Constants.kEmptyPassword;
    } else if (password != confirmPassword) {
      return Constants.kUnmatchedPasswords;
    }
    return null;
  }
}