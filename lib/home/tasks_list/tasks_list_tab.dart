import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/database/my_database.dart';
import 'package:todo/database/task.dart';
import 'package:todo/home/tasks_list/task_widget.dart';

class TasksListTab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CalendarTimeline(
            showYears: true,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(Duration(days: 365)),
            lastDate: DateTime.now().add(Duration(days: 365)),
            onDateSelected: (date) {
              //on user choose new date
            },
            leftMargin: 20,
            monthColor: Colors.black,
            dayColor: Colors.black,
            activeDayColor: Theme.of(context).primaryColor,
            activeBackgroundDayColor: Colors.white,
            dotsColor: Theme.of(context).primaryColor,
            selectableDayPredicate: (date) => true,
            locale: 'en_ISO',
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Task>>(
              stream: MyDatabase.listenForTasksRealTimeUpdates(),
              builder: (buildContext,snapshot){
                if (snapshot.hasError){
                  return Column(
                    children: [
                      Text('Error loading data,'
                          'please try again later')
                  ],);
                }
                else if (snapshot.connectionState == ConnectionState.waiting){
                  // is loading
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var data = snapshot.data?.docs.map((e) => e.data()).toList();
                return ListView.builder(itemBuilder: (buildContext,index){
                  return TaskWidget(data![index]);
                },itemCount: data!.length, );
              },
            ),
          )
        ],
      ),
    );
  }

}