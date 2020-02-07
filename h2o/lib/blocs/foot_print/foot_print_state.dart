part of 'foot_print_bloc.dart';

abstract class FootPrintState {
  final double totConsumption;
  const FootPrintState(this.totConsumption);
}

class UpdatePrint extends FootPrintState{
  const UpdatePrint(double totConsumption) : super(totConsumption);
}

class InitialFootPrintState extends FootPrintState {
  const InitialFootPrintState(double totConsumption) : super(totConsumption);
}