import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h2o/blocs/foot_print/foot_print_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.trending_up, color: Colors.grey[600]),
                  Text(
                    "${double.parse((((state.totConsumption - 90) / 90) * 100).toStringAsFixed(2))}% from last days",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),
                ],
              ),
              _buildChart([
                new GallonsPerDay(DateFormat('EE d MMM').format(DateTime.now()),
                    state.totConsumption)
              ]),
            ],
          );
        } else {
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
