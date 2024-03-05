import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_quizz/models/appoint_model.dart';
import 'package:f_quizz/models/firebase_service.dart';
import 'package:f_quizz/models/language_constants.dart';
import 'package:f_quizz/models/user_model.dart';
import 'package:f_quizz/resources/colors.dart';
import 'package:f_quizz/ui_components/btn/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/todo_model.dart';
import 'package:intl/intl.dart';

class AppointScreen extends StatefulWidget {
  final TodoModel doctorInfo;
  const AppointScreen({super.key, required this.doctorInfo});

  @override
  State<AppointScreen> createState() => _AppointScreenState();
}

class _AppointScreenState extends State<AppointScreen> {

  late FirebaseService firebaseService; // Khai báo FirebaseService
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
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 7, minute: 0);
  List<TimeOfDay> availableTimes = [
    const TimeOfDay(hour: 7, minute: 0),
    const TimeOfDay(hour: 8, minute: 0),
    const TimeOfDay(hour: 9, minute: 0),
    const TimeOfDay(hour: 10, minute: 0),
    const TimeOfDay(hour: 11, minute: 0),
    const TimeOfDay(hour: 14, minute: 0),
    const TimeOfDay(hour: 15, minute: 0),
    const TimeOfDay(hour: 16, minute: 0),
  ];
  
  void resetAvailableTimes() {
    setState(() {
      availableTimes = [
    const TimeOfDay(hour: 7, minute: 0),
    const TimeOfDay(hour: 8, minute: 0),
    const TimeOfDay(hour: 9, minute: 0),
    const TimeOfDay(hour: 10, minute: 0),
    const TimeOfDay(hour: 11, minute: 0),
    const TimeOfDay(hour: 14, minute: 0),
    const TimeOfDay(hour: 15, minute: 0),
    const TimeOfDay(hour: 16, minute: 0),
  ];
    });
  }

  ImageProvider<Object>? base64ToImage(String base64String) {
    try {
      Uint8List bytes = const Base64Decoder().convert(base64String);
      return MemoryImage(bytes);
    } catch (e) {
      print("Error decoding base64: $e");
      return null;
    }
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = DateTime(
          picked.year, 
          picked.month, 
          picked.day, 
          selectedTime.hour, 
          selectedTime.minute);
      });
      print('Selected Date: $selectedDate');
      resetAvailableTimes();
      // Gọi loadAvailableTimes ngay sau khi thiết lập selectedDate
      loadAvailableTimes();
    }
  }

