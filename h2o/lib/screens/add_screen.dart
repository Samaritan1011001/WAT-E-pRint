import 'package:flutter/material.dart';
import 'package:h2o/main.dart';

class AddScreen extends StatefulWidget {
  Map tiles = {};
  AddScreen({this.tiles});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.tiles.length,
        itemBuilder: (BuildContext context, int index) {
          var key = widget.tiles.keys.elementAt(index);
          print(key);
          return Card(
            elevation: 10,
            child: _buildPanel(widget.tiles[key]["data"], key),
          );
        });
  }
  Widget _buildPanel(data, key) {
    print("Key -> ${key}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            key,
            style: TextStyle(fontSize: 20),
          ),
        ),
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              data[index].isExpanded = !isExpanded;
            });
          },
          children: data.map<ExpansionPanel>((Item item) {
            return ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    item.headerValue,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                );
              },
              body: item.body,
              isExpanded: item.isExpanded,
            );
          }).toList(),
        ),
      ],
    );
  }
}


