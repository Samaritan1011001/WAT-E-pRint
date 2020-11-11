import 'package:flutter/material.dart';

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