import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


const String LAGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String VIETNAM = 'vi';


// Future<Locale> setLocale(String languageCode) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setString(LAGUAGE_CODE, languageCode);
//   return _locale(languageCode);
// }
Future<Locale> setLocale(String languageCode) async {
  await saveLocale(Locale(languageCode, ''));
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(LAGUAGE_CODE) ?? VIETNAM;
  return _locale(languageCode);
}

Future<void> saveLocale(Locale locale) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(LAGUAGE_CODE, locale.languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case VIETNAM:
      return const Locale(VIETNAM, '');
    case ENGLISH:
      return const Locale(ENGLISH, '');
    default:
      return const Locale(VIETNAM, '');
  }
}

AppLocalizations translation(BuildContext context) {
  return AppLocalizations.of(context);
}