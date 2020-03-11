import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  @override
  ThemeState get initialState => InitialThemeState();

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    // TODO: Add your event logic
  }
}
