import 'package:bus_buddy_driver/features/data_source/app_theme/app_theme_state.dart';
import 'package:bus_buddy_driver/utils/constants/preference_constants.dart';
import 'package:bus_buddy_driver/utils/enum/app_theme_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeCubit extends Cubit<AppThemeState> {
  final SharedPreferences _sharedPreferences;
  AppThemeCubit(AppThemeState appThemeState, this._sharedPreferences)
      : super(appThemeState);

  void changeAppTheme(AppThemeEnum appThemeEnum) async {
    var appThemeState = _getAppThemeStateFromEnum(appThemeEnum);
    await _sharedPreferences
        .setString(appTheme, appThemeEnum.name)
        .then((value) {
      emit(appThemeState);
    }).catchError((onError) {
      emit(appThemeState);
    });
  }
}

AppThemeState getAppThemeStateFromValue(String appTheme) {
  if (appTheme == AppThemeEnum.themeDark.name) {
    return ThemeDark();
  } else {
    return ThemeLight();
  }
}

AppThemeState _getAppThemeStateFromEnum(AppThemeEnum appThemeEnum) {
  if (appThemeEnum == AppThemeEnum.themeDark) {
    return ThemeDark();
  } else {
    return ThemeLight();
  }
}
