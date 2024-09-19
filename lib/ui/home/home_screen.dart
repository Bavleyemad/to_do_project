import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_project/database/task_collection.dart';
import 'package:to_do_project/database/task_name.dart';
import 'package:to_do_project/providers/authproviders.dart';
import 'package:to_do_project/providers/settings_providers.dart';
import 'package:to_do_project/providers/task_provider.dart';
import 'package:to_do_project/ui/home/list/login_screen.dart';
import 'package:to_do_project/ui/home/list/settings_screen.dart';
import 'package:to_do_project/ui/home/list/tasklist_tap.dart';
import 'package:to_do_project/ui/home/settings/settings_tap.dart';
import 'package:to_do_project/ui/widgets/add_taskSheet.dart';
import 'package:to_do_project/ui/widgets/dialodgists.dart';

import '../widgets/data_timefield.dart';
import 'package:to_do_project/App_date_utilts.dart';
class HomeScreen extends StatefulWidget {
  static const String routename = "home";

  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTabIndex = 0;
  final title = TextEditingController();
  final description = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final taps = [
    TaskListTap(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProviders>(context);
var settingsProvider=Provider.of<SettingsProvider>(context);
    return Scaffold(
      backgroundColor:settingsProvider.isDarkEnabled()?Color(0xffF1CFB) :Color(0xffDFECDB) ,
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              authProvider.Logout();
              Navigator.pushReplacementNamed(context, Loginscreen.routname);
            },
            child: Icon(Icons.logout),
          ),
        ],
        title: Text("Welcome ${authProvider.appUser?.FullName}"),
      ),
      floatingActionButton: FloatingActionButton(
        shape: StadiumBorder(side: BorderSide(color: Colors.white, width: 5)),
        onPressed: () {
          showAddTaskButtomSheet();
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              selectedTabIndex = value;
            });
          },
          currentIndex: selectedTabIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
          ],
        ),
      ),
      body: taps[selectedTabIndex],
    );
  }

  void showAddTaskButtomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (buildContext) {
        return Container(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AddTaskSheet(
                  title: "Task title",
                  validatior: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return "Please enter task title";
                    }
                    return null;
                  },
                  controller: title,
                ),
                AddTaskSheet(
                  title: "Task description",
                  lines: 3,
                  validatior: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return "Please enter task description";
                    }
                    return null;
                  },
                  controller: description,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DataTimeField(
                        title: "TaskDate",
                        hint: selectedDate == null
                            ? "Please select date"
                            : "${selectedDate?.formatDate()}",
                        onclick: () {
                          showDatePickerDialog();
                        },
                      ),
                    ),
                    Expanded(
                      child: DataTimeField(
                        title: "TaskTime",
                        hint: selectedTime == null
                            ? "Please select time"
                            : "${selectedTime?.formatTime()}",
                        editable: false,
                        onclick: () {
                          showTimePickerDialog();
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: ElevatedButton(
                    onPressed: () {
                      addTask();
                    },
                    child: Text("ADD Task"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  DateTime? selectedDate;
  void showDatePickerDialog() async {
    var date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date == null) return;

    setState(() {
      selectedDate = date;
    });
  }

  TimeOfDay? selectedTime;
  void showTimePickerDialog() async {
    var time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      selectedTime = time;
    });
  }

  bool isValidTask() {
    bool isValid = true;
    if (formKey.currentState?.validate() == false) {
      isValid = false;
    }
    if (selectedDate == null) {
      showMessageDialog(
        context,
        "Please select task date",
        posButtonTitle: "OK",
        posButtonAction: () {
          isValid = false;
        },
      );
    }
    if (selectedTime == null) {
      showMessageDialog(
        context,
        "Please select task time",
        posButtonTitle: "OK",
        posButtonAction: () {
          isValid = false;
        },
      );
    }
    return isValid;
  }

  void addTask() async {
    if (!isValidTask()) return;

    var authProvider = Provider.of<AuthProviders>(context, listen: false);
    var tasksProvider = TaskProvider.getInstance(context, listen: false);
    var task = Task(
      title: title.text,
      description: description.text,
      data: selectedDate?.dateOnly(),
      time: selectedTime?.timeSinceEpoch(),
    );

    if (authProvider.appUser?.authId == null || authProvider.appUser!.authId!.isEmpty) {
      showMessageDialog(
        context,
        "User is not authenticated",
        posButtonTitle: "OK",
        posButtonAction: () {},
      );
      return;
    }

    try {
      showMessageDialog(
        context,
        "Adding Task. Please wait...",
        posButtonTitle: "",
        posButtonAction: () {},
      );
      await tasksProvider.addTask(authProvider.appUser?.authId ?? "", task);
      showMessageDialog(
        context,
        "Task added successfully",
        posButtonTitle: "OK",
        posButtonAction: () {
          Navigator.pop(context);
        },
      );
    } catch (e) {
      print(e);
      showMessageDialog(
        context,
        e.toString(),
        posButtonTitle: "OK",
        posButtonAction: () {},
      );
    }
  }
}
