import 'dart:convert';
import 'dart:io';

import 'package:f_quizz/models/language_constants.dart';
import 'package:f_quizz/models/todo_model.dart';
import 'package:f_quizz/resources/colors.dart';
import 'package:f_quizz/resources/validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../ui_components/btn/button.dart';

class TodoBottomSheet extends StatefulWidget {
  const TodoBottomSheet({
    Key? key,
    this.currentTodo,
    required this.onAdd,
    required this.onEdit,
    this.index,
  }) : super(key: key);
  final void Function(int index, TodoModel todo) onEdit;
  final void Function(TodoModel todo) onAdd;
  final TodoModel? currentTodo;
  final int? index;

  @override
  State<TodoBottomSheet> createState() => _TodoBottomSheetState();
}

class _TodoBottomSheetState extends State<TodoBottomSheet> {
  // Thêm biến cho lưu trữ dữ liệu ảnh
  XFile? pickedImage;
  // Thêm biến để lưu trữ thông tin Todo mới hoặc chỉnh sửa
  TodoModel? newTodo;

  @override
  void initState() {
    super.initState();
    if (widget.currentTodo != null) {
      titleController.text = widget.currentTodo?.title ?? '';
      contentController.text = widget.currentTodo?.content ?? '';
      selectTime =
          TimeOfDay.fromDateTime(widget.currentTodo?.startTime ?? DateTime.now());
      selectTimeEnd =
          TimeOfDay.fromDateTime(widget.currentTodo?.endTime ?? DateTime.now());
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var bytes = await image.readAsBytes();
        String base64Image = base64Encode(bytes);
        setState(() {
          pickedImage = image;
          // Cập nhật trường ảnh cho newTodo
          newTodo?.imageBase64 = base64Image;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  //biến cục bộ
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  DateTime dateTime = DateTime.now();
  TimeOfDay selectTimeEnd = TimeOfDay.now();
  TimeOfDay selectTime = TimeOfDay.now();

  ///biến show icon delete
  int choose = -1;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(16),
      height: size.height * .80,
      child: StatefulBuilder(
        builder: ((context, setState) {
          return ListView(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        pickImage();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          //color: AppColors.gray,
                        ),
                        child: pickedImage != null
                            ? Image.file(
                                File(pickedImage!.path),
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ) 
                        : widget.currentTodo?.imageBase64 != null
                            ? Image.memory(
                                base64Decode(widget.currentTodo!.imageBase64!),
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/profile.png',
                                width: 150,
                                height: 150,
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: translation(context).title,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.0),
                          ),
                        ),
                      ),
                      validator: (value) => ValidatorUtils.todoValidate(context, value),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: contentController,
                      decoration: InputDecoration(
                        labelText: translation(context).content,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.0),
                          ),
                        ),
                      ),
                      validator: (value) => ValidatorUtils.todoValidate(context, value),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, bottom: 16),
                          width: 90,
                          child: Text(translation(context).start),
                        ),
                        InkWell(
                          onTap: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                selectTime = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.gray,
                            ),
                            child: Text(
                              textAlign: TextAlign.center,
                              "${selectTime.hour}:${selectTime.minute}",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, bottom: 16),
                          width: 90,
                          child: Text(translation(context).end),
                        ),
                        InkWell(
                          onTap: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                selectTimeEnd = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.gray,
                            ),
                            child: Text(
                              textAlign: TextAlign.center,
                              "${selectTimeEnd.hour}:${selectTimeEnd.minute}",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Button(
                      textButton: translation(context).save,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          if (widget.currentTodo != null) {
                            final TodoModel editedTodo = TodoModel(
                              todoid: widget.currentTodo?.todoid ?? '',
                              title: titleController.text,
                              content: contentController.text,
                              startTime: DateTime(
                                  dateTime.year,
                                  dateTime.month,
                                  dateTime.day,
                                  selectTime.hour,
                                  selectTime.minute),
                              endTime: DateTime(
                                  dateTime.year,
                                  dateTime.month,
                                  dateTime.day,
                                  selectTimeEnd.hour,
                                  selectTimeEnd.minute),
                              // Thêm logic cập nhật ảnh khi pickedImage không null
                              imageBase64: pickedImage != null
                                  ? base64Encode(File(pickedImage!.path).readAsBytesSync())
                                  : widget.currentTodo?.imageBase64 ?? '',
                            );
                            widget.onEdit.call(widget.index!, editedTodo);
                          } else {
                            final TodoModel newTodo = TodoModel(
                              title: titleController.text,
                              content: contentController.text,
                              startTime: DateTime(
                                  dateTime.year,
                                  dateTime.month,
                                  dateTime.day,
                                  selectTime.hour,
                                  selectTime.minute),
                              endTime: DateTime(
                                  dateTime.year,
                                  dateTime.month,
                                  dateTime.day,
                                  selectTimeEnd.hour,
                                  selectTimeEnd.minute),
                              // Thêm logic cập nhật ảnh khi pickedImage không null
                              imageBase64: pickedImage != null
                                  ? base64Encode(File(pickedImage!.path).readAsBytesSync())
                                  : '',
                            );
                            widget.onAdd.call(newTodo);
                          }
                          Navigator.pop(context);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Button(
                      textButton: translation(context).cancel,
                      onTap: onTapCancel,
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
  void onTapCancel() {
    Navigator.pop(context);
  }
}
