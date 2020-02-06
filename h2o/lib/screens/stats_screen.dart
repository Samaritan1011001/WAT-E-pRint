import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  double totConsumption = 0;
  Widget chartWidget;
  StatsScreen({this.totConsumption,this.chartWidget});

  @override
  Widget build(BuildContext context) {
    return ListView(
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
    );
  }
}
