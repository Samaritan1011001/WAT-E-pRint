part of 'foot_print_bloc.dart';

abstract class FootPrintEvent {
  const FootPrintEvent();
}

class UpdateFootPrint extends FootPrintEvent{
  final Map questionAnswers;
  const UpdateFootPrint({this.questionAnswers});
}
