import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_connection/constants/colors.dart';

class CompletedTasks extends StatelessWidget {
  CompletedTasks({super.key});

  final _firestore = FirebaseFirestore.instance;
  final userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
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
            "Completed",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
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
              return task['isCompleted'] == true;
            }).toList();

            if (tasks.isEmpty) {
              return Center(child: Text("No completed tasks found"));
            }
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                return ListTile(
                  title: Text(task['taskName']),
                  subtitle: Text(task['description']),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Due: ${task['dueDate']}'),
                      Text('Time: ${task['time']}'),
                    ],
                  ),
                );
              },
            );
          },
        )
    );
  }
}
