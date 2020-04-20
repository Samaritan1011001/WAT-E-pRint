
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h2o/blocs/foot_print/foot_print_bloc.dart';
import 'package:h2o/blocs/foot_print/theme/theme_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<FootPrintBloc>(
          create: (BuildContext context) => FootPrintBloc(),
        ),
        BlocProvider<ThemeBloc>(
          create: (BuildContext context) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: _buildWithTheme,
      ),
    );
  }
  Widget _buildWithTheme(BuildContext context, ThemeState state) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: state.themeData,
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
    selectedDate = DateTime.now();
  }

  var myData;
  DateTime selectedDate;
  List<List<dynamic>> csvTable;



  void _onItemTapped(int index) async {
    print(index);
    if (index == 0) {
      setState(() {
        _selectedIndex = index;
        addItem = false;
      });
    } else if (index == 2) {
//      if (prefs.getString("food_answers") != null)
//        food_answers = jsonDecode(prefs.getString("food_answers"));
      setState(() {
//      tiles.clear();
//        if (tiles.keys.isNotEmpty) {
//          tiles.keys.forEach((k) {
//            tiles.update(
//              k,
//                  (existingValue) =>
//              {
//                "data": generateItems(3, food_answers, k)
//              },
//              ifAbsent: () => {"data": generateItems(3, food_answers, k)},
//            );
//          });
//        } else {
//          tiles[formattedDate] = {
//            "data": generateItems(3, food_answers, formattedDate)
//          };
//        }

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
//    FootPrintBloc fpBloc = BlocProvider.of<FootPrintBloc>(context);
    bool swi = false;
//    DateTime selectedDate = DateTime.now();
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: BlocBuilder<FootPrintBloc, FootPrintState>(
//          bloc: bloc,
          builder: (context, state) {
            return NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
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
                              fontSize: 16.0,
                            ),
                          ),
//                      SizedBox(height: 100,),
                          Text(
                              "Footprint: ${state.totConsumption == null
                                  ? 0
                                  : state.totConsumption} ga"),

                        ],
                      ),
                      background: Image.asset(
                        state.totConsumption != null
                            ? (state.totConsumption < 110
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
                  state.totConsumption == null
                      ? Text("Add an item to view stats")
                      : StatsScreen(
//                  totConsumption: totConsumption,
//                  chartWidget: chartWidget,
                  ),
                  InfoScreen(),
                  AddScreen(
                    mapData: mapData,
                  ),
                  GoalsScreen(),
                  SettingsScreen(
                    placeholderValue: placeholderValue,
                    selectedDate: selectedDate,
                    swi: swi,
                  ),
                ],
              ),
            );
          },
        ),
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
}

List<Map> mapData = [
  {
    "id": "Wed 12 Feb",
    "sections": [
      {
        "name": "food",
        "isExpanded":false,
        "question_answers": {
          "Cereal Products": "0.0",
          "Meat products": "0.0",
          "Dairy products": "0.0",
          "Eggs": "0.0",
          "Vegetables": "0.0",
          "Fruits": "0.0",
          "Starchy roots (potatoes, cassava)": "0.0",
          "How many cups of coffee do you take per day?": "0.0",
        }
      },
      {
        "name": "Indoor Activities",
        "isExpanded":false,
        "question_answers": {"How many baths per day?": "0.0"},
      },
      {
        "name": "Outdoor Activities",
        "isExpanded":false,
        "question_answers": {"How many car washes per week?": "0.0"},
      },
    ],
  },
];

