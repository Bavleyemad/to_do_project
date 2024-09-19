import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_project/database/App_user.dart';
import 'package:to_do_project/database/task_name.dart';

class TaskCollections{
  CollectionReference<Task> getTaskCollection(userId) {
    var db = FirebaseFirestore.instance;
    return db.collection("users").doc(userId).collection("tasks")
        .withConverter(
      fromFirestore: (snapshot, options) {
        return Task.fromFireStore(snapshot.data());
      },
      toFirestore: (task, options) {
        return task.toFireStore();
      },
    );
  }
   Future<void>CreateTask(String userId,Task task){
var docRef=getTaskCollection(userId).doc();
task.id=docRef.id;
 return docRef.set(task);

  }
 Future<List<Task>>getAllTasks(String userId,int
      selectedDate)async{
   var querySnapshot=await getTaskCollection(userId).where("data",isEqualTo: selectedDate).
   orderBy("time",descending: false)
       .get();
   var tasksList=querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  return tasksList;
  }

  Future<void> removeTask( String userId, Task task) {
var docRef=getTaskCollection(userId).doc(task.id??"");
return docRef.delete();

  }
  Future<void> editTask(String userId, Task task) {
    if (task.id == null) {
      throw Exception("Task ID cannot be null for editing");
    }
    var docRef = getTaskCollection(userId).doc(task.id);
    return docRef.update(task.toFireStore());
  }
}