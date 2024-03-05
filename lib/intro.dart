import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:f_quizz/login/page/login.dart';
import 'package:f_quizz/ui_components/btn/button.dart';
import 'package:f_quizz/gen/assets.gen.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  static String routeName = "/Intro";

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  int _currentIndex = 0;
  final PageController _controller = PageController(initialPage: 0);

  List<IntroContent> contents = [
    IntroContent(
      image: Assets.images.intro1.path,
      title: 'Learn About Your Doctors',
      description: 'Discover your doctors: qualifications, expertise, and patient reviews, empowering you to make informed decisions about your healthcare journey.',
    ),
    IntroContent(
      image: Assets.images.intro2.path,
      title: 'Effortless Appointment Booking',
      description: 'Revolutionize Your Medical Visits: Explore the Convenience of Booking Appointments Anytime, Anywhere',
    ),
    IntroContent(
      image: Assets.images.intro3.path,
      title: 'Friendly interface',
      description: 'Experience a user-friendly interface that simplifies the process of booking appointments, ensuring a seamless and enjoyable healthcare management journey.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    checkIntroStatus();
  }

  Future<void> checkIntroStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasShownIntro = prefs.getBool('hasShownIntro') ?? false;
    if (hasShownIntro) {
      // Trang intro đã được hiển thị trước đó, chuyển đến màn hình đăng nhập
      navigateToLogin();
    }
  }

  Future<void> saveIntroStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasShownIntro', true);
  }

  void navigateToLogin() {
    Navigator.pushNamedAndRemoveUntil(context, Login.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, right: 16),
            child: GestureDetector(
              onTap: () {
                _controller.jumpToPage(_currentIndex = contents.length - 1);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    'Bỏ qua',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF3C3A36),
                      fontFamily: 'Rubik',
                      fontSize: 12,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      //ảnh
                      Image.asset(
                        contents[index].image,
                        height: 264,
                      ),
                      const SizedBox(height: 16),

                      //Text
                      Column(
                        children: [
                          Container(
                            height: 72,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  contents[index].title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF3C3A36),
                                    fontFamily: 'Rubik',
                                    fontSize: 24,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            contents[index].description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF78746D),
                              fontFamily: 'Rubik',
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 50,
            ),
            child: Button(
              textButton: _currentIndex == contents.length - 1 ? "Bắt đầu" : "Tiếp",
              onTap: () {
                if (_currentIndex == contents.length - 1) {
                  saveIntroStatus(); // Lưu trạng thái đã hiển thị trang intro
                  navigateToLogin();
                }
                _controller.nextPage(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.bounceIn,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int i, BuildContext context) {
    return Container(
      height: 6,
      width: _currentIndex == i ? 18 : 6,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _currentIndex == i ? const Color(0xFF65AAEA) : const Color(0xFFBEBAB3),
      ),
    );
  }
}

class IntroContent {
  String image;
  String title;
  String description;

  IntroContent({
    required this.image,
    required this.title,
    required this.description,
  });
}