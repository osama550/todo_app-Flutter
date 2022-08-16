import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archived_tasks.dart';
import 'package:to_do_app/modules/done_tasks.dart';
import 'package:to_do_app/modules/new_tasks.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<String> titles = ["New Tasks", "Done Tasks", "Archived Tasks"];

  void ChangeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  Database? database;

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      // id integer ,title string ,date string ,time string,status string
      print("Database Created");
      database
          .execute(
              'create table tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print("Table Created");
      }).catchError((error) {
        print("Error When Created Table ${error.toString()}");
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print("Database opened");
    }).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status)VALUES("$title","$date","$time","new")')
          .then((value) {
        print("$value INSERTED SUCCESSFULLY ");
        emit(AppInsertDataBaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print("Error When Inserting New Record ${error.toString()}");
      });
      // ignore: null_check_always_fails
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDataBaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element["status"] == "new")
          newTasks.add(element);
        else if (element["status"] == "done")
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDataBaseState());
    });
    ;
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    await database?.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      emit(AppUpdateDataBaseLoadingState());
      getDataFromDatabase(database);
    });
  }

  void deleteData({
    required int id,
  }) async {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDataBaseLoadingState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void ChangeBottomSheetState({
    required bool show,
    required IconData icon,
  }) {
    isBottomSheetShown = show;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
