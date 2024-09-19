import 'dart:async';

import 'package:flutter/material.dart';
import 'package:to_do_project/ui/home/list/Register_screen.dart';
import 'package:to_do_project/ui/home/list/login_screen.dart';
class SplashScreen extends StatefulWidget {
  static const String routname="Splashscreen";
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 3), () {
      Navigator.pushNamedAndRemoveUntil(context, RegisterScreen.routname, (route) => false);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Image.asset("assets/images/splash@3x.png");
  }
}
