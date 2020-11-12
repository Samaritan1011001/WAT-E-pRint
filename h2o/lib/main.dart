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
import 'package:h2o/screens/home_screen.dart';
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

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FootPrintBloc>(
          create: (BuildContext context) => FootPrintBloc(0.0),
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
      home: HomeScreen(),
    );
  }
}




