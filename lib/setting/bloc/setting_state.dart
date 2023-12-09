import 'package:f_quizz/models/user_model.dart';

abstract class SettingState {}

class SettingInitialState extends SettingState {}

class SettingLoadedState extends SettingState {
  final UserModel loggedInUser;

  SettingLoadedState(this.loggedInUser);
}