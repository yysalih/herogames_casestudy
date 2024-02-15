import 'package:cached_network_image/cached_network_image.dart';
import 'package:casestudy/controllers/main_controller.dart';
import 'package:casestudy/views/auth_view.dart';
import 'package:flutter/material.dart';

import '../utils/contants.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activateSplash();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(child: CachedNetworkImage(imageUrl: Constants.kLogo, width: width * .5)),

    );
  }

  activateSplash() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(context, MainController().routeToGivenScreen(AuthView()),
              (route) => false);
    },);
  }
}
