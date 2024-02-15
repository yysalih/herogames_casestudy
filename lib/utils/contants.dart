import 'package:flutter/material.dart';

class Constants {
  static const String kAppName = "Hero Games Case Study";
  static const String kLogo = "https://www.herogamestudio.com/wp-content/uploads/2023/04/HeroGamesLogoHorizontal-300x87.png";

  static const String kEmptyEmail = "Email boş bırakılamaz.";
  static const String kInvalidEmail = "Lütfen geçerli bir email adresi giriniz.";

  static const String kEmptyPassword = "Şifre boş bırakılamaz.";
  static const String kUnmatchedPasswords = "Şifreler birbiri ile eşleşmiyor.";

  static const InputDecoration kInputDecorationWithNoBorder = InputDecoration(
    border: UnderlineInputBorder(),
    focusedErrorBorder: UnderlineInputBorder(),
    errorBorder: UnderlineInputBorder(),
    enabledBorder: UnderlineInputBorder(),
    focusedBorder: UnderlineInputBorder(),
    disabledBorder: UnderlineInputBorder(),
  );
}