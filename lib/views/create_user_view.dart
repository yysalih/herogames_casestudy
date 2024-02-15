import 'package:cached_network_image/cached_network_image.dart';
import 'package:casestudy/controllers/auth_controller.dart';
import 'package:casestudy/controllers/main_controller.dart';
import 'package:casestudy/views/main_view.dart';
import 'package:casestudy/widgets/auth_text_field.dart';
import 'package:casestudy/widgets/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../controllers/user_controller.dart';
import '../models/user_model.dart';
import '../utils/contants.dart';

class CreateUserView extends ConsumerWidget {
  CreateUserView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final userWatch = ref.watch(userController.notifier);
    final authWatch = ref.watch(authController.notifier);
    final userState = ref.watch(userController);
    final mainController = MainController();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CachedNetworkImage(imageUrl: Constants.kLogo, width: width * .5)),
                  SizedBox(height: height * .1,),
                  CustomTextField(
                    onChanged: (p0) {

                    },
                    isObscure: false,
                    hintText: "Ad - Soyad",
                    prefixIcon: Icons.person,
                    controller: userWatch.nameController,
                    validator: null,),
                  const SizedBox(height: 30,),
                  CustomTextField(
                    onChanged: (p0) {

                    },
                    isObscure: false,
                    hintText: "Email",
                    prefixIcon: Icons.email,
                    controller: userWatch.emailController,
                    validator: (p0) => AppValidators.emailValidator(p0)),
                  const SizedBox(height: 30,),
                  CustomTextField(
                    textInputType: TextInputType.datetime,
                    onChanged: (value) {

                    },
                    isObscure: false,
                    hintText: "Doğum Tarihi",
                    prefixIcon: Icons.cake,
                    isDate: true,
                    controller: userWatch.birthDateController,
                    validator: null),

                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 45, width: width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: MaterialButton(
                            height: 50,
                            color: Colors.deepOrange,
                            onPressed: () async {
                              if (_formKey.currentState == null) return;
                              if (!_formKey.currentState!.validate()) return;
                              UserModel user = UserModel(
                                  hobbies: userState.hobbies,
                                  birthdate: userWatch.birthDateController.text,
                                  uid: FirebaseAuth.instance.currentUser!.uid,
                                  name: userWatch.nameController.text,
                                  email: userWatch.emailController.text
                              );
                              Future.wait([authWatch.createNewUser(user)]);
                              Navigator.pushAndRemoveUntil(context, mainController.routeToGivenScreen(const MainView()), (route) => false);
                            },
                            child: const Center(child: Text("Tamamla", style: TextStyle(
                                fontSize: 17.5, fontWeight: FontWeight.bold, color: Colors.white
                            ),),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
