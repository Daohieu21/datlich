abstract class SettingEvent {}

class LoadSettingEvent extends SettingEvent {}

class ChangeNameEvent extends SettingEvent {
  final String newName;

  ChangeNameEvent(this.newName);
}

class ChangeAvatarEvent extends SettingEvent {
  final String base64Image;

  ChangeAvatarEvent(this.base64Image);
}