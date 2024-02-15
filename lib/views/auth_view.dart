import 'package:cached_network_image/cached_network_image.dart';
import 'package:casestudy/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';
import '../services/authentication_service.dart';
import '../utils/contants.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/validators.dart';

class AuthView extends ConsumerWidget {
  AuthView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final authState = ref.watch(authController);
    final authWatch = ref.watch(authController.notifier);
    final mainController = MainController();

    return Scaffold(
      body: Form(
        key: _formKey,

        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: height * .1,),
                  CachedNetworkImage(imageUrl: Constants.kLogo, width: width * .5),
                  SizedBox(height: height * .1,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Column(
                      children: [
                        CustomTextField(
                          onChanged: (p0) {

                          },
                          hintText: "Email",
                          isObscure: false,
                          prefixIcon: Icons.email,
                          controller: authWatch.emailController,
                          validator: AppValidators.emailValidator,
                        ),
                        const SizedBox(height: 20,),
                        CustomTextField(
                          onChanged: (p0) {

                          },
                          hintText: "Şifre",
                          isObscure: true,
                          prefixIcon: Icons.lock,
                          validator: AppValidators.passwordValidator,
                          controller: authWatch.passwordController,
                        ),
                        const SizedBox(height: 20,),
                        authState.isRegister ? CustomTextField(
                          onChanged: (p0) {

                          },
                          hintText: "Şifre Tekrar",
                          isObscure: true,
                          prefixIcon: Icons.lock,
                          controller: authWatch.passwordRepeatController,
                          validator: (p0) => AppValidators.confirmPasswordValidator(authWatch.passwordController.text, p0),
                        ) : Container(),
                        SizedBox(height: authState.isRegister ? 20 : 0,),
                        FutureBuilder(
                            future: Authentication.initializeFirebase(context: context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return Container(
                                  width: width, height: height * .05,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),

                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: MaterialButton(
                                      onPressed: () async {
                                        if (_formKey.currentState == null) return;
                                        if (!_formKey.currentState!.validate()) return;
                                        authWatch.handleEmailSignIn(context, mainController);


                                      },
                                      color: Colors.deepOrangeAccent,
                                      child: Center(child: Text(authState.isRegister ? "Kayıt Ol" : "Giriş Yap",
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                width: width, height: height * .05,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (_formKey.currentState == null) return;
                                      if (!_formKey.currentState!.validate()) return;
                                    },
                                    color: Colors.deepPurpleAccent,
                                    child: const Center(child: CircularProgressIndicator(
                                        color: Colors.white),),
                                  ),
                                ),
                              );
                            }
                        ),
                        TextButton(
                          onPressed: () {
                            authWatch.switchRegister();
                          },
                          child: Text(authState.isRegister ? "Hesabım Var" : "Hesap Oluştur", style: const TextStyle(
                              fontSize: 13, color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold
                          )),
                        ),
                      ],
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
