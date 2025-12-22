import 'package:flutter/material.dart';

class StatePadding extends StatelessWidget {
  const StatePadding({super.key, required this.childWidget});
  final Widget childWidget;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: childWidget,
    );
  }
}
