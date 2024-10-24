import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_connection/constants/colors.dart';
import 'package:flutter_firebase_connection/constants/utils.dart';
import 'package:flutter_firebase_connection/screens/auth/login_screen.dart';
import 'package:flutter_firebase_connection/screens/events/events.dart';
import 'package:flutter_firebase_connection/widgets/popup_menu.dart';
import 'package:intl/intl.dart';
import 'dialog_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  final List<String> dropdownItems = ['Personal', 'Work'];
  late String dropdownValue = dropdownItems.first;
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userID = FirebaseAuth.instance.currentUser!.uid;
  String userName = '';

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void _logout() {
    _auth.signOut().then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
      Utils.showToastMessage("Successfully logged out");
    }).onError((error, stackTrace) {
      String errorMessage = error.toString();
      int index = errorMessage.indexOf("] ");
      if (index > 0) {
        errorMessage = errorMessage.substring(index + 2);
      }
      Utils.showToastMessage(errorMessage.toString());
    });
  }

  Future<void> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userName = userDoc['displayName'];
      });
    }
  }

  Future<void> _showEditDialog(Map<String, dynamic> taskData) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog(
          onSave: (taskName, description, type, date, time) {
            debugPrint("${taskName}+${description}+${type}+${date}+${time}");
          },
          tasksData: taskData,
        );
      },
    );
  }

  void _deleteTask(String taskId) async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final fireStore = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('tasks');

    try {
      await fireStore.doc(taskId).delete();
      Utils.showToastMessage("Task deleted successfully");
    } catch (error) {
      Utils.showToastMessage("Error deleting task: $error");
    }
  }

  void _handleMenu(String value, Map<String, dynamic> taskData) {
    switch (value) {
      case 'Edit':
        _showEditDialog(taskData);
        debugPrint(taskData.toString());
        break;
      case 'Delete':
        _deleteTask(taskData['id']);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: Icon(
        //   Icons.menu,
        //   color: AppColors.primaryColor,
        // ),
        actions: [
          GestureDetector(
            onTap: _logout,
            child: Container(
              width: Utils.width(0.1, context),
              height: Utils.height(0.1, context),
              decoration: BoxDecoration(
                  color: AppColors.primaryColor, shape: BoxShape.circle),
              child: Icon(
                Icons.person,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                '$userName!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Text(
                    'Hello',
                    style: TextStyle(fontSize: 40),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      '$userName!',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Text(
                'Have a nice day!',
                style: TextStyle(color: Colors.grey),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('users')
                    .doc(userID)
                    .collection('tasks')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: Utils.height(0.3, context),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text("Error");
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return SizedBox(
                      height: Utils.height(0.3, context),
                      child: Center(child: Text("No task found")),
                    );
                  }
                  return SizedBox(
                    height: Utils.height(0.3, context),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var tasksOfUser = snapshot.data!.docs[index];
                        var taskData =
                            tasksOfUser.data() as Map<String, dynamic>;
                        DateTime dueDate =
                            DateTime.parse(tasksOfUser['dueDate']);
                        String formattedDate =
                            DateFormat('EEE MMM d yyyy').format(dueDate);
                        return Container(
                          width: Utils.width(0.5, context),
                          margin: EdgeInsets.all(8.0),
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.darkPrimaryColor,
                                          shape: BoxShape.circle),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.person,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      tasksOfUser['type'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  PopupMenu(
                                    menuItems: <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: 'Edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit,
                                                color: Colors.black),
                                            SizedBox(width: 10),
                                            Text('Edit',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'Delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete_forever,
                                                color: Colors.black),
                                            SizedBox(width: 10),
                                            Text('Delete',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) =>
                                        _handleMenu(value, taskData),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                tasksOfUser['taskName'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 10),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 12),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                            ),
                                          ),
                                          padding: EdgeInsets.all(20.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Task Details",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                "Task Name: ${tasksOfUser['taskName']}",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                "Description: ${tasksOfUser['description']}",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                "Due Date: ${tasksOfUser['dueDate']}",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                "Due Time: ${tasksOfUser['time']}",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                "Type: ${tasksOfUser['type']}",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Align(
                                  alignment: FractionalOffset.bottomRight,
                                  child: Text(
                                    "More details",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Upcoming Tasks",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                    color: Colors.grey[200],
                    height: Utils.height(0.3, context),
                    width: Utils.width(0.9, context),
                    child: ListView(
                      padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, left: 8.0, right: 8.00),
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              leading: Container(
                                width: Utils.width(0.1, context),
                                height: Utils.height(0.1, context),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.task,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text('Today'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TodayTasks(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, left: 8.0, right: 8.0),
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              leading: Container(
                                width: Utils.width(0.1, context),
                                height: Utils.height(0.1, context),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.task,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text('Tommorrow Tasks'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TomorrowTasks(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, left: 8.0, right: 8.0),
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              leading: Container(
                                width: Utils.width(0.1, context),
                                height: Utils.height(0.1, context),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.task,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text('This week Tasks'),
                              style: ListTileStyle.list,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ThisWeekTasks(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