Future<void> loadAvailableTimes() async {
  try {
    List<AppointModel> adminAppoints = await firebaseService.getAppointAdmin();
    print('Admin Appoints: $adminAppoints');

    // Tạo danh sách chứa thời gian đã bận
    List<TimeOfDay> busyTimes = [];

    // Chuyển đổi selectedDate thành DateTime để so sánh với adminAppointDateTime
      // DateTime selectedDateTime = DateTime(
      //   selectedDate.year,
      //   selectedDate.month,
      //   selectedDate.day,
      // );

    // Lặp qua lịch làm việc của bác sĩ để thu thập các thời gian đã bận
    for (var adminAppoint in adminAppoints) {
      DateTime adminAppointDateTime = adminAppoint.time;
      TimeOfDay adminAppointTimeOfDay =
          TimeOfDay.fromDateTime(adminAppointDateTime);

    // Kiểm tra cả ngày và bác sĩ có phải là người được chọn hay không
    bool isSameDay = selectedDate.year == adminAppointDateTime.year &&
        selectedDate.month == adminAppointDateTime.month &&
        selectedDate.day == adminAppointDateTime.day;

      bool isSameDoctor = widget.doctorInfo.todoid == adminAppoint.todoid;

      print('Selected Date: $selectedDate');
      print('Admin Appoint Date: $adminAppointDateTime');
      print('Is Same Day: $isSameDay');

      if (isSameDay && isSameDoctor) {
        busyTimes.add(adminAppointTimeOfDay);
      }
      print('Busy Times: $busyTimes');
    }

    // Lọc danh sách thời gian rảnh để chỉ giữ lại những thời gian không trùng với thời gian đã bận
    List<TimeOfDay> filteredTimes = availableTimes
        .where((time) =>
            !busyTimes.any((busyTime) =>
                time.hour == busyTime.hour && time.minute == busyTime.minute))
        .toList();

        // thieu check Ngay vs nam nen no v
    setState(() {
      availableTimes = filteredTimes;
    });
    print('Filtered Times: $filteredTimes');
  } catch (error) {
    print('Error loading available times: $error');
  }
}

  Future<void> loadUserDetails() async {
      try {
        final value = await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .get();
        loggedInUser = UserModel.fromMap(value.data());
        setState(() {});
      } catch (error) {
        print('Error loading user details: $error');
      }
  }

  @override
  void initState() {
    super.initState();
    // Lấy người dùng hiện tại từ Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    print('User: $user');
    firebaseService = FirebaseService(user?.uid ?? '');
    loadAvailableTimes();
    loadUserDetails();
  }
  
  @override
  Widget build(BuildContext context) {
    TodoModel doctorInfo = widget.doctorInfo;
    double buttonWidth = (MediaQuery.of(context).size.width - 40) / 4;
    print("Doctor Info: $doctorInfo");
    return Scaffold(
      body: Material(
        color: const Color(0xFFD9E4EE),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.1,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: base64ToImage(widget.doctorInfo.imageBase64) ?? const AssetImage("assets/images/profile.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blu1.withOpacity(0.6),
                        AppColors.blu1.withOpacity(0),
                        AppColors.blu1.withOpacity(0),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Nút Back
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                    )
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.blue,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                            // Nút Favorite
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.favorite_outline,
                                  color: Colors.blue,
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Column(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text(
                            //       translation(context).patients,
                            //       style: const TextStyle(
                            //         fontSize: 20,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //     const SizedBox(height: 8,),
                            //     const Text(
                            //       "1.8k",
                            //       style: TextStyle(
                            //         fontSize: 18,
                            //         fontWeight: FontWeight.w500,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  translation(context).experience,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8,),
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: widget.doctorInfo.experience,
                                      ),
                                      const WidgetSpan(child: SizedBox(width: 5),),
                                      TextSpan(
                                        text: translation(context).year,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Column(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text(
                            //       translation(context).rating,
                            //       style: const TextStyle(
                            //         fontSize: 20,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //     const SizedBox(height: 8,),
                            //     const Text(
                            //       "4.9",
                            //       style: TextStyle(
                            //         fontSize: 18,
                            //         fontWeight: FontWeight.w500,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctorInfo.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Text(
                      widget.doctorInfo.content,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 15,),
                    Text(
                      translation(context).hours,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    Wrap(
                      children: availableTimes.map((TimeOfDay value) {
                        print('Displaying time: $value');
                        return SizedBox(
                          width: buttonWidth,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTime = value;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: selectedTime == value ? Colors.blue : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  value.format(context),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 15,),
                    Text(
                      translation(context).date,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('dd-MM-yyyy').format(selectedDate),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Container(
                      margin: const EdgeInsets.only(bottom: 100),
                      child: Button(
                        textButton: translation(context).appoint,
                        onTap: () async {
                          try {
                            // Lấy thông tin từ doctorInfo
                            String title = widget.doctorInfo.title;
                            String content = widget.doctorInfo.content;
                            String email = loggedInUser.email;
                            // Sử dụng đối tượng DateTime để giữ cả ngày và thời gian
                            DateTime selectedDateTime = DateTime(
                              selectedDate.year, 
                              selectedDate.month, 
                              selectedDate.day,
                              selectedTime.hour, 
                              selectedTime.minute);
                            // Gọi đến addAppoint để thêm dữ liệu lên Firebase
                            await firebaseService.addAppoint(
                              todoid: widget.doctorInfo.todoid ?? '',
                              title: title,
                              content: content,
                              email: email,
                              time: selectedDateTime.toIso8601String(),
                            );
                            // Thông báo thành công hoặc thực hiện các hành động khác sau khi thêm thành công
                            // Hiển thị Snackbar khi đặt lịch thành công
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(translation(context).scheduledsuccess),
                                duration: const Duration(seconds: 3), // Thời gian hiển thị Snackbar
                              ),
                            );
                            print('Appointment added successfully!');
                            loadAvailableTimes();
                          } catch (error) {
                            // Xử lý lỗi nếu có
                            print('Error adding appointment: $error');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}