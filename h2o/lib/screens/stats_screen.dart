import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h2o/blocs/foot_print/foot_print_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:h2o/blocs/theme/theme_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stats screen that shows basic stats/graphs on user's consumption based on inputs in the [AddScreen] tab
class StatsScreen extends StatelessWidget {
//  double totConsumption = 0;
//  Widget chartWidget;
//  StatsScreen({this.chartWidget});

  var data = [];
//    new GallonsPerDay(formattedDate, totConsumption),
//    new GallonsPerDay("Sep 25 Jan", 90),
//    new GallonsPerDay("Sep 24 Jan", 80),
//  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FootPrintBloc, FootPrintState>(
      builder: (context, state) {
        if (state.totConsumption != 0) {
          return ListView(
            children: <Widget>[
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      "Daily Chart",
                      key:Key("daily-chart"),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  )),
              _buildChart([new GallonsPerDay(DateFormat('EE d MMM').format(DateTime.now()), state.totConsumption)]),
            ],
          );
        } else if (state.totConsumption == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ],
            ),
          );
        } else {
          return Center(
              child: Text(
            "Add your consumption to view stats",
            key: Key("empty_stats"),
            style: TextStyle(fontSize: 20),
          ));
        }
      },
    );
  }
}

Widget _buildChart(data) {
  var series = [
    new charts.Series(
      id: 'Clicks',
      domainFn: (GallonsPerDay clickData, _) => clickData.day,
      measureFn: (GallonsPerDay clickData, _) => clickData.gallons,
      data: data,
    ),
  ];
  var chart = new charts.BarChart(
    series,
    animate: true,
  );
  var chartWidget = new Padding(
    padding: new EdgeInsets.all(32.0),
    child: new SizedBox(
      height: 350.0,
      child: chart,
    ),
  );
  return chartWidget;
}

class GallonsPerDay {
  String day;
  double gallons;

  GallonsPerDay(this.day, this.gallons);
}
