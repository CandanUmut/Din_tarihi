import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_prefs.dart';
import '../../providers/prefs_providers.dart';

final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) => LocaleNotifier(ref));

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._ref) : super(const Locale('en')) {
    _load();
    _listenToPrefs();
  }

  final Ref _ref;
  ProviderSubscription<AsyncValue<UserPrefs>>? _prefsSub;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('locale');
    if (code != null && code.isNotEmpty && code != state.languageCode) {
      state = Locale(code);
    }
  }

  void _listenToPrefs() {
    _prefsSub = _ref.listen<AsyncValue<UserPrefs>>(userPrefsProvider,
        (previous, next) {
      next.whenData((prefs) {
        if (prefs.lang.isNotEmpty && prefs.lang != state.languageCode) {
          state = Locale(prefs.lang);
          _persist(state);
        }
      });
    });
  }

  Future<void> setLocale(Locale locale) async {
    if (state.languageCode == locale.languageCode) {
      return;
    }
    state = locale;
    await _persist(locale);
    final prefsValue = _ref.read(userPrefsProvider);
    final notifier = _ref.read(userPrefsProvider.notifier);
    if (prefsValue.hasValue) {
      final current = prefsValue.value!;
      if (current.lang != locale.languageCode) {
        await notifier.update(current.copyWith(lang: locale.languageCode));
      }
    }
  }

  Future<void> _persist(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }

  @override
  void dispose() {
    _prefsSub?.close();
    super.dispose();
  }
}

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('themeMode');
    if (theme != null) {
      state = ThemeMode.values.firstWhere(
        (element) => element.name == theme,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.name);
  }
}
