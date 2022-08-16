import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  required function,
  required String text,
  bool isUpperCase = true,
  double radius = 0.0,
}) =>
    Container(
      width: width,
      height: 40,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType tybe,
  required validator,
  onChange,
  required String label,
  required IconData prefix,
  onTap,
  bool isClickable = true,
  bool ispassword = false,
  IconData? suffix,
  suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: tybe,
      validator: validator,
      onChanged: onChange,
      onTap: onTap,
      obscureText: ispassword,
      enabled: isClickable,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(
                  suffix,
                ),
                onPressed: suffixPressed,
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text("${model["time"]}"),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model["title"]}",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${model["date"]}",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
                );
              },
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            // IconButton(
            //   onPressed: () {
            //     AppCubit.get(context).updateData(
            //       states: 'done',
            //       id: model['id'],
            //     );
            //   },
            //   icon: const Icon(
            //     Icons.check_box,
            //     color: Colors.green,
            //   ),
            // ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'archive',
                  id: model['id'],
                );
              },
              icon: Icon(
                Icons.archive,
                color: Colors.black45,
              ),
            ),
            // IconButton(
            //   onPressed: () {
            //     AppCubit.get(context).updateData(
            //       states: 'archived',
            //       id: model['id'],
            //     );
            //   },
            //   icon: const Icon(
            //     Icons.archive,
            //     color: Colors.black45,
            //   ),
            // ),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
    );

Widget tasksBuilder({
  required List<Map> tasks,
}) =>
    ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => myDivider(),
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              "No Tasks Yet,Please Add Some Tasks",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
Widget myDivider() => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey[300],
      ),
    );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
