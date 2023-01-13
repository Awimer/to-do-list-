import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/database/task.dart';
import 'package:todo/date_utils.dart';

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
  static Future<QuerySnapshot<Task>> getAllTasks(DateTime selectedDate)async{
    // read data once
    return await getTaskCollection()
        .where('dateTime',isEqualTo:dateOnly(selectedDate).millisecondsSinceEpoch)
        .get();
  }
  static Stream<QuerySnapshot<Task>>
  listenForTasksRealTimeUpdates(DateTime selectedDate){
    // listen for real time updates
    return getTaskCollection()
        .where('dateTime',isEqualTo:dateOnly(selectedDate).millisecondsSinceEpoch)
        .snapshots();
  }
  static Future <void> deleteTask(Task task){
    var taskDoc = getTaskCollection()
        .doc(task.id);
    return taskDoc.delete();
  }

}