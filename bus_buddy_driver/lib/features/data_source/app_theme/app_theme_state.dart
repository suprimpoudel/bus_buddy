import 'package:equatable/equatable.dart';

abstract class AppThemeState extends Equatable {
  const AppThemeState();

  @override
  List<Object?> get props => [];
}

class ThemeDark extends AppThemeState {}

class ThemeLight extends AppThemeState {}
