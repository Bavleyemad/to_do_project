class AppUser{
String? authId;
String? FullName;
String? Email;
AppUser({this.authId,this.Email,this.FullName});
AppUser.fromFireStore(Map<String,dynamic>? data){
  this.authId=data?["authId"];
  this.FullName=data?["FullName"];
  this.Email=data?["Email"];
}
Map<String,dynamic> toFirebase(){
  return{
    "authId":authId,
    "FullName":FullName,
    "Email":Email
  };
}
}