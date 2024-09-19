import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_project/database/App_user.dart';

class UserCollections{
  CollectionReference<AppUser> getUserCollection() {
    var db = FirebaseFirestore.instance;
    return db.collection("users")
        .withConverter<AppUser>(
      fromFirestore: (snapshot, options) {
        return AppUser.fromFireStore(snapshot.data());
      },
      toFirestore: (user, options) {
        return user.toFirebase();
      },
    );
  }
  Future<void> createUse(AppUser user){
return getUserCollection().doc(user.authId).set(user);

}

  Future<AppUser?> readUser(String uid)async {
    var doc=getUserCollection().doc(uid);
   var docSnapshot= await doc.get();
   return docSnapshot.data();
  }
}