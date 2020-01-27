// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:csv/csv.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());
_launchURL(url) async {
//  const url = 'https://flutter.dev';
  if (await canLaunch(url)) {
    await launch(url, forceWebView: true);
  } else {
    throw 'Could not launch $url';
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
    this.body,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
  Widget body;
}

DateTime now = DateTime.now();
String formattedDate = DateFormat('EE d MMM').format(now);

List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>()];
SharedPreferences prefs;
Map food_answers = {};

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  bool addItem = false;
  static double totConsumption = 0;
  List<Item> _data;
  Map tiles = {};
  List<Item> infoData;

  String placeholderValue = "United States of America";

  initState() {
    super.initState();
    infoData = [
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
                      _launchURL(
                          "https://www.constellation.com/energy-101/water-conservation-tips0.html");
                    },
                    child: Text(
                      "Information on vegetables",
                      style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent),
                    )),
                GestureDetector(
                    onTap: () {
                      _launchURL("https://wateruseitwisely.com/");
                    },
                    child: Text(
                      "Water Use It Wisely",
                      style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent),
                    )),
                GestureDetector(
                    onTap: () {
                      _launchURL(
                          "https://www.thebalancesmb.com/conservation-efforts-why-should-we-save-water-3157877");
                    },
                    child: Text(
                      "5 Reasons We Should Care About Saving Water",
                      style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent),
                    )),
                GestureDetector(
                    onTap: () {
                      _launchURL(
                          "https://www.volusia.org/services/growth-and-resource-management/environmental-management/natural-resources/water-conservation/25-ways-to-save-water.stml");
                    },
                    child: Text(
                      " 25 ways to save water",
                      style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent),
                    )),
              ],
            ),
          )),
    ];
//    _data = generateItems(3);
    for (int i = 0; i < 3; i++) {
      formKeys.add(GlobalKey<FormState>());
    }
    selectedDate = DateTime.now();

    initial();

//    DateTime now = DateTime.now();
  }

  var myData;
  DateTime selectedDate;
  List<List<dynamic>> csvTable;
  initial() async {
    myData = await rootBundle.loadString("assets/data.csv");
    csvTable = CsvToListConverter().convert(myData);

    print("CSV fields ${csvTable}");

    prefs = await SharedPreferences.getInstance();
    setState(() {
      totConsumption = prefs.getDouble("totConsumption");
      data[0] = new GallonsPerDay(formattedDate, totConsumption);
    });
  }

  static var data = [
    new GallonsPerDay(formattedDate, totConsumption),
    new GallonsPerDay("Sep 25 Jan", 90),
    new GallonsPerDay("Sep 24 Jan", 80),
  ];
  static var series = [
    new charts.Series(
      id: 'Clicks',
      domainFn: (GallonsPerDay clickData, _) => clickData.day,
      measureFn: (GallonsPerDay clickData, _) => clickData.gallons,
      data: data,
    ),
  ];
  static var chart = new charts.BarChart(
    series,
    animate: true,
  );
  static var chartWidget = new Padding(
    padding: new EdgeInsets.all(32.0),
    child: new SizedBox(
      height: 350.0,
      child: chart,
    ),
  );
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) async {
    print(index);
    if (index == 0) {
      print("tapped");
      print(totConsumption);
      setState(() {
        data[0].gallons = totConsumption;
        _selectedIndex = index;
        addItem = false;
      });
    } else if (index == 2) {
//      prefs.setString("food_answers", Map().toString());
      if (prefs.getString("food_answers") != null)
        food_answers = jsonDecode(prefs.getString("food_answers"));
      setState(() {
//      tiles.clear();
        if (tiles.keys.isNotEmpty) {
          tiles.keys.forEach((k) {
            tiles.update(
              k,
              (existingValue) => {"data": generateItems(3, food_answers, k)},
              ifAbsent: () => {"data": generateItems(3, food_answers, k)},
            );
          });
        } else {
          tiles[formattedDate] = {
            "data": generateItems(3, food_answers, formattedDate)
          };
        }

//      tiles[now.toString()] = {"data":generateItems(3,food_answers,now.toString())};
        addItem = true;
      });
    } else {
      setState(() {
        _selectedIndex = index;
        addItem = false;
      });
    }
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
//      key: Key(key),
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

  @override
  Widget build(BuildContext context) {
    bool swi = false;
//    DateTime selectedDate = DateTime.now();
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Daily Water Use",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
//                      SizedBox(height: 100,),
                      Text(
                          "Footprint: ${totConsumption == null ? 0 : totConsumption} ga"),
                    ],
                  ),
                  background: Image.asset(
                    totConsumption!=null?(totConsumption < 110 ? 'assets/1.jpg' : 'assets/4.jpeg'):'assets/1.jpg',
                    fit: BoxFit.fill,
                  ),
