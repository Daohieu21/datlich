import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:f_quizz/resources/colors.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  List catNames = [
    "Dental",
    "Heart",
    "Eye",
    "Brain",
    "Ear"
  ];

  List<Icon> catIcons = [
    Icon(MdiIcons.toothOutline, color: Colors.blue, size: 30),
    Icon(MdiIcons.heartPlus, color: Colors.blue, size: 30),
    Icon(MdiIcons.eye, color: Colors.blue, size: 30),
    Icon(MdiIcons.brain, color: Colors.blue, size: 30),
    Icon(MdiIcons.earHearing, color: Colors.blue, size: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFD9E4EE),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.blu1.withOpacity(0.8),
                    AppColors.blu1,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('assets/images/profile.png'),
                            ),
                            Icon(
                              Icons.notifications_outlined,
                                color: Colors.white,
                                size: 30,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15,),
                        const Text(
                          "hi",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            ),
                        ),
                        const SizedBox(height: 10,),
                        const Text(
                          "You Health is Our\nFirst Priority",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15, bottom: 20),
                          width: MediaQuery.of(context).size.width,
                          height: 55,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 6,
                                spreadRadius: 3,
                              )
                            ]
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search here ...",
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 25,
                              )
                            ),
                          ),
                        ),
                      ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.withOpacity(0.7),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    height: 100,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: catNames.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                              height: 60,
                              width: 60,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF2F8FF),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              child: Center(
                                child: catIcons[index],
                                ),
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              catNames[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue.withOpacity(0.7),
                              ),
                            ),
                          ],
                        );
                      }
                    )
                  ),
                  const SizedBox(height: 30,), 
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Recommended Doctors",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}