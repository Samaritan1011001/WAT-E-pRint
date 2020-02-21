part of 'foot_print_bloc.dart';

abstract class FootPrintState extends Equatable {
  @override
  List<Object> get props => [];

  final double totConsumption;
  const FootPrintState(this.totConsumption);
}

class UpdatePrint extends FootPrintState{
  const UpdatePrint(double totConsumption) : super(totConsumption);
}

class NewItem extends FootPrintState {
  NewItem({double totConsumption}):super(totConsumption);
}

class InitialFootPrintState extends FootPrintState {
  const InitialFootPrintState(double totConsumption) : super(totConsumption);
}