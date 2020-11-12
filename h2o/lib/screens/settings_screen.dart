import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:h2o/blocs/theme/theme_bloc.dart';
import 'package:h2o/themes/app_themes.dart';

class SettingsScreen extends StatefulWidget {
  bool swi = false;
  bool darkModeSwitch = false;
  String placeholderValue = "United States of America";
  DateTime selectedDate;


  SettingsScreen({Key key, this.selectedDate,this.swi}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
//      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Text(
            "Night Mode",
            style: TextStyle(fontSize: 23),
          ),
          trailing: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return Switch(
              key: Key("dark-mode"),
                value: state.switchValue,
                onChanged: (changedValue) {
                  BlocProvider.of<ThemeBloc>(context)
                      .add(ThemeChanged(switchVal:state.switchValue, theme: !widget.darkModeSwitch?AppTheme.DarkTheme:AppTheme.LightTheme));
                });
          }
          ),
        ),
        Divider(
          thickness: 2,
        ),
        ListTile(
          title: Text(
            "Notifications",
            style: TextStyle(fontSize: 23),
          ),
          trailing: Switch(
              value: widget.swi,
              onChanged: (changedValue) {
                setState(() {
                  widget.swi = !widget.swi;
                });
              }),
        ),
        Divider(
          thickness: 2,
        ),

        ListTile(
//                    padding: const EdgeInsets.all(50.0),
          title: new DropdownButton<String>(
            value: widget.placeholderValue,
            style: TextStyle(fontSize: 23),
            elevation: 16,

            items: <String>[
              'United States of America',
              'China',
              'Australia'
            ].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(
                  value,
                  style: BlocProvider.of<ThemeBloc>(context).state.themeData.textTheme.headline1,
                ),
              );
            }).toList(),
            onChanged: (String newValue) {
              setState(() {
                widget.placeholderValue = newValue;
              });
            },
          ),
        ),
      ],
    );
  }
}