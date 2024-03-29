import 'package:flutter/material.dart';

class FeatureCardModel {
  final IconData icon;
  final String label;
  final Widget screen;

  FeatureCardModel(
      {required this.icon, required this.label, required this.screen});
}
