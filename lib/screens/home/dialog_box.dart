import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_firebase_connection/constants/time_utils.dart';
import 'package:flutter_firebase_connection/constants/utils.dart';
import 'package:flutter_firebase_connection/constants/colors.dart';
import 'package:flutter_firebase_connection/widgets/input_feild.dart';

import '../../widgets/loading.dart';

//stateless widgetss
class AddTaskDialog extends StatefulWidget {
  final Function(String, String, String, String, String) onSave;
  final Map<String, dynamic>? tasksData;

  const AddTaskDialog({super.key, required this.onSave, this.tasksData});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final List<String> dropdownItems = ['Personal', 'Work', 'Events'];
  late String _dropdownValue = dropdownItems.first;
  final _taskNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _dueDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _dueTime = DateFormat('hh:mm a').format(DateTime.now());
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    if (widget.tasksData != null) {
      _taskNameController.text = widget.tasksData!['taskName'];
      _descriptionController.text = widget.tasksData!['description'];
      _dropdownValue = widget.tasksData!['type'];
      _dueDate = widget.tasksData!['dueDate'];
      _dueTime = widget.tasksData!['time'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 8,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      title: widget.tasksData == null
          ? const Text("Add new task")
          : const Text("Edit task"),
      content: SizedBox(
        width: Utils.width(1.0, context),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    InputFeild(
                      keyboardType: TextInputType.text,
                      controller: _taskNameController,
                      labelText: "Title",
                      showBorder: false,
                      validator: (value) =>
                          value!.isEmpty ? "Enter Title" : null,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(
                width: Utils.width(1.0, context),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      InputFeild(
                        keyboardType: TextInputType.text,
                        controller: _descriptionController,
                        labelText: "Description",
                        showBorder: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the task description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Select Type',
                          border: OutlineInputBorder(),
                        ),
                        value: _dropdownValue,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a type';
                          }
                          return null;
                        },
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _dropdownValue = newValue;
                            });
                          }
                        },
                        items: dropdownItems
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Due Date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _dueDate,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            child: const Icon(
                              Icons.calendar_today,
                              size: 40,
                              color: AppColors.primaryColor,
                            ),
                            onTap: () async {
                              DateTime? selectedDate =
                                  await TimeUtils.pickDate(context);
                              if (selectedDate == null) return;
                              setState(() {
                                _dueDate = DateFormat('yyyy-MM-dd')
                                    .format(selectedDate);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Time",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _dueTime,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            child: const Icon(
                              Icons.timelapse,
                              size: 50,
                              color: AppColors.primaryColor,
                            ),
                            onTap: () async {
                              TimeOfDay? selectedTime =
                                  await TimeUtils.pickTime(context);
                              if (selectedTime == null) return;
                              setState(() {
                                _dueTime = selectedTime.format(context);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                elevation: 10,
                                shadowColor: AppColors.primaryColor,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel")),
                          const SizedBox(
                            width: 10,
                          ),
                          Loading(isLoading: isLoading),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                elevation: 10,
                                shadowColor: AppColors.primaryColor,
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  widget.onSave(
                                    _taskNameController.text,
                                    _descriptionController.text,
                                    _dropdownValue,
                                    _dueDate,
                                    _dueTime,
                                  );
                                  if (mounted) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                  }
                                  String id = widget.tasksData == null
                                      ? DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toString()
                                      : widget.tasksData!['id'];

                                  final data = {
                                    'id': id,
                                    'taskName': _taskNameController.text,
                                    'description': _descriptionController.text,
                                    'type': _dropdownValue,
                                    'dueDate': _dueDate,
                                    'time': _dueTime,
                                    'isCompleted': false
                                  };
                                  final userID = _auth.currentUser!.uid;
                                  DocumentReference userDocRef =
                                      fireStore.doc(userID);
                                  CollectionReference tasksCollection =
                                      userDocRef.collection('tasks');

                                  if (widget.tasksData == null) {
                                    tasksCollection
                                        .doc(id)
                                        .set(data)
                                        .then((value) {
                                      Utils.showToastMessage(
                                          "Saved Data Successfully");
                                      if (mounted) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                      Navigator.of(context).pop();
                                    }).onError((error, stackTrace) {
                                      print('Error adding document: $error');
                                      if (mounted) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                      Utils.showToastMessage("Error:$error");
                                      Navigator.of(context).pop();
                                    });
                                  } else {
                                    tasksCollection
                                        .doc(widget.tasksData!['id'])
                                        .update(data)
                                        .then((value) {
                                      Utils.showToastMessage(
                                          "Updated Data Successfully");
                                      if (mounted) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                      Navigator.of(context).pop();
                                    }).onError((error, stackTrace) {
                                      print('Error updating document: $error');
                                      if (mounted) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                      Utils.showToastMessage("Error:$error");
                                      Navigator.of(context).pop();
                                    });
                                  }
                                }
                              },
                              child: widget.tasksData == null
                                  ? const Text("Add new task")
                                  : const Text("Update")),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
