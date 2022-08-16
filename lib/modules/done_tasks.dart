import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/componentes.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppCubit cubit= AppCubit.get(context);
    return BlocConsumer<AppCubit,AppStates>(
      listener:(context,state){} ,
      builder: (context,state)
      {
        var tasks =cubit.doneTasks;
        return tasksBuilder(
          tasks: tasks,
        );
      },
    );
  }
}
