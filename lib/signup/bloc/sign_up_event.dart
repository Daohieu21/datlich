abstract class SignUpEvent {}

class SignUpEventTogglePassword extends SignUpEvent {
  SignUpEventTogglePassword();
}

class SignUpEventSubmit extends SignUpEvent {
  SignUpEventSubmit();
}

class SignUpEventLoading extends SignUpEvent {
  final bool isLoading;
  SignUpEventLoading({required this.isLoading});
}