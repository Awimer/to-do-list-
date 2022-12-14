import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/database/my_database.dart';
import 'package:todo/database/task.dart';
import 'package:todo/dialoge_utils.dart';
import 'package:todo/my_theme.dart';

class TaskWidget extends StatelessWidget{
  Task task;
  TaskWidget(this.task);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Slidable(
        startActionPane: ActionPane(
          motion: DrawerMotion(),
          children: [
            SlidableAction(onPressed: (_){
              MyDatabase.deleteTask(task)
                  .then((value) {
                    showMessage(context, 'Task deleted successfully'
                        ,posActionName: 'ok');
              })
                  .onError((error, stackTrace) {
                showMessage(context, 'something went wrong'
                ,posActionName: 'please try again later');
              })
                  .timeout(Duration(seconds: 5),onTimeout: (){
                    showMessage(context, 'Data deleted locally',posActionName: 'ok');
              });
            },
              icon: Icons.delete,
              backgroundColor: MyTheme.red,
              label: 'Delete',
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12),bottomLeft: Radius.circular(12)),
            ),
          ],
        ),

        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).primaryColor,
                ),
              ),
            SizedBox(width: 8,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(task.title??'',style: Theme.of(context).textTheme.titleMedium,),
                SizedBox(height: 8,),
                Row(children: [
                  Icon(Icons.access_time,),
                  Text(task.description??'',style:Theme.of(context).textTheme.bodySmall,)
                ],),
              ],),
            ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).primaryColor,
                ),
                child: Icon(Icons.check,color: Colors.white,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}