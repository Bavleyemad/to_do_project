import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_project/ui/home/home_screen.dart';
import 'package:to_do_project/ui/home/list/login_screen.dart';
import 'package:to_do_project/ui/widgets/dialodgists.dart';
import 'package:to_do_project/ui/widgets/firebaseauthcodes.dart';
import 'package:to_do_project/ui/widgets/text_form.dart';
import 'package:to_do_project/ui/widgets/validtion.dart';
import 'package:to_do_project/providers/authproviders.dart';
class RegisterScreen extends StatefulWidget {
  static const String routname="registerScreen";
  GlobalKey<FormState> formkey=GlobalKey<FormState>();
   RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
TextEditingController fullName=TextEditingController();
TextEditingController phone=TextEditingController();
TextEditingController email=TextEditingController();
TextEditingController password=TextEditingController();
class _RegisterScreenState extends State<RegisterScreen> {
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
              AppFormField(title: "ENTER U NAME", label: "Name",inputType: TextInputType.name,controller: fullName,icon: Icon(Icons.person),
                validatior: (text) {
if(text?.trim().isEmpty==true){
return"please enter your full name";
}
return null;
              },),
              SizedBox(height: 30,),
              AppFormField(title: "ENTER U PHONE", label: "PHONE",inputType: TextInputType.phone, controller: phone,icon: Icon(Icons.phone),),
              SizedBox(height: 30,),
              AppFormField(title: "ENTER U EMAIL", label: "EMAIL",inputType: TextInputType.emailAddress,controller: email,icon: Icon(Icons.email),validatior: (text) {
                if(text?.trim().isEmpty==true){
                  return"please enter your Email";
                }
                if(!Validator.isValidEmail(text!)){
                  return "please enter valid email";

                }
                return null;
              }),
              SizedBox(height: 30,),
              AppFormField(title: "ENTER U PASSWORD", label: "Password",inputType: TextInputType.text,controller: password,icon: InkWell(
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

        register();

  }, child: Text("Sign up",

    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),)),
),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Alrady have account?  ",style: Theme.of(context).textTheme.titleMedium?.copyWith(color:Colors.white),),
                  TextButton(onPressed: (){
                    Navigator.pushReplacementNamed(context, Loginscreen.routname);
                  }, child: Text("Signin",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color:Colors.white,decoration: TextDecoration.underline)))
                ],
              )
            ],
          ),
        ),
      ),

    );
  }
  void register(){
    if (Ensurelogin()==true) {
      showLoadingDialog(context, message:
      'wait');

Future.delayed(Duration(seconds: 3),(){
  Navigator.pop(context);
}).then((value) {
  if(widget.formkey.currentState?.validate()==false){
    return;
  }
  createAccount(context);



},);

    } else {
      showMessageDialog(
        context,
        "Error",
        posButtonTitle: "OK",
        posButtonAction: () {
          // Handle the error case
        },
      );
      return; // Stop further execution if the fields are not valid
    }


  }
}

void createAccount(BuildContext context)async {
var Authprovider=Provider.of<AuthProviders>(context,listen: false);
  try {
    final appuser = await Authprovider.
    createUserwithEmailandPassword(email.text, password.text,fullName.text);
   // await credential.user?.sendEmailVerification();
   // print('Account created successfully. Verification email sent.');
   if(appuser==null){
     showMessageDialog(
       context,
       "something went wrong",
       posButtonTitle: "try again",
       posButtonAction: () {
         createAccount(context);
       },
     );
   }
    else{
     showMessageDialog(
       context,
       "Registration Successful",
       posButtonTitle: "OK",
       posButtonAction: () {
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) => HomeScreen()),
         );
       },
     );
   }

  } on FirebaseAuthException catch (e) {
    String message="something went wrong";
    print(e.code);
    if (e.code==FirebaseAuthCodes.weakpaass) {
      message= "The password provided is too weak.";
      print('The password provided is too weak.');
    } else if (e.code == FirebaseAuthCodes.usedEmail) {
     message= "The account already exists for that email.and click on Signin ";

     print('The account already exists for that email.');
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
bool Ensurelogin() {
  return Validator.isValidEmail(email.text) &&
      ValidationOfPass.isValidPassword(password.text) &&
      fullName.text.isNotEmpty &&
      password.text.isNotEmpty;
}
