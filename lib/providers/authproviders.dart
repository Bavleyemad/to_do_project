
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_project/database/App_user.dart';
import 'package:to_do_project/database/user_collections.dart';

class AuthProviders extends ChangeNotifier{
UserCollections userCollections=UserCollections();
User? authUser;
AppUser? appUser;
AuthProviders(){
  authUser=FirebaseAuth.instance.currentUser;
  if(authUser!=null){
signInWithUid(authUser!.uid);
  }
}
void signInWithUid(String uid)async{
  appUser=await userCollections.readUser(uid);
   notifyListeners();
}
bool isLogged(){
  return authUser!=null;
}
void login(User newuser){
authUser=newuser;
notifyListeners();
}
void Logout(){
  authUser=null;
  FirebaseAuth.instance.signOut();
}
Future<AppUser?> createUserwithEmailandPassword (String email,String password,String fullname)async{
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(

      email: email,
      password: password);
  if(credential.user !=null){
    login(credential.user!);
     appUser=AppUser(authId: credential.user?.uid,Email:email ,FullName:fullname );
    var result= await userCollections.createUse(appUser!);
    return appUser;
  }
return null;
}
Future<AppUser?> signinUserwithEmailandPassword (String email,String password)async{
  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password);

  if(credential.user!=null){
login(credential.user!);
appUser=await userCollections.readUser(credential.user!.uid);
  }
  return appUser;
}
}