import 'package:flutter/material.dart';
import 'package:flutter_firebase_connection/constants/colors.dart';
import 'package:flutter_firebase_connection/constants/utils.dart';
import 'package:flutter_firebase_connection/screens/events/events.dart';
import 'package:flutter_firebase_connection/screens/home/dialog_box.dart';
import 'package:flutter_firebase_connection/screens/home/home_screen.dart';
import 'package:flutter_firebase_connection/screens/profile/user_profile.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentTabIndex = 0;
  final List<Widget> screens = [
    const HomeScreen(),
    CompletedTasks(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreen();

  void _onPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog(
          onSave: (taskName, description, type, date, time) {
            debugPrint("$taskName+$description+$type+$date+$time");
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressed,
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add_task_sharp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: Utils.height(0.070, context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const HomeScreen();
                        _currentTabIndex = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: _currentTabIndex == 0
                              ? AppColors.primaryColor
                              : Colors.grey[400],
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                              color: _currentTabIndex == 0
                                  ? AppColors.primaryColor
                                  : Colors.grey[400]),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = CompletedTasks();
                        _currentTabIndex = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task,
                          color: _currentTabIndex == 1
                              ? AppColors.primaryColor
                              : Colors.grey[400],
                        ),
                        Text(
                          "Complete Task",
                          style: TextStyle(
                              color: _currentTabIndex == 1
                                  ? AppColors.primaryColor
                                  : Colors.grey[400]),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const UserProfile();
                        _currentTabIndex = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: _currentTabIndex == 3
                              ? AppColors.primaryColor
                              : Colors.grey[400],
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(
                              color: _currentTabIndex == 3
                                  ? AppColors.primaryColor
                                  : Colors.grey[400]),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = CompletedTasks();
                        _currentTabIndex = 4;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings,
                          color: _currentTabIndex == 4
                              ? AppColors.primaryColor
                              : Colors.grey[400],
                        ),
                        Text(
                          "Settings",
                          style: TextStyle(
                              color: _currentTabIndex == 4
                                  ? AppColors.primaryColor
                                  : Colors.grey[400]),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
