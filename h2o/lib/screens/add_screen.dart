import 'package:flutter/material.dart';
import 'package:h2o/main.dart';

class AddScreen extends StatefulWidget {
  List mapData = [];
  AddScreen({this.mapData});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: mapData.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 10,
            child: _buildPanel(mapData[index]),
          );
        });
  }

  Widget _buildPanel(data) {
    List expansionList = [];
    return Column(
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
              data["sections"][index]['isExpanded'] = !data["sections"][index]['isExpanded'];
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
              body: Form(
                child: Column(
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
//                              food_answers["q1"] = double.parse(text);
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
              ),
//              isExpanded: item.isExpanded,
            );
          }).toList(),
        ),
      ],
    );
  }
}
