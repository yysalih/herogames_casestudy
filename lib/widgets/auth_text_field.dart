import 'package:casestudy/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';


class CustomTextField extends ConsumerWidget {
  final bool isObscure;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextInputType textInputType;
  final bool isDate;
  final bool isHobby;


  const CustomTextField( {
    super.key,
    required this.isObscure,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.validator,
    required this.onChanged,
    this.textInputType = TextInputType.text,
    this.isDate = false,
    this.isHobby = false
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final authState = ref.watch(authController);
    final authWatch = ref.watch(authController.notifier);
    final userWatch = ref.watch(userController.notifier);

    return TextFormField(
      keyboardType: textInputType,
      textInputAction: TextInputAction.done,
      validator: validator,
      obscureText: isObscure ? authState.isObscure : false,
      controller: controller,
      onChanged: onChanged,
      inputFormatters: isDate ?
          [
            FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
            LengthLimitingTextInputFormatter(10),
            _DateInputFormatter(),
          ]
          : [],
      decoration: Constants.kInputDecorationWithNoBorder.copyWith(

        prefixIcon: Icon(prefixIcon, color: Colors.grey.shade500),
        hintText: hintText,
        suffixIcon: !isObscure ? isHobby ?
        IconButton(
          icon: Icon(Icons.add, color: Colors.grey.shade500),
          onPressed: () async {
            if(userWatch.addHobbyController.text.isNotEmpty) {
              await userWatch.getData();
              userWatch.addHobby(userWatch.addHobbyController.text);
            }
          },
        ) :
        null
        : IconButton(
          icon: Icon(Icons.remove_red_eye_rounded, color: Colors.grey.shade500),
          onPressed: () {

            authWatch.obscureChange();
          },
        ),
        contentPadding: const EdgeInsets.all(10),
      ),
    );
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Handle backspacing
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }

    var dateText = newValue.text;
    var replacedText = '';

    // Handle the first 2 digits for days
    if (dateText.length >= 2) {
      replacedText += '${dateText.substring(0, 2)}/';
      dateText = dateText.substring(2);
    }

    // Handle the next 2 digits for months
    if (dateText.length >= 2) {
      replacedText += '${dateText.substring(0, 2)}/';
      dateText = dateText.substring(2);
    }

    // Handle the year
    if (dateText.isNotEmpty) {
      replacedText += dateText;
    }

    return newValue.copyWith(
      text: replacedText,
      selection: TextSelection.collapsed(offset: replacedText.length),
    );
  }
}