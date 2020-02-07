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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h2o/blocs/foot_print/foot_print_bloc.dart';
import 'package:h2o/screens/add_screen.dart';
import 'package:h2o/screens/goals_screen.dart';
import 'package:h2o/screens/info_screen.dart';
import 'package:h2o/screens/settings_screen.dart';
import 'package:h2o/screens/stats_screen.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:csv/csv.dart';

void main() => runApp(MyApp());


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
      home: BlocProvider(
          create: (BuildContext context) => FootPrintBloc(),
          child: MyStatefulWidget()),
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


    for (int i = 0; i < 3; i++) {
      formKeys.add(GlobalKey<FormState>());
    }
    selectedDate = DateTime.now();
    initial();
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

  @override
  Widget build(BuildContext context) {
//    FootPrintBloc bloc = FootPrintBloc();
    bool swi = false;
//    DateTime selectedDate = DateTime.now();
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: BlocBuilder<FootPrintBloc, FootPrintState>(
//          bloc: bloc,
        builder: (context, state) {
          return NestedScrollView(
            headerSliverBuilder: (BuildContext context,
                bool innerBoxIsScrolled) {
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
                            "Footprint: ${state.totConsumption == null
                                ? 0
                                : state.totConsumption} ga"),
//                      Text(
//                          "Footprint: ${totConsumption == null ? 0 : totConsumption} ga"),
                      ],
                    ),
                    background: Image.asset(
                      totConsumption != null
                          ? (totConsumption < 110
                          ? 'assets/1.jpg'
                          : 'assets/4.jpeg')
                          : 'assets/1.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                totConsumption == null
                    ? Text("Add an item to view stats")
                    : StatsScreen(
                  totConsumption: totConsumption,
                  chartWidget: chartWidget,
                ),
                InfoScreen(
                  infoData: infoData,
                ),
                AddScreen(tiles: tiles,),
                GoalsScreen(
                  totConsumption: totConsumption,
                ),
                SettingsScreen(placeholderValue: placeholderValue,
                  selectedDate: selectedDate,
                  swi: swi,),
              ],
            ),
          );
        },
        ),
        floatingActionButton: addItem
            ? FloatingActionButton.extended(
                onPressed: () {
                  _handleFormSubmit(BlocProvider.of<FootPrintBloc>(context));
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

  _handleFormSubmit(local_bloc) async {
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
      ans["q1"] = food_answers["q1"] * 264.172 * multiplier / 1000000;
    }
    if (items.contains("Vegetables fresh nes")) {
      var multiplier = csvTable[items.indexOf("Vegetables fresh nes")][1];
//                print("Hereee : $multiplier");

      ans["q5"] = food_answers["q5"] * 264.172 * multiplier / 1000000;
//                print("Hereee : ${food_answers["q5"]}");

    }
    if (items.contains("Fruit Fresh Nes")) {
      var multiplier = csvTable[items.indexOf("Fruit Fresh Nes")][1];
      ans["q6"] = food_answers["q6"] * 264.172 * multiplier / 1000000;
    }
    if (items.contains("Potatoes")) {
      var multiplier = csvTable[items.indexOf("Potatoes")][1];
      ans["q7"] = food_answers["q7"] * 264.172 * multiplier / 1000000;
    }
    if (items.contains("Cassava")) {
      var multiplier = csvTable[items.indexOf("Cassava")][1];
      ans["q7"] = ans["q7"] * 264.172 * multiplier / 1000000;
    }
    if (items.contains("Coffee, green")) {
      var multiplier = csvTable[items.indexOf("Coffee, green")][1];
      ans["q8"] = food_answers["q8"] * 264.172 * multiplier / 1000000;
    }
    if (items.contains("Tea")) {
      var multiplier = csvTable[items.indexOf("Tea")][1];
      ans["q9"] = food_answers["q9"] * 264.172 * multiplier / 1000000;
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
    local_bloc.add(UpdateTotCons(totConsumption: double.parse((result).toStringAsFixed(2))));
//    setState(() {
//      totConsumption = double.parse((result).toStringAsFixed(2));
//    });
    await prefs.setString('food_answers', jsonEncode(food_answers));
    await prefs.setDouble('totConsumption', totConsumption);
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
