import 'package:flutter/material.dart';
import 'package:todo/database/my_database.dart';
import 'package:todo/dialoge_utils.dart';

import '../database/task.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.7,
      padding: EdgeInsets.all(12),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New Task',
              textAlign: TextAlign.center,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium,
            ),
            TextFormField(
              controller: titleController,
              validator: (text) {
                if (text == null || text
                    .trim()
                    .isEmpty) {
                  return 'please enter title';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: descController,
              validator: (text) {
                if (text == null || text
                    .trim()
                    .isEmpty) {
                  return 'please enter description';
                }
                return null;
              },
              style: Theme
                  .of(context)
                  .textTheme
                  .titleSmall,
              maxLines: 4,
              minLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text('Select Date',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleSmall,),
            InkWell(
              onTap: () {
                showDateDialog();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('${selectedDate.year}/${selectedDate.month}/${selectedDate.day}'),
              ),
            ),
            ElevatedButton(onPressed: () {
              addTask();
            }, child: Text('Submit'))
          ],
        ),
      ),
    );
  }
  DateTime selectedDate = DateTime.now();
  void showDateDialog() async{
    DateTime? date = await showDatePicker(context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if(date!=null){
      setState((){
        selectedDate =date;
      });
    }
  }
  void addTask() {
    if (formKey.currentState?.validate() == true) {
      String title = titleController.text;
      String desc = descController.text;
      Task task = Task(
        title: title,
        description: desc,
        dateTime: selectedDate,
        isDone: false
      );
      showLoading(context, 'loading...',isCancelable:false);
      MyDatabase.insertTask(task)
      .then((value) {
        hideLoading(context);
        // called when task is completed
        // show message
        showMessage(context, 'Task added successful',
            posActionName: 'ok',posAction: (){
          Navigator.pop(context);
        });
      }).onError((error, stackTrace){
        // called when task fails
        showMessage(context, 'something went wrong, try again later');
      }).timeout(Duration(seconds: 5),
      onTimeout: (){
        // save changes in cache
        showMessage(context, 'task save locally');
      });
    }
  }
}
