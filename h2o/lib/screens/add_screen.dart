import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h2o/blocs/foot_print/foot_print_bloc.dart';
import 'package:h2o/main.dart';
import 'package:intl/intl.dart';

class AddScreen extends StatefulWidget {
  List mapData = [];
  AddScreen({this.mapData});
  List<GlobalKey<FormState>> formKeys = [];
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapData.forEach((data){
      widget.formKeys.add(GlobalKey<FormState>());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
              width: 150,
              height: 50,
              child: RaisedButton(
                onPressed: () {
                  Map questionAnswers = {};
                  int ind = mapData.indexWhere((data)=>data["id"]==DateFormat('EE d MMM').format(DateTime.now()));
                  formKeys[ind].currentState.save();
                  mapData[ind]["sections"].forEach((sec){
                    questionAnswers.addAll(sec["question_answers"]);
                  });
//                  print("questionAnswers : ${questionAnswers}");
                  BlocProvider.of<FootPrintBloc>(context).add(ItemAdded(questionAnswers: questionAnswers));
                },
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Colors.blue,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
              )),
        ),
        Flexible(
          child: ListView.builder(
              itemCount: mapData.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 10,
                  child: _buildPanel(mapData[index],index),
                );
              }),
        ),
      ],
    );
  }

  Widget _buildPanel(data,ind) {

    return Form(
      key: formKeys[ind],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data["id"],
              style: TextStyle(fontSize: 20),
            ),
          ),
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                data["sections"][index]['isExpanded'] =
                    !data["sections"][index]['isExpanded'];
              });
            },
            children: data['sections'].map<ExpansionPanel>((Map item) {
              List qs = item['question_answers'].keys.toList();
              return ExpansionPanel(
                canTapOnHeader: true,
                isExpanded: item['isExpanded'],
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(
                      item['name'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  );
                },
                body: Column(
                  children: qs.map<Widget>((q) {
//                    print("Entry : ${q.value}");
                    return ListTile(
                      title: Text(q),
                      trailing: Container(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            SizedBox(
                              width: 50.0,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                initialValue: item['question_answers'][q],
                                onSaved: (text) {
                                  print(text);
                                  item['question_answers'][q] =
                                      text;
//                              print(food_answers);
                                },
                              ),
                            ),
                            Text("grams"),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
//              isExpanded: item.isExpanded,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

//_handleFormSubmit(local_bloc) async {
//  Map ans = {};
//  formKeys[0].currentState.save();
//  List items = [];
//  csvTable.forEach((product_wf) {
//    print(product_wf);
//    items.add(product_wf[0]);
//  });
//  if (items.contains("Cereals, nes")) {
//    var multiplier = csvTable[items.indexOf("Cereals, nes")][1];
//    ans["q1"] = food_answers["q1"] * 264.172 * multiplier / 1000000;
//  }
//  if (items.contains("Vegetables fresh nes")) {
//    var multiplier = csvTable[items.indexOf("Vegetables fresh nes")][1];
//    ans["q5"] = food_answers["q5"] * 264.172 * multiplier / 1000000;
//  }
//  if (items.contains("Fruit Fresh Nes")) {
//    var multiplier = csvTable[items.indexOf("Fruit Fresh Nes")][1];
//    ans["q6"] = food_answers["q6"] * 264.172 * multiplier / 1000000;
//  }
//  if (items.contains("Potatoes")) {
//    var multiplier = csvTable[items.indexOf("Potatoes")][1];
//    ans["q7"] = food_answers["q7"] * 264.172 * multiplier / 1000000;
//  }
//  if (items.contains("Cassava")) {
//    var multiplier = csvTable[items.indexOf("Cassava")][1];
//    ans["q7"] = ans["q7"] * 264.172 * multiplier / 1000000;
//  }
//  if (items.contains("Coffee, green")) {
//    var multiplier = csvTable[items.indexOf("Coffee, green")][1];
//    ans["q8"] = food_answers["q8"] * 264.172 * multiplier / 1000000;
//  }
//  if (items.contains("Tea")) {
//    var multiplier = csvTable[items.indexOf("Tea")][1];
//    ans["q9"] = food_answers["q9"] * 264.172 * multiplier / 1000000;
//  }
//
//  ans["q2"] = food_answers["q2"] * 5.308 * 264.172 / 1000;
//  ans["q3"] = food_answers["q3"] * 0.693 * 264.172 / 1000;
//  ans["q4"] = food_answers["q4"] * 0.0753 * 264.172 / 1000;
//
//  var values = ans.values;
//  var result = values.reduce((sum, element) => sum + element);
//  local_bloc.add(UpdateTotCons(
//      totConsumption: double.parse((result).toStringAsFixed(2))));
//  await prefs.setString('food_answers', jsonEncode(food_answers));
//  await prefs.setDouble('totConsumption', totConsumption);
//}