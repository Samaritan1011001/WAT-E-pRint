import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h2o/blocs/foot_print/foot_print_bloc.dart';
import 'package:h2o/screens/add_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

/// A goal tracker screen for users to keep track of their water footprint and uses the footPrint state updated in the [AddScreen]
class GoalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
            BlocBuilder<FootPrintBloc, FootPrintState>(
                builder: (context, state)  {
              return  new CircularPercentIndicator(
                radius: 150.0,
                lineWidth: 10.0,
                percent: 1.0,
//                        center: new Text("${double.parse(((totConsumption/80.0)*100).toStringAsFixed(2))}%"),
                center: state.totConsumption!=null?((state.totConsumption / 80.0) < 1.0
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
                progressColor: state.totConsumption!=null?((state.totConsumption / 80.0) < 1.0
                    ? Colors.blue
                    : Colors.red):Colors.blue,
              );}
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
    );
  }
}
