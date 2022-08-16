import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shared/componentes.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget

// 1- Create Database
//2_ Create Table
//3- Open Database
//4- Insert to Database
//5-Get From Database
//6- UpData in Database
//7- Delete From Database
{
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit()..createDatabase(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {
            if (state is AppInsertDataBaseState) {
              Navigator.pop(context);
            }
          },
          builder: (BuildContext context, AppStates state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentIndex]),
              ),
              body: ConditionalBuilder(
                condition: state is! AppGetDataBaseLoadingState,
                builder: (contex) => cubit.screens[cubit.currentIndex],
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formkey.currentState!.validate()) {
                      cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                      );
                      // insertToDatabase(
                      //   title: titleController.text,
                      //   time: timeController.text,
                      //   date: dateController.text,
                      //
                      // ).then((value) {
                      //   getDataFromDatabase(database).then((value) {
                      //     Navigator.pop(context);
                      //     // setState(() {
                      //     //
                      //     // isBottomSheetShown=false;
                      //     //
                      //     // fabIcon=Icons.edit;
                      //     // tasks = value;
                      //     // print(tasks);
                      //     //
                      //     //
                      //     // });
                      //
                      //   });
                      // });
                    }
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) => Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(20.0),
                            child: Form(
                              key: formkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                    controller: titleController,
                                    tybe: TextInputType.text,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Value Must Not Be Empty";
                                      }
                                    },
                                    label: "Task Title",
                                    prefix: Icons.title,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                    controller: timeController,
                                    tybe: TextInputType.datetime,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Time Must Not Be Empty";
                                      }
                                    },
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                        print(value.format(context));
                                      });
                                    },
                                    label: "Task Time",
                                    prefix: Icons.watch_later_outlined,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                    controller: dateController,
                                    tybe: TextInputType.datetime,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Date Must Not Be Empty";
                                      }
                                    },
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse("2022-09-13"),
                                      ).then((value) {
                                        print(
                                            DateFormat.yMMMd().format(value!));
                                        dateController.text =
                                            DateFormat.yMMMd().format(value);
                                      });
                                    },
                                    label: "Task Date",
                                    prefix: Icons.calendar_today,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          elevation: 20.0,
                        )
                        .closed
                        .then((value) {
                      cubit.ChangeBottomSheetState(
                        show: false,
                        icon: Icons.edit,
                      );
                    });
                    cubit.ChangeBottomSheetState(
                      show: true,
                      icon: Icons.add,
                    );
                  }
                },
                child: Icon(
                  cubit.fabIcon,
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.ChangeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: "Tasks",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: "Done",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: "Archived",
                  ),
                ],
              ),
            );
          },
        ));
  }
//Instance of 'Future<String>'
//   Future <String> getName()async
//   {
//     return "Osama Kamel";
//   }

}
