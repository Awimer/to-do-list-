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
  static void insertTask (Task task){
    var tasksCollection = getTaskCollection();
    var taskDoc = tasksCollection.doc();
    task.id = taskDoc.id;
    taskDoc.set(task);
  }
}