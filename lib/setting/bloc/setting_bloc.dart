// import 'package:f_quizz/models/user_model.dart';
// import 'package:f_quizz/setting/bloc/setting_event.dart';
// import 'package:f_quizz/setting/bloc/setting_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class SettingBloc extends Bloc<SettingEvent, SettingState> {
//   SettingBloc() : super(SettingInitialState()) {
//     on<ChangeNameEvent>(_handleChangeNameEvent);
//     on<ChangeAvatarEvent>(_handleChangeAvatarEvent);
//   }

//   void _handleChangeNameEvent(ChangeNameEvent event, Emitter<SettingState> emit) {
//     emit(SettingLoadedState(updateName(event.newName)));
//   }

//   void _handleChangeAvatarEvent(ChangeAvatarEvent event, Emitter<SettingState> emit) {
//     emit(SettingLoadedState(updateAvatar(event.base64Image)));
//   }

//   UserModel updateName(String newName) {
//     return state.loggedInUser.copyWith(fullName: newName);
//   }

//   UserModel updateAvatar(String base64Image) {
//     return state.loggedInUser.copyWith(avatarBase64: base64Image);
//   }
// }