//                  Image.network(
//                    "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
//                    fit: BoxFit.cover,
//                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              totConsumption == null
                  ? Text("Add an item to view stats")
                  : ListView(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(Icons.trending_up,color: Colors.grey[600]
                            ),
                            Text(
                              "${double.parse((((totConsumption - 90) / 90) * 100).toStringAsFixed(2))}% from last days",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600]
                              ),
                            ),
                          ],
                        ),
                        chartWidget,
                      ],
                    ),
              ListView(
                children: <Widget>[
                  ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        infoData[index].isExpanded = !isExpanded;
                      });
                    },
                    children: infoData.map<ExpansionPanel>((Item item) {
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
              ),
              ListView.builder(
                  itemCount: tiles.length,
                  itemBuilder: (BuildContext context, int index) {
                    var key = tiles.keys.elementAt(index);
                    print(key);
//          <Widget>[
                    return Card(
                      elevation: 10,
                      child: _buildPanel(tiles[key]["data"], key),
                    );
//          ],
                  }),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                          width: 200,
                          child: Text(
                            "Use Less than 80 gallons per day",
                            style: TextStyle(fontSize: 23),
                          )),
                      new CircularPercentIndicator(
                        radius: 150.0,
                        lineWidth: 10.0,
                        percent: 1.0,
//                        center: new Text("${double.parse(((totConsumption/80.0)*100).toStringAsFixed(2))}%"),
                        center: totConsumption!=null?((totConsumption / 80.0) < 1.0
                            ? new Icon(
                                Icons.check,
                                size: 80,
                              )
                            : new Icon(
                                Icons.clear,
                                size: 80,
                              )):new Icon(
                          Icons.check,
                          size: 80,
                        ),
                        progressColor: totConsumption!=null?((totConsumption / 80.0) < 1.0
                            ? Colors.blue
                            : Colors.red):Colors.blue,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                          width: 200,
                          child: Text(
                            "Shower for less than 10 minutes per day for 7 consecutive days",
                            style: TextStyle(fontSize: 23),
                          )),
                      new CircularPercentIndicator(
                        radius: 150.0,
                        lineWidth: 10.0,
                        percent: 0.5,
                        center: new Text("50%",style: TextStyle(fontSize: 23),),
                        progressColor: Colors.blue,
                      )
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "Notifications",
                      style: TextStyle(fontSize: 23),
                    ),
                    trailing: Switch(
                        value: swi,
                        onChanged: (changedValue) {
                          setState(() {
                            swi = !swi;
                          });
                        }),
                  ),
                  Divider(thickness: 5,),
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
                      value: placeholderValue,
                      style: TextStyle(fontSize: 23),
//                    icon: Icon(Icons.arrow_downward),
//                    iconSize: 24,
                    elevation: 16,

                      items: <String>['United States of America', 'China','Australia']
                          .map((String value) {
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
                          placeholderValue = newValue;
                        });
                      },
                    ),
                  ),
                  Divider(thickness: 5,),

                  ListTile(
//                    padding: const EdgeInsets.all(50.0),
                    leading: FlatButton(
                        onPressed: () async {
                          final DateTime picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2015, 8),
                              lastDate: DateTime(2101));
                          if (picked != null && picked != selectedDate)
                            setState(() {
                              selectedDate = picked;
                            });
                        },
                        child: Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                          style: TextStyle(fontSize: 23),
                        )),
                  ),

                ],
              ),
            ],
          ),
