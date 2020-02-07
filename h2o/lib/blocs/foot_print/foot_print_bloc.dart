import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'foot_print_event.dart';

part 'foot_print_state.dart';

class FootPrintBloc extends Bloc<FootPrintEvent, FootPrintState> {
  @override
  FootPrintState get initialState => InitialFootPrintState(0);

  @override
  Stream<FootPrintState> mapEventToState(FootPrintEvent event) async* {
    if(event is UpdateTotCons){
//      print("Received new tot: ${event.totConsumption}");

      yield UpdatePrint(event.totConsumption);
    }
  }
}
