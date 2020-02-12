import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
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
    }else if (event is ItemAdded){

      yield* _mapItemAddedToState(event);
    }
  }
  Stream<AddItem> _mapItemAddedToState(ItemAdded event) async*{
    var myData;
    List<List<dynamic>> csvTable;
    myData = await rootBundle.loadString("assets/data.csv");
    csvTable = CsvToListConverter().convert(myData);
//    print("CSV fields ${csvTable}");
    List items = [];
    csvTable.forEach((product_wf) {
//      print(product_wf);
      items.add(product_wf[0]);
    });
    Map questionAnswers = event.questionAnswers;

//    if (items.contains("Cereals, nes")) {
//      var multiplier = csvTable[items.indexOf("Cereals, nes")][1];
//      ans["q1"] = food_answers["q1"] * 264.172 * multiplier / 1000000;
//    }
//    if (items.contains("Vegetables fresh nes")) {
//      var multiplier = csvTable[items.indexOf("Vegetables fresh nes")][1];
//      ans["q5"] = food_answers["q5"] * 264.172 * multiplier / 1000000;
//    }
//    if (items.contains("Fruit Fresh Nes")) {
//      var multiplier = csvTable[items.indexOf("Fruit Fresh Nes")][1];
//      ans["q6"] = food_answers["q6"] * 264.172 * multiplier / 1000000;
//    }
//    if (items.contains("Potatoes")) {
//      var multiplier = csvTable[items.indexOf("Potatoes")][1];
//      ans["q7"] = food_answers["q7"] * 264.172 * multiplier / 1000000;
//    }
//    if (items.contains("Cassava")) {
//      var multiplier = csvTable[items.indexOf("Cassava")][1];
//      ans["q7"] = ans["q7"] * 264.172 * multiplier / 1000000;
//    }
//    if (items.contains("Coffee, green")) {
//      var multiplier = csvTable[items.indexOf("Coffee, green")][1];
//      ans["q8"] = food_answers["q8"] * 264.172 * multiplier / 1000000;
//    }
//    if (items.contains("Tea")) {
//      var multiplier = csvTable[items.indexOf("Tea")][1];
//      ans["q9"] = food_answers["q9"] * 264.172 * multiplier / 1000000;
//    }
//
//    ans["q2"] = food_answers["q2"] * 5.308 * 264.172 / 1000;
//    ans["q3"] = food_answers["q3"] * 0.693 * 264.172 / 1000;
//    ans["q4"] = food_answers["q4"] * 0.0753 * 264.172 / 1000;
    print("questionAnswers : ${questionAnswers.values.runtimeType}");

    List values = questionAnswers.values.toList();
    double result=0.0;
    values.forEach((value){
      result+=double.parse(value);
    });

    UpdateTotCons(
        totConsumption: double.parse((result).toStringAsFixed(2)));
    yield AddItem(double.parse((result).toStringAsFixed(2)));
  }
}
