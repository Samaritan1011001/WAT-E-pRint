import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h2o/blocs/foot_print/foot_print_bloc.dart';
import 'package:h2o/blocs/foot_print/theme/theme_bloc.dart';
import 'package:h2o/screens/home_screen.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Save Water';

  @override
  Widget build(BuildContext context) {

    /// Providers two blocs used in the app
    /// - FootPrintBloc
    /// - ThemeBloc
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




