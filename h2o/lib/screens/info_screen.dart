import 'package:flutter/material.dart';
import 'package:h2o/main.dart';

class InfoScreen extends StatefulWidget {
  List<Item> infoData;

  InfoScreen({Key key,this.infoData}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              widget.infoData[index].isExpanded = !isExpanded;
            });
          },
          children: widget.infoData.map<ExpansionPanel>((Item item) {
            return ExpansionPanel(
              headerBuilder:
                  (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    item.headerValue,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                );
              },
              body: item.body,
              canTapOnHeader: true,
              isExpanded: item.isExpanded,
            );
          }).toList(),
        ),
      ],
    );
  }
}