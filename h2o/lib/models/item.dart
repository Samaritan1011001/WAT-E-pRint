import 'package:flutter/material.dart';
import 'package:h2o/screens/info_screen.dart';

/// Item model used in the [InfoScreen]
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