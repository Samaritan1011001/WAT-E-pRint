import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h2o/blocs/foot_print/foot_print_bloc.dart';
import 'package:h2o/blocs/foot_print/theme/theme_bloc.dart';
import 'package:h2o/models/item.dart';
import 'package:h2o/screens/add_screen.dart';
import 'package:h2o/screens/goals_screen.dart';
import 'package:h2o/screens/settings_screen.dart';
import 'package:h2o/screens/stats_screen.dart';

import 'info_screen.dart';


/// The landing screen that has 5 tabs.
/// This screen also uses SliverAppBar and NestedScrollView widgets to host all the five tabViews
class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool addItem = false;
  Map tiles = {};
  List<Item> infoData;

  initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  var myData;
  DateTime selectedDate;
  List<List<dynamic>> csvTable;

  @override
  Widget build(BuildContext context) {
    bool swi = false;
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
                flexibleSpace: BlocBuilder<FootPrintBloc, FootPrintState>(builder: (context, state) {
                  return FlexibleSpaceBar(
                    centerTitle: true,
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Text(
                            "Daily Water Use",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text("Footprint: ${state.totConsumption == null ? 0 : state.totConsumption} GA")),
                      ],
                    ),
                    background: Image.asset(
                      state.totConsumption != null ? (state.totConsumption < 110 ? 'assets/1.jpg' : 'assets/4.jpeg') : 'assets/1.jpg',
                      fit: BoxFit.fill,
                    ),
                  );
                }),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              StatsScreen(),
              InfoScreen(),
              AddScreen(),
              GoalsScreen(),
              SettingsScreen(
                selectedDate: selectedDate,
                swi: swi,
              ),
            ],
          ),
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
          indicatorColor: Colors.black,
          labelColor: Colors.blue,
        ),
      ),
    );
  }
}
