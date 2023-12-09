abstract class LoginEvent {}

class LoginEventTogglePassword extends LoginEvent {
  LoginEventTogglePassword();
}

class LoginEventSubmit extends LoginEvent {
  LoginEventSubmit();
}

class LoginEventLoading extends LoginEvent {
  final bool isLoading;
  LoginEventLoading({required this.isLoading});
}
