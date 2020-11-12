import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'foot_print_event.dart';

part 'foot_print_state.dart';

/// Bloc used to perform state updates on FootPrint
class FootPrintBloc extends Bloc<FootPrintEvent, FootPrintState> {
  FootPrintBloc(double initialState) : super(InitialFootPrintState(initialState));
  @override
  Stream<FootPrintState> mapEventToState(FootPrintEvent event) async* {
    if (event is UpdateFootPrint){
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
  }
}
