part of 'theme_bloc.dart';

@immutable
class ThemeState extends Equatable {
  final ThemeData themeData;
  final bool switchValue;

  ThemeState({
    @required this.themeData,
    @required this.switchValue,
  }) : super([themeData]);
}

class InitialThemeState extends ThemeState {
  InitialThemeState(bool switchValue,ThemeData themeData) : super(switchValue:switchValue,themeData:themeData);

  @override
  bool get switchValue => super.switchValue;
}