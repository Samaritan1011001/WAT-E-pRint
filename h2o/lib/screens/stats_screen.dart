import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h2o/blocs/foot_print/foot_print_bloc.dart';

class StatsScreen extends StatelessWidget {
//  double totConsumption = 0;
  Widget chartWidget;
  StatsScreen({this.chartWidget});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<FootPrintBloc, FootPrintState>(
    builder: (context, state) {

    return ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.trending_up,color: Colors.grey[600]
              ),
              Text(
                "${double.parse((((state.totConsumption - 90) / 90) * 100).toStringAsFixed(2))}% from last days",
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
    },
    );
  }
}
