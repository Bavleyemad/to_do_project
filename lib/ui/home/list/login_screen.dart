import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_project/providers/authproviders.dart';
import 'package:to_do_project/ui/home/home_screen.dart';
import 'package:to_do_project/ui/home/list/Register_screen.dart';
import 'package:to_do_project/ui/widgets/text_form.dart';
import 'package:to_do_project/ui/widgets/validtion.dart';

import '../../widgets/dialodgists.dart';
import '../../widgets/firebaseauthcodes.dart';
class Loginscreen extends StatefulWidget {
  static const String routname="loginScreen";
  GlobalKey<FormState> formkey=GlobalKey<FormState>();
  Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Loginscreen> {
  bool issecu=false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Color(0xff004182),
      body: SingleChildScrollView(
        child: Form(
          key: widget.formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 120,),
              AppFormField(title: "ENTER U EMAIL", label: "EMAIL",inputType: TextInputType.emailAddress,icon: Icon(Icons.email),validatior: (text) {
                if(text?.trim().isEmpty==true){
                  return"please enter your Email";
                }
                if(!Validator.isValidEmail(text!)){
                  return "please enter valid email";

                }
                return null;
              }),
              SizedBox(height: 30,),
              AppFormField(title: "ENTER U PASSWORD", label: "Password",inputType: TextInputType.text,icon: InkWell(
                  onTap:
                      () {
                    setState(() {
                      issecu=!issecu;
                    });
                  },
                  child: Icon(issecu==false?Icons.remove_red_eye:CupertinoIcons.eye_slash_fill)),isSecure: issecu,
                  validatior: (text) {
                    if(text?.trim().isEmpty==true){
                      return"please enter password";
                    }
                    if(!ValidationOfPass.isValidPassword(text!)){
                      return "please enter valid pass";

                    }
                    return null;
                  }),
              SizedBox(height: 30,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child:   ElevatedButton(

                    style:ElevatedButton.styleFrom(

                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

                        backgroundColor: Colors.white,

                        padding:EdgeInsets.symmetric(vertical: 12)),

                    onPressed: (){

                      login();

                    }, child: Text("Login",

                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),)),

              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have ana account ! ",style: Theme.of(context).textTheme.titleMedium?.copyWith(color:Colors.white),),
                  TextButton(onPressed: (){
                    Navigator.pushReplacementNamed(context, RegisterScreen.routname);
                  }, child: Text("Create account",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color:Colors.white,decoration: TextDecoration.underline)))
                ],
              )
            ],

          ),
        ),
      ),

    );
  }
  void login(){
    if(widget.formkey.currentState?.validate()==false){
      return;
    }
    signin(context);
  }
  void signin(BuildContext context)async {
    print("hellllos");
    var Authprovider=Provider.of<AuthProviders>(context,listen: false);
    try {
      print("finalllly");
      final appUser = await Authprovider.
      signinUserwithEmailandPassword(email.text, password.text);
      print("after app ");
      if(appUser==null){
          showMessageDialog(
          context,
          "something wrong",
          posButtonTitle: "tryAgain",
          posButtonAction: () {
            signin(context);
          },
        );
      }
      else{
        showMessageDialog(
          context,
          "logging Successful",
          posButtonTitle: "OK",
          posButtonAction: () {
            Navigator.pushReplacementNamed(
                context,
                HomeScreen.routename);
          },
        );
      }
      // await credential.user?.sendEmailVerification();
      // print('Account created successfully. Verification email sent.');
    } on FirebaseAuthException catch (e) {
      String message="somethind went wrong";
      print("error is${e.code}");
      if (e.code==FirebaseAuthCodes.wrong_password||
          e.code==FirebaseAuthCodes.user_not_found
      ) {
        message= "Wrong Email or  Password.";
        print('Wrong Email or  Password.');
      }
      if(e.code==FirebaseAuthCodes.invalid_channl){
        showMessageDialog(
          context,
          "loggings Successful",
          posButtonTitle: "OK",
          posButtonAction: () {
            Navigator.pushReplacementNamed(
                context,
                HomeScreen.routename);
          },
        );
      }
      showMessageDialog(
          context,
          message,
          posButtonTitle: "OK",
          posButtonAction: () {
            // Handle the error case
          }
      );

    }
    catch (e) {
      print(e);
    }
  }
}

