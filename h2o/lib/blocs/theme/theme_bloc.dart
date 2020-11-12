import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:h2o/themes/app_themes.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';

part 'theme_state.dart';

/// Bloc used to perform Theme change updates in the app
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(InitialThemeState(false,appThemeData[AppTheme.LightTheme]));

  ThemeState get initialState => InitialThemeState(false,appThemeData[AppTheme.LightTheme]);

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ThemeChanged) {
      bool switchVal = !event.switchVal;
      AppTheme appTheme = event.switchVal?AppTheme.LightTheme:AppTheme.DarkTheme;
      yield ThemeState(switchValue:switchVal, themeData: appThemeData[appTheme]);
    }
  }
}
