part of 'foot_print_bloc.dart';

abstract class FootPrintEvent {
  const FootPrintEvent();
}

class UpdateTotCons extends FootPrintEvent{
  final double totConsumption;
  const UpdateTotCons({this.totConsumption});
}

class ItemAdded extends FootPrintEvent{
  final Map questionAnswers;
  const ItemAdded({this.questionAnswers});
}