//        addItem
//            ?
//            : _widgetOptions.elementAt(_selectedIndex),
        ),
        floatingActionButton: addItem
            ? FloatingActionButton.extended(
                onPressed: () async {
                  Map ans = {};
                  formKeys[0].currentState.save();
                  List items = [];
                  csvTable.forEach((product_wf) {
                    print(product_wf);
                    items.add(product_wf[0]);
                  });
                  if (items.contains("Cereals, nes")) {
//                print(product_wf);
                    var multiplier = csvTable[items.indexOf("Cereals, nes")][1];
                    ans["q1"] =
                        food_answers["q1"] * 264.172 * multiplier / 1000000;
                  }
                  if (items.contains("Vegetables fresh nes")) {
                    var multiplier =
                        csvTable[items.indexOf("Vegetables fresh nes")][1];
//                print("Hereee : $multiplier");

                    ans["q5"] =
                        food_answers["q5"] * 264.172 * multiplier / 1000000;
//                print("Hereee : ${food_answers["q5"]}");

                  }
                  if (items.contains("Fruit Fresh Nes")) {
                    var multiplier =
                        csvTable[items.indexOf("Fruit Fresh Nes")][1];
                    ans["q6"] =
                        food_answers["q6"] * 264.172 * multiplier / 1000000;
                  }
                  if (items.contains("Potatoes")) {
                    var multiplier = csvTable[items.indexOf("Potatoes")][1];
                    ans["q7"] =
                        food_answers["q7"] * 264.172 * multiplier / 1000000;
                  }
                  if (items.contains("Cassava")) {
                    var multiplier = csvTable[items.indexOf("Cassava")][1];
                    ans["q7"] = ans["q7"] * 264.172 * multiplier / 1000000;
                  }
                  if (items.contains("Coffee, green")) {
                    var multiplier =
                        csvTable[items.indexOf("Coffee, green")][1];
                    ans["q8"] =
                        food_answers["q8"] * 264.172 * multiplier / 1000000;
                  }
                  if (items.contains("Tea")) {
                    var multiplier = csvTable[items.indexOf("Tea")][1];
                    ans["q9"] =
                        food_answers["q9"] * 264.172 * multiplier / 1000000;
                  }

//            print(ans['q1']);
//            ans["q1"] = food_answers["q1"] * 0.596 * 264.172;
                  ans["q2"] = food_answers["q2"] * 5.308 * 264.172 / 1000;
                  ans["q3"] = food_answers["q3"] * 0.693 * 264.172 / 1000;
                  ans["q4"] = food_answers["q4"] * 0.0753 * 264.172 / 1000;
//            ans["q5"] = food_answers["q5"] * 0.153 * 264.172;
//            ans["q6"] = food_answers["q6"] * 0.208 * 264.172;
//            ans["q7"] = food_answers["q7"] * 0.110 * 264.172;
//            ans["q8"] = food_answers["q8"] * 0.0392 * 264.172;
//            ans["q9"] = food_answers["q9"] * 0.0351 * 264.172;
                  var values = ans.values;
                  print(ans.values);
                  var result = values.reduce((sum, element) => sum + element);
                  print(result);
                  setState(() {
                    totConsumption = double.parse((result).toStringAsFixed(2));
                  });
                  await prefs.setString(
                      'food_answers', jsonEncode(food_answers));
                  await prefs.setDouble('totConsumption', totConsumption);
                },
                label: Text('Submit'),
                backgroundColor: Colors.blue,
              )
            : null,
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.score),
              text: "Stats",
            ),
            Tab(
              icon: Icon(Icons.info_outline),
              text: "Info",
            ),
            Tab(
              icon: Icon(Icons.add),
              text: "Add",
            ),
            Tab(
              icon: Icon(Icons.format_list_bulleted),
              text: "Goals",
            ),
            Tab(
              icon: Icon(Icons.settings),
              text: "Settings",
            ),
          ],
          onTap: _onItemTapped,
          indicatorColor: Colors.black,
          labelColor: Colors.blue,
        ),
      ),
    );
  }

  List<Item> generateItems(int numberOfItems, answers, key) {
    print("TESTTT");
    print(answers);
    List<Item> items = [];

//    return items;
    return [
      Item(
        headerValue: 'Food',
        body: Form(
          key: formKeys[0],
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text("Cereal Products"),
                trailing: Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: 50.0,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: answers.containsKey("q1")
                              ? answers["q1"].toString()
                              : "0.0",
                          onSaved: (text) {
                            print(text.runtimeType);
                            food_answers["q1"] = double.parse(text);
                            print(food_answers);
                          },
                        ),
                      ),
                      Text("grams"),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text("Meat products"),
                trailing: Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: 50.0,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: answers.containsKey("q2")
                              ? answers["q2"].toString()
                              : "0.0",
                          onSaved: (text) {
                            food_answers["q2"] = double.parse(text);
                            print(food_answers);
                          },
                        ),
                      ),
                      Text("grams"),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text("Dairy products"),
                trailing: Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: 50.0,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: answers.containsKey("q3")
                              ? answers["q3"].toString()
                              : "0.0",
                          onSaved: (text) {
                            food_answers["q3"] = double.parse(text);
                            print(food_answers);
                          },
                        ),
                      ),
                      Text("grams"),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text("Eggs"),
                trailing: Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: 50.0,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: answers.containsKey("q4")
                              ? answers["q4"].toString()
                              : "0.0",
                          onSaved: (text) {
                            food_answers["q4"] = double.parse(text);
                            print(food_answers);
                          },
                        ),
                      ),
                      Text("grams"),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text("Vegetables"),
                trailing: Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: 50.0,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: answers.containsKey("q5")
                              ? answers["q5"].toString()
                              : "0.0",
                          onSaved: (text) {
                            food_answers["q5"] = double.parse(text);
                            print("Hereee : ${food_answers["q5"]}");
                          },
                        ),
                      ),
                      Text("grams"),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text("Fruits"),
                trailing: Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: 50.0,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: answers.containsKey("q6")
                              ? answers["q6"].toString()
                              : "0.0",
                          onSaved: (text) {
                            food_answers["q6"] = double.parse(text);
                            print(food_answers);
                          },
                        ),
                      ),
                      Text("grams"),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text("Starchy roots (potatoes, cassava)"),
                trailing: Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: 50.0,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: answers.containsKey("q7")
                              ? answers["q7"].toString()
                              : "0.0",
                          onSaved: (text) {
                            food_answers["q7"] = double.parse(text);
                            print(food_answers);
                          },
                        ),
                      ),
                      Text("grams"),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text("How many cups of coffee do you take per day?"),
                trailing: Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: 50.0,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: answers.containsKey("q8")
                              ? answers["q8"].toString()
                              : "0.0",
                          onSaved: (text) {
                            food_answers["q8"] = double.parse(text);
                            print(food_answers);
                          },
                        ),
                      ),
                      Text("cups"),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text("How many cups of tea do you take per day?"),
                trailing: Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: 50.0,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: answers.containsKey("q9")
                              ? answers["q9"].toString()
                              : "0.0",
                          onSaved: (text) {
                            food_answers["q9"] = double.parse(text);
                            print(food_answers);
                          },
                        ),
                      ),
                      Text("cups"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        expandedValue: 'How many meals per day?',
      ),
      Item(
        headerValue: 'Indoor activities',
        body: Container(),
        expandedValue: 'How many baths per day?',
      ),
      Item(
        headerValue: 'Outdoor activities',
        body: Container(),
        expandedValue: 'How many car washes per week?',
      ),
    ];
  }
}

class GallonsPerDay {
  String day;
  double gallons;

  GallonsPerDay(this.day, this.gallons);
}
