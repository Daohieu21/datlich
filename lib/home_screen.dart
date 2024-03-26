import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'appoint_screen.dart';
import 'models/firebase_service.dart';
import 'models/language_constants.dart';
import 'models/todo_model.dart';
import 'models/user_model.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseService firebaseService;
  List<TodoModel> todos = [];
  String searchQuery = '';
  bool isSearching = false;
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

  List<String> catNames = [];

  List<Icon> catIcons = [
    Icon(MdiIcons.toothOutline, color: Colors.blue, size: 30),
    Icon(MdiIcons.heartPlus, color: Colors.blue, size: 30),
    Icon(MdiIcons.eye, color: Colors.blue, size: 30),
    Icon(MdiIcons.brain, color: Colors.blue, size: 30),
    Icon(MdiIcons.earHearing, color: Colors.blue, size: 30),
  ];

  @override
  void initState() {
    super.initState();
    firebaseService = FirebaseService(user?.uid ?? '');
    loadUserDetails();
    loadTodos();
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

  Future<void> loadTodos() async {
    try {
      List<TodoModel> fetchedTodos = await firebaseService.getTodos();
      setState(() {
        todos = fetchedTodos;
      });
      print('todos: $fetchedTodos');
    } catch (error) {
      print('Error loading todos: $error');
    }
  }
  
  Future<void> updateSearchResults() async {
    print('Start updateSearchResults');
    // setState(() {
    //   isSearching = true;
    // });

    // Nếu thông tin tìm kiếm rỗng, hiển thị toàn bộ danh sách
    if (searchQuery.isEmpty) {
      print('Search query is empty. Loading all todos.');
      await loadTodos();
    } else {
      // Nếu có thông tin tìm kiếm, lọc danh sách theo thông tin này
      List<TodoModel> filteredTodos = todos.where((todo) {
        // In giá trị của các biến để kiểm tra
        print('Todo title: ${todo.title}');
        print('Search query: $searchQuery');
        print('Text without diacritics: ${removeDiacritics(todo.title)}');
        print('Search query without diacritics: ${removeDiacritics(searchQuery)}');
        return containsSearchQuery(
          removeDiacritics(todo.title),
          removeDiacritics(searchQuery),
        ) ||
            containsSearchQuery(
              removeDiacritics(todo.content),
              removeDiacritics(searchQuery),
            );
      }).toList();

      setState(() {
        todos = filteredTodos;
        //isSearching = false;
      });
      print('Search results: $filteredTodos');
      print('Updated todos: $todos');
      print('todos: $todos');
    }
    print('End updateSearchResults');
  }

  bool containsSearchQuery(String text, String searchQuery) {
    // Loại bỏ dấu ở cả text và searchQuery
    String textWithoutDiacritics = removeDiacritics(text.toLowerCase());
    String searchQueryWithoutDiacritics = removeDiacritics(searchQuery.toLowerCase());

    // Kiểm tra xem textWithoutDiacritics có chứa searchQueryWithoutDiacritics hay không
    return textWithoutDiacritics.contains(searchQueryWithoutDiacritics);
  }

  String removeDiacritics(String text) {
    // Bảng ánh xạ dấu tiếng Việt
    final Map<String, String> diacriticMap = {
      'à': 'a', 'á': 'a', 'ả': 'a', 'ã': 'a', 'ạ': 'a',
      'ă': 'a', 'ằ': 'a', 'ắ': 'a', 'ẳ': 'a', 'ẵ': 'a', 'ặ': 'a',
      'â': 'a', 'ầ': 'a', 'ấ': 'a', 'ẩ': 'a', 'ẫ': 'a', 'ậ': 'a',
      'è': 'e', 'é': 'e', 'ẻ': 'e', 'ẽ': 'e', 'ẹ': 'e',
      'ê': 'e', 'ề': 'e', 'ế': 'e', 'ể': 'e', 'ễ': 'e', 'ệ': 'e',
      'ì': 'i', 'í': 'i', 'ỉ': 'i', 'ĩ': 'i', 'ị': 'i',
      'ò': 'o', 'ó': 'o', 'ỏ': 'o', 'õ': 'o', 'ọ': 'o',
      'ô': 'o', 'ồ': 'o', 'ố': 'o', 'ổ': 'o', 'ỗ': 'o', 'ộ': 'o',
      'ơ': 'o', 'ờ': 'o', 'ớ': 'o', 'ở': 'o', 'ỡ': 'o', 'ợ': 'o',
      'ù': 'u', 'ú': 'u', 'ủ': 'u', 'ũ': 'u', 'ụ': 'u',
      'ư': 'u', 'ừ': 'u', 'ứ': 'u', 'ử': 'u', 'ữ': 'u', 'ự': 'u',
      'ỳ': 'y', 'ý': 'y', 'ỷ': 'y', 'ỹ': 'y', 'ỵ': 'y',
      'đ': 'd',
    };

    // Áp dụng ánh xạ để loại bỏ dấu
    String normalizedText = '';
    for (var char in text.split('')) {
      normalizedText += diacriticMap[char] ?? char;
    }

    return normalizedText;
  }



  Future<void> searchByCategory(String category) async {
    setState(() {
      //isSearching = true;
      // Thiết lập giá trị tìm kiếm bằng danh mục được chọn
      searchQuery = category;
    });
    // Load danh sách todos từ Firebase mỗi khi chọn danh mục mới
    await loadTodos();
    // Gọi hàm cập nhật danh sách dựa trên thông tin tìm kiếm
    updateSearchResults();
  }


  @override
  Widget build(BuildContext context) {
    catNames = [
      translation(context).dental,
      translation(context).heart,
      translation(context).eye,
      translation(context).brain,
      translation(context).ear
    ];
    return Scaffold(
      body: Material(
        //color: const Color(0xFFD9E4EE),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.8),
                      Colors.blue,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (loggedInUser.avatarBase64 != null &&
                                  loggedInUser.avatarBase64!.isNotEmpty)
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      MemoryImage(base64Decode(loggedInUser.avatarBase64!)),
                                )
                              else
                                const CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage('assets/images/profile.png'),
                                ),
                              const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15,),
                          Text(
                            "${translation(context).hello}, ${loggedInUser.fullName}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text(
                            translation(context).health,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15, bottom: 20),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 6,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                                print('Search Query: $searchQuery');
                                // Gọi hàm cập nhật danh sách dựa trên thông tin tìm kiếm
                                updateSearchResults();
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: translation(context).enter,
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        translation(context).category,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.7),
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
                          return InkWell(
                            onTap: () {
                              // Bấm vào danh mục, gọi hàm tìm kiếm dựa trên danh mục này
                              searchByCategory(catNames[index]);
                            },
                            child: Column(
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
                                        color: Colors.grey,
                                        blurRadius: 4,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: catIcons[index],
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Container(
                                  width: 110,
                                  child: Text(
                                    catNames[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30,), 
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        translation(context).recommended,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Container(
                      height: 360,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          //print('Building item $index');
                          TodoModel todo = todos[index];
                          return Column(
                            children: [
                              Container(
                                height: 320,
                                width: 200,
                                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F8FF),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
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
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AppointScreen(doctorInfo: todo),
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                            ),
                                            child: Image.memory(
                                              base64Decode(todo.imageBase64),
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
                                                  color: Colors.grey,
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
                                          Text(
                                            todo.title,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          Text(
                                            todo.content,
                                            style: const TextStyle(
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
                                                color: Colors.amber,
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
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
