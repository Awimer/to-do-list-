import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/database/task.dart';

class MyDatabase {
  static CollectionReference<Task> getTaskCollection(){
    return FirebaseFirestore.instance
        .collection(Task.collectionName)
        .withConverter<Task>(fromFirestore: (snapshot,options){
      return Task.fromFireStore(snapshot.data()!);
    }, toFirestore: (task,options){
      return task.toFireStore();
    });
  }
  static Future<void> insertTask (Task task){
    var tasksCollection = getTaskCollection();
    var doc = tasksCollection.doc();
    task.id = doc.id;
    return doc.set(task);
  }
  static Future<List<Task>> getAllTasks()async{
    QuerySnapshot<Task> querySnapshot = await getTaskCollection()
        .get();
    List<Task> tasks = querySnapshot.docs.map((element) => element.data()).toList();
    return tasks;
  }
}