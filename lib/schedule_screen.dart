import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_quizz/models/appoint_model.dart';
import 'package:f_quizz/models/firebase_service.dart';
import 'package:f_quizz/models/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/user_model.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late FirebaseService firebaseService; // Khai báo FirebaseService
  List<AppointModel> appoint = []; // Danh sách AppointModel
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


  @override
  void initState() {
    super.initState();
    firebaseService = FirebaseService(user?.uid ?? '');
    // Lấy thông tin người dùng
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    // Gọi hàm getTodos để lấy danh sách TodoModel
    loadAppoint();
  }

  Future<void> loadAppoint() async {
    try {
      // Gọi phương thức getTodos từ FirebaseService
      List<AppointModel> fetchedAppoint = await firebaseService.getAppoint();
      // Cập nhật trạng thái với dữ liệu mới
      setState(() {
        appoint = fetchedAppoint;
      });
    } catch (error) {
      // Xử lý lỗi nếu có
      print('Error loading todos: $error');
    }
  }

  //   @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            translation(context).schedule,
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
      body: Container(
        margin: const EdgeInsets.only(bottom: 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: appoint.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 15), // Khoảng cách giữa các phần tử
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                appoint[index].title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    appoint[index].content,
                                    style: const TextStyle(
                                      fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Divider(
                                color: Colors.black,
                                thickness: 1,
                                height: 20,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      color: Colors.black54,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(appoint[index].time),
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_filled,
                                      color: Colors.black54,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      DateFormat('hh:mm a').format(appoint[index].time),
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      appoint[index].isCompleted ? translation(context).success : translation(context).porocessing,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Hiển thị hộp thoại xác nhận
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(translation(context).notice),
                                          content: Text(translation(context).delete),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                // Đóng hộp thoại
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(translation(context).cancel),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                // Đóng hộp thoại trước khi thực hiện hủy
                                                Navigator.of(context).pop();
                                                try {
                                                  // Gọi hàm để xóa lịch hẹn khi nhấn cancel
                                                  await firebaseService.deleteAppoint(appoint[index].aid!);
                                                  // Sau khi xóa thành công, cập nhật danh sách lịch hẹn
                                                  loadAppoint();
                                                } catch (error) {
                                                  // Xử lý lỗi nếu có
                                                  print('Error deleting appoint: $error');
                                                }
                                              },
                                              child: Text(translation(context).ok),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 150,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF4F6FA),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        translation(context).cancel,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
