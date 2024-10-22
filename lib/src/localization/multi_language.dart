// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:evochurch/src/blocs/index_bloc.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

final LanguageModel languageModel = LanguageModel();

class LanguageModel extends Model {
  static const Locale en = Locale('en');
  static const Locale hi = Locale('hi');
  static const Locale es = Locale('es');

  Locale _appLocale = const Locale.fromSubtags(languageCode: 'es');

  Locale get locale {
    // handleLocale();
    notifyListeners();
    return _appLocale;
  }

  List<Locale> get supportedLocales => [en, es];

  late Map<String, dynamic> _localizedString;

  /// Load JSON file form assets
  Future<bool> load() async {
    try {
      String jsonString = await rootBundle
          .loadString('assets/languages/${locale.languageCode}.json');
      _localizedString = jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Change localization
  Future<void> changeLanguage() async {
    if (_appLocale == en) {
      HiveUtils.set(HiveKeys.locale, 'en');
      _appLocale = en;
      await load();
    }  else {
      HiveUtils.set(HiveKeys.locale, 'es');
      _appLocale = es;
      await load();
    }
    notifyListeners();
    localizationBloc.add(const LocalizationEvent.changeLanguage());
  }

  String translate(String key) => _localizedString[key];

  String get lorem1 => languageModel.translate('lorem1');
  String get lorem2 => languageModel.translate('lorem2');
  String get lorem3 => languageModel.translate('lorem3');

  final _Evochurch evochurch = _Evochurch();
}

class MultiLanguage {
  final Locale locale;
  MultiLanguage({this.locale = const Locale.fromSubtags(languageCode: 'en')});

  static MultiLanguage? of(BuildContext context) {
    return Localizations.of<MultiLanguage>(context, MultiLanguage);
  }

  static const LocalizationsDelegate<MultiLanguage> delegate =
      _MultiLanguageDelegate();

  final supportedLocale = [
    const Locale('en'),
    const Locale('es')
  ];

  late Map<String, dynamic> _localizedString;

  Future<bool> load() async {
    try {
      String jsonString = await rootBundle
          .loadString('assets/language/${locale.languageCode}.json');
      _localizedString = jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  String translate(String key) {
    return _localizedString[key];
  }
}

class _MultiLanguageDelegate extends LocalizationsDelegate<MultiLanguage> {
  // This delegate instance will never change
  // It can provide a constant constructor.
  const _MultiLanguageDelegate();
  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'es'].contains(locale.languageCode);
  }

  /// read Json
  @override
  Future<MultiLanguage> load(Locale locale) async {
    // MultiLanguages class is where the JSON loading actually runs

    MultiLanguage localizations = MultiLanguage(locale: locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_MultiLanguageDelegate old) => true;
}

class _Evochurch {

  String get dashboard => languageModel.translate('dashboard');
  String get members => languageModel.translate('members');
  String get services => languageModel.translate('services');
  String get events => languageModel.translate('events');
  String get finances => languageModel.translate('finances');



  
}
