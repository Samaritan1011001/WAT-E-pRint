import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  bool swi = false;
  String placeholderValue = "United States of America";
  DateTime selectedDate;


  SettingsScreen({Key key,this.placeholderValue,this.selectedDate,this.swi}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Text(
            "Notifications",
            style: TextStyle(fontSize: 23),
          ),
          trailing: Switch(
              value: widget.swi,
              onChanged: (changedValue) {
                setState(() {
                  widget.swi = !widget.swi;
                });
              }),
        ),
        Divider(
          thickness: 5,
        ),
//                  Padding(
//                    padding: const EdgeInsets.all(50.0),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      children: <Widget>[
//                        Text("Notifications",style: TextStyle(fontSize: 20),),
//                        Switch(
//                            value: swi, onChanged: (changedValue){
//                          setState(() {
//                            swi=!swi;
//                          });
//                        })
//                      ],
//                    ),
//                  ),
        ListTile(
//                    padding: const EdgeInsets.all(50.0),
          title: new DropdownButton<String>(
            value: widget.placeholderValue,
            style: TextStyle(fontSize: 23),
//                    icon: Icon(Icons.arrow_downward),
//                    iconSize: 24,
            elevation: 16,

            items: <String>[
              'United States of America',
              'China',
              'Australia'
            ].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(
                  value,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (String newValue) {
              setState(() {
                widget.placeholderValue = newValue;
              });
            },
          ),
        ),
        Divider(
          thickness: 5,
        ),

        ListTile(
//                    padding: const EdgeInsets.all(50.0),
          leading: FlatButton(
              onPressed: () async {
                final DateTime picked = await showDatePicker(
                    context: context,
                    initialDate: widget.selectedDate,
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101));
                if (picked != null && picked != widget.selectedDate)
                  setState(() {
                    widget.selectedDate = picked;
                  });
              },
              child: Text(
                "${widget.selectedDate.toLocal()}".split(' ')[0],
                style: TextStyle(fontSize: 23),
              )),
        ),
      ],
    );
  }
}