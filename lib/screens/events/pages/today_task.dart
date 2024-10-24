import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_connection/constants/time_utils.dart';
import 'package:flutter_firebase_connection/screens/events/controllers/task_selection_controller.dart';
import 'package:get/get.dart';

class TodayTasks extends StatefulWidget {
  TodayTasks({super.key});

  @override
  _TodayTasksState createState() => _TodayTasksState();
}

class _TodayTasksState extends State<TodayTasks> {
  String userID = FirebaseAuth.instance.currentUser!.uid;
  final _firestore = FirebaseFirestore.instance;
  final TaskSelectionController taskSelectionController =
      Get.put(TaskSelectionController());

  void completeTasks(List<DocumentSnapshot> tasks) async {
    for (var taskId in taskSelectionController.selectedTaskIds) {
      var task = tasks.firstWhere((task) => task.id == taskId).data()
          as Map<String, dynamic>;
      task['isCompleted'] = true;
      await _firestore
          .collection('users')
          .doc(userID)
          .collection('tasks')
          .doc(taskId)
          .update(task);
    }
    taskSelectionController.selectedTaskIds.clear();
    taskSelectionController.selectAll.value = false;
  }

  void unCompleteTasks(List<DocumentSnapshot> tasks) async {
    for (var taskId in taskSelectionController.selectedTaskIds) {
      tasks.firstWhere((task) => task.id == taskId).data()
          as Map<String, dynamic>;
      await _firestore
          .collection('users')
          .doc(userID)
          .collection('tasks')
          .doc(taskId)
          .update({'isCompleted': false});
    }
    taskSelectionController.selectedTaskIds.clear();
    taskSelectionController.selectAll.value = false;
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Today",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('users')
                    .doc(userID)
                    .collection('tasks')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No tasks found"));
                  }

                  var tasks = snapshot.data!.docs.where((task) {
                    DateTime taskDate =
                        TimeUtils.parseDateString(task['dueDate']);
                    DateTime startOfToday = TimeUtils.getStartOfToday();
                    DateTime endOfToday = TimeUtils.getEndOfToday();
                    return taskDate.isAfter(
                            startOfToday.subtract(Duration(seconds: 1))) &&
                        taskDate.isBefore(endOfToday.add(Duration(seconds: 1)));
                  }).toList();

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Row(
                          children: [
                            Obx(
                              () => Checkbox(
                                value: taskSelectionController.selectAll.value,
                                onChanged: (value) {
                                  taskSelectionController.toggleSelectAll(
                                      value ?? false, tasks);
                                },
                              ),
                            ),
                            Text('Select All'),
                            Spacer(),
                            Obx(() => ElevatedButton(
                                  onPressed: taskSelectionController
                                              .selectedTaskIds.isNotEmpty &&
                                          taskSelectionController
                                              .isAnyTaskIncomplete(tasks)
                                      ? () => completeTasks(tasks)
                                      : null,
                                  child: Text('Complete'),
                                )),
                            SizedBox(width: 15),
                            Obx(() => ElevatedButton(
                                  onPressed: taskSelectionController
                                              .selectedTaskIds.isNotEmpty &&
                                          taskSelectionController
                                              .isAnyTaskComplete(tasks)
                                      ? () => unCompleteTasks(tasks)
                                      : null,
                                  child: Text('Not complete'),
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Card(
                                elevation: 2,
                                child: Obx(() {
                                  final isSelected = taskSelectionController
                                      .selectedTaskIds
                                      .contains(task.id);
                                  return CheckboxListTile(
                                    value: isSelected,
                                    onChanged: (bool? value) {
                                      debugPrint(
                                          "Value of checkBoxtlistitle: $value");
                                      debugPrint(
                                          "Value of isSelected: $isSelected");
                                      taskSelectionController
                                          .toggleSelect(task.id);
                                    },
                                    title: Text(task['taskName']),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.type_specimen_outlined),
                                            SizedBox(width: 5),
                                            Text(task['type']),
                                            SizedBox(width: 10),
                                            Icon(Icons.watch_later_outlined),
                                            SizedBox(width: 5),
                                            Text(task['time']),
                                            Spacer(),
                                            if (task['isCompleted'] == true)
                                              Text(
                                                'Completed',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
