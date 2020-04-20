part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent extends Equatable {
  ThemeEvent([List props = const []]) : super(props);
}

class ThemeChanged extends ThemeEvent {
  final AppTheme theme;
  final bool switchVal;
  ThemeChanged({
    this.theme,
    @required this.switchVal,
  }) : super([theme]);
}