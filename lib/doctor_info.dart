import 'package:flutter/material.dart';

class DoctorsInfo extends StatefulWidget {
  const DoctorsInfo({super.key});

  @override
  State<DoctorsInfo> createState() => _DoctorsInfoState();
}

class _DoctorsInfoState extends State<DoctorsInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                height: 300,
                width: 200,
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F8FF),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.blue,
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Image.asset(
                              'assets/images/profile.png',
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                              ),
                            ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            height: 45,
                            width: 45,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF2F8FF),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Dr Abcd",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          const Text(
                            "Sugoii",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8,),
                          Row(
                            children: const [
                              Icon(
                                Icons.star,
                                color:  Colors.amber,
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "4.8",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                ),
                            ],
                          ),
                        ]),
                      ),
                ]),
              ),
            ],
          );
        }),
    );
  }
}