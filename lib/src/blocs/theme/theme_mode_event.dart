part of 'theme_mode_bloc.dart';

@Freezed(equal: false)
class ThemeModeEvent with _$ThemeModeEvent {
  const factory ThemeModeEvent.changeTheme(bool? themeMode) = _ChangeTheme;
}