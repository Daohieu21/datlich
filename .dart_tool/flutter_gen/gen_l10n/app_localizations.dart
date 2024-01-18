import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @login_with_social_networks.
  ///
  /// In en, this message translates to:
  /// **'Login with social networks'**
  String get login_with_social_networks;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password ?'**
  String get forgot_password;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get sign_up;

  /// No description provided for @create_your_account.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get create_your_account;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get log_out;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get setting;

  /// No description provided for @account_information.
  ///
  /// In en, this message translates to:
  /// **'Account information'**
  String get account_information;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @notice.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notice;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @change_name.
  ///
  /// In en, this message translates to:
  /// **'Change Name'**
  String get change_name;

  /// No description provided for @new_name.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get new_name;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @todo.
  ///
  /// In en, this message translates to:
  /// **'Todo'**
  String get todo;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start :'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End :'**
  String get end;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get current;

  /// No description provided for @newp.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newp;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm;

  /// No description provided for @do_you_want.
  ///
  /// In en, this message translates to:
  /// **'Do you want to change password ?'**
  String get do_you_want;

  /// No description provided for @new_confirm.
  ///
  /// In en, this message translates to:
  /// **'New password and confirm password do not match'**
  String get new_confirm;

  /// No description provided for @password_changed_success.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get password_changed_success;

  /// No description provided for @old_password_incorrect.
  ///
  /// In en, this message translates to:
  /// **'The old password is incorrect'**
  String get old_password_incorrect;

  /// No description provided for @please_login.
  ///
  /// In en, this message translates to:
  /// **'Please log in to change your password'**
  String get please_login;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Cannot be empty'**
  String get empty;

  /// No description provided for @password_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid format'**
  String get password_format;

  /// No description provided for @password_characters.
  ///
  /// In en, this message translates to:
  /// **'Password has at least 6 characters: 1 number, 1 uppercase letter, 1 special character'**
  String get password_characters;

  /// No description provided for @successfully_created.
  ///
  /// In en, this message translates to:
  /// **'Successfully created account'**
  String get successfully_created;

  /// No description provided for @please_enter.
  ///
  /// In en, this message translates to:
  /// **'Please enter search keywords'**
  String get please_enter;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter keywords ...'**
  String get enter;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this todo ?'**
  String get delete;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
