part of 'foot_print_bloc.dart';

abstract class FootPrintState {
  final double totConsumption;
  const FootPrintState(this.totConsumption);
}

class UpdatedFootPrint extends FootPrintState {
  UpdatedFootPrint({double totConsumption}):super(totConsumption);
}

class InitialFootPrintState extends FootPrintState {
  const InitialFootPrintState(double totConsumption) : super(totConsumption);
}