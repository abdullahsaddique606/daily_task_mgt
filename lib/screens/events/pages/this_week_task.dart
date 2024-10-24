import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_connection/constants/utils.dart';
import 'package:flutter_firebase_connection/screens/events/controllers/task_selection_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ThisWeekTasks extends StatefulWidget {
  ThisWeekTasks({super.key});

  @override
  _ThisWeekTasksState createState() => _ThisWeekTasksState();
}

class _ThisWeekTasksState extends State<ThisWeekTasks> {
  String userID = FirebaseAuth.instance.currentUser!.uid;
  final _firestore = FirebaseFirestore.instance;
  final _selectedTaskIds = <String>{};
  List<Map<String, dynamic>> _tasks = [];

  // final TaskSelectionController taskSelectionController = Get.put(TaskSelectionController());

  // void _completeTasks() {
  //   print('Completed tasks: ${selectedTaskIds.toList()}');
  // }

  List<DateTime> _getDaysOfWeek() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    DateTime monday = now.subtract(Duration(days: currentWeekday - 1));

    List<DateTime> daysOfWeek = [];
    for (int i = 0; i < 7; i++) {
      daysOfWeek.add(monday.add(Duration(days: i)));
    }
    return daysOfWeek;
  }

  void _getTaskOfDay(String currentDay) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userID)
        .collection('tasks')
        .where('dueDate', isEqualTo: currentDay)
        .get();
    if (querySnapshot.docs.isEmpty) {
      print("No data for selected date");
    } else {
      List<Map<String, dynamic>> _tempTasks = [];
      querySnapshot.docs.forEach((document) {
        _tempTasks.add(document.data() as Map<String, dynamic>);
      });
      setState(() {
        _tasks = _tempTasks;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> daysOfWeek = _getDaysOfWeek();
    DateFormat dateFormat = DateFormat('EEEE, MMM d');
    DateFormat dayFormat = DateFormat('d');
    DateFormat monthFormat = DateFormat('MMM');
    DateFormat yearFormat = DateFormat('y');

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
          "This week",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Container(
              height: Utils.height(0.2, context), // Adjust height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: daysOfWeek.length,
                itemBuilder: (context, index) {
                  DateTime day = daysOfWeek[index];
                  bool isSelectedDay =
                  _selectedTaskIds
                      .contains(day.toString());
                  String formattedSelectedDate =
                  DateFormat('yyyy-MM-dd').format(day);
                  return GestureDetector(
                    onTap: () {
                      debugPrint(
                          "item selected date is : ${formattedSelectedDate} ");

                      _getTaskOfDay(formattedSelectedDate);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: Utils.height(0.1, context),
                            width: Utils.width(0.150, context),
                            decoration: BoxDecoration(
                              color:
                              isSelectedDay ? Colors.red : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  monthFormat.format(day),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelectedDay
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  dayFormat.format(day),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelectedDay
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  yearFormat.format(day),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelectedDay
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: Utils.height(0.2, context),
              //color: Colors.white,
              child: _tasks.isEmpty ? Center(child: Text("No Task found"),) :
              ListView.builder(itemCount:_tasks.length, itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tasks[index]['taskName']),
                  subtitle: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.type_specimen_outlined),
                          SizedBox(width: 5),
                          Text(_tasks[index]['type']),
                          SizedBox(width: 10),
                          Icon(Icons.watch_later_outlined),
                          SizedBox(width: 5),
                          Text(_tasks[index]['time']),
                          SizedBox(width: 5),
                          _tasks[index]['isCompleted'] == true ?
                            Text(
                              'Completed',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ): Text(
                            'Uncompleted',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
