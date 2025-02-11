import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

const String LAGUAGE_CODE = 'languageCode';

// Global Language Variable
String? languageFlag;

//languages code
const String ENGLISH = 'en';
const String RUSSIAN = 'ru';

Locale? loc;
int lang = 0;
Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(LAGUAGE_CODE) ?? defaultLanguage;
;
  languageFlag = languageCode;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, 'US');
    case RUSSIAN:
      return const Locale(RUSSIAN, "RU");
    default:
      return const Locale(RUSSIAN, 'RU');
  }
}

void changeLanguage(BuildContext context, String language) async {
  languageFlag = language;
  Locale loc = await setLocale(language);
  MyApp.setLocale(context, loc);
}
