import 'package:flutter/material.dart';
import 'package:todo/home/settings/settings_tab.dart';
import 'package:todo/home/tasks_list/tasks_list_tab.dart';

import 'add_task_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Todo List App c6 online'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: StadiumBorder(
          side: BorderSide(color: Colors.white,width: 4)
        ),
        onPressed: (){

        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index){
            selectedIndex = index;
            setState((){});
          },
          showUnselectedLabels: false,
          showSelectedLabels: false,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '')
          ],
        ),
      ),
      body: tabs[selectedIndex],
    );
  }
  var tabs = [TasksListTab(),SettingsTab()];

  void showAddTaskBottomSheet(){
    showModalBottomSheet(context: context, builder: (buildContext){
      return AddTaskBottomSheet();
    });
  }
}
