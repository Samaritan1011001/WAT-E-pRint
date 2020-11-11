import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'foot_print_event.dart';

part 'foot_print_state.dart';

class FootPrintBloc extends Bloc<FootPrintEvent, FootPrintState> {
  @override
  FootPrintState get initialState => InitialFootPrintState(0);

  @override
  Stream<FootPrintState> mapEventToState(FootPrintEvent event) async* {
    if (event is UpdateFootPrint){
//      yield NewItem();
      yield* _mapItemAddedToState(event);
    }
  }
  Stream<UpdatedFootPrint> _mapItemAddedToState(UpdateFootPrint event) async*{
    Map questionAnswers = event.questionAnswers;
    List values = questionAnswers.values.toList();
    double result=0.0;
    values.forEach((value){
      result+=double.parse(value);
    });

    print("result : ${result}");
    yield UpdatedFootPrint(totConsumption:double.parse((result).toStringAsFixed(2)));
//    yield NewItem(totConsumption:double.parse((0).toStringAsFixed(2)));
  }
}
