import 'package:flutter/material.dart';
import 'package:h2o/main.dart';
import 'package:h2o/models/item.dart';
import 'package:url_launcher/url_launcher.dart';


/// General Info screen that also has an expanded list tile with useful links [static screen]
class InfoScreen extends StatefulWidget {
  List<Item> infoData = [];
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.infoData = [
      Item(
        headerValue: "How can I reduce my water footprint?",
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Do not leave the water running while brushing teeth or washing your hands.",
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Install a dual-flush toilet system. It will save up to 11 cubic metres of water per year! ",
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Take showers sharter than 10 minutes long.",
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "If you only have a few dishes, do not wash it in the dish washer. Either wait till there's more, or wash by hand.",
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
        ),
      ),
      Item(
          headerValue: "Why should we care?",
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "To guard against rising costs and potential conflict in times of water shortage or difficulties in food production.",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "It minimizes the effects of droughts and water shortages.",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Helps to preserve our environment and lessen the toll on global warming.",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "To better distribute water usage to other purposes.",
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
          )),
      Item(
        headerValue: "Useful resources",
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    _launchURL("https://www.constellation.com/energy-101/water-conservation-tips0.html");
                  },
                  child: Text(
                    "Information on vegetables",
                    style: TextStyle(fontSize: 20, decoration: TextDecoration.underline, color: Colors.blueAccent),
                  )),
              GestureDetector(
                  onTap: () {
                    _launchURL("https://wateruseitwisely.com/");
                  },
                  child: Text(
                    "Water Use It Wisely",
                    style: TextStyle(fontSize: 20, decoration: TextDecoration.underline, color: Colors.blueAccent),
                  )),
              GestureDetector(
                  onTap: () {
                    _launchURL("https://www.thebalancesmb.com/conservation-efforts-why-should-we-save-water-3157877");
                  },
                  child: Text(
                    "5 Reasons We Should Care About Saving Water",
                    style: TextStyle(fontSize: 20, decoration: TextDecoration.underline, color: Colors.blueAccent),
                  )),
              GestureDetector(
                  onTap: () {
                    _launchURL(
                        "https://www.volusia.org/services/growth-and-resource-management/environmental-management/natural-resources/water-conservation/25-ways-to-save-water.stml");
                  },
                  child: Text(
                    " 25 ways to save water",
                    style: TextStyle(fontSize: 20, decoration: TextDecoration.underline, color: Colors.blueAccent),
                  )),
            ],
          ),
        ),
        isExpanded: true,
      ),
    ];
  }

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
          children: widget.infoData?.map<ExpansionPanel>((Item item) {
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    item.headerValue,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                );
              },
              body: item.body,
              canTapOnHeader: true,
              isExpanded: item.isExpanded,
            );
          })?.toList(),
        ),
      ],
    );
  }

  _launchURL(url) async {
//  const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}
