import 'package:f_quizz/home_screen.dart';
import 'package:f_quizz/models/firebase_service.dart';
import 'package:f_quizz/models/language_constants.dart';
import 'package:f_quizz/resources/colors.dart';
import 'package:f_quizz/setting/page/setting.dart';
import 'package:f_quizz/todo/bloc/todo_bloc.dart';
import 'package:f_quizz/todo/page/todo_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);
  static const String routeName = "/bottom";

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;
  late FirebaseService firebaseService;
  final PageController controller = PageController();
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      controller.jumpToPage(index);
    });
  }

  DateTime? _currentBackPressTime;
  Future<bool> _onWillPop() async {
    if (_currentBackPressTime == null ||
        DateTime.now().difference(_currentBackPressTime!) >
            const Duration(seconds: 2)) {
      _currentBackPressTime = DateTime.now();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nhấn back lần nữa để thoát'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    // Lấy người dùng hiện tại từ Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    print('User: $user');
    firebaseService = FirebaseService(user?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView(
          controller: controller,
          physics:
              const NeverScrollableScrollPhysics(), // Ngăn vuốt sang trái và sang phải
          children: [
            BlocProvider(
              create: (context) => TodoBloc(firebaseService: firebaseService),
              child: const TodoPage(),
            ),
            HomeScreen(),
            const Setting(),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(top: 15, bottom: 0),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: AppColors.gray),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            iconSize: 24,
            selectedItemColor: AppColors.red,
            unselectedItemColor: AppColors.gray,
            onTap: _onTabTapped,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: const Icon(Icons.check_box),
                ),
                label: translation(context).todo,
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: const Icon(Icons.house),
                ),
                label: translation(context).home,
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: const Icon(Icons.settings),
                ),
                label: translation(context).setting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
