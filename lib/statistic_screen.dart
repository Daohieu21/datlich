import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_quizz/models/appoint_model.dart';
import 'package:f_quizz/models/firebase_service.dart';
import 'package:f_quizz/models/language_constants.dart';
import 'package:f_quizz/models/user_model.dart';
import 'package:f_quizz/resources/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'models/todo_model.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  late FirebaseService firebaseService;
  List<TodoModel> todoList = [];
  List<AppointModel> appointList = [];
  List<AppointModel> busyDoctors = [];
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel(
    uid: '',
    email: '',
    fullName: '',
    createAt: DateTime.now(),
    modifiedAt: DateTime.now(),
    avatarBase64: '', 
    role: '',
  );

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    firebaseService = FirebaseService(user?.uid ?? '');
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data() ?? {});
      setState(() {});
    });
    getAppoint();
  }

  Future<void> getTodos() async {
    try {
      List<TodoModel> fetchedTodo = await firebaseService.getTodos();
      setState(() {
        todoList = fetchedTodo;
      });
    } catch (error) {
      print('Error loading todos: $error');
    }
  }

  Future<void> getAppoint() async {
    try {
      List<AppointModel> fetchedAppoint = await firebaseService.getAppointAdmin();
      setState(() {
        appointList = fetchedAppoint;
      });
      // Sau khi dữ liệu được tải, gọi loadBusyDoctorsForCurrentDateTime
      loadBusyDoctorsForCurrentDateTime();
    } catch (error) {
      print('Error loading todos: $error');
    }
  }
  
  Future<List<AppointModel>> getAppointForDay(DateTime selectedDay) async {
    List<AppointModel> appointsForDay = appointList
        .where((appoint) =>
            DateTime(appoint.time.year, appoint.time.month, appoint.time.day)
                .isAtSameMomentAs(
                    DateTime(selectedDay.year, selectedDay.month, selectedDay.day)))
        .toList();

    return appointsForDay;
  }

  Future<void> loadBusyDoctorsForCurrentDateTime() async {
    DateTime currentDateTime = DateTime.now();
    _selectedDay = currentDateTime;
    _focusedDay = currentDateTime;
    busyDoctors = await getAppointForDay(currentDateTime);
    print('Busy Doctors: $busyDoctors');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            translation(context).statistic,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Rubik',
              fontSize: 24,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white, // Màu nền của toàn bộ trang
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) async {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              busyDoctors = await getAppointForDay(selectedDay);
              print('Busy Doctors: $busyDoctors');
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, date, events) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.blue, // Màu sắc khi ngày được chọn
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    date.day.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
              todayBuilder: (context, date, events) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.red, // Màu sắc cho ngày hiện tại
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    date.day.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 0,top: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: busyDoctors.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10), // Khoảng cách giữa các phần tử
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2, color: AppColors.gray),
                        ),
                      ),
                      child: Row(
                        children: [
                          //const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: translation(context).title,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ':',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        const WidgetSpan(child: SizedBox(width: 5),),
                                        TextSpan(
                                          text: busyDoctors[index].title,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: translation(context).content,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ':',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        const WidgetSpan(child: SizedBox(width: 5),),
                                        TextSpan(
                                          text: busyDoctors[index].content,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: translation(context).patients,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ':',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        const WidgetSpan(child: SizedBox(width: 5),),
                                        TextSpan(
                                          text: busyDoctors[index].email,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: translation(context).schedule,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ':',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        const WidgetSpan(child: SizedBox(width: 5),),
                                        TextSpan(
                                          text: DateFormat.Hm().format(busyDoctors[index].time),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: translation(context).status,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ':',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        const WidgetSpan(child: SizedBox(width: 5),),
                                        TextSpan(
                                          text: busyDoctors[index].isCompleted ? translation(context).success : translation(context).porocessing,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
