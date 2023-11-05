import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  const TabButton({super.key, required this.name, required this.tabIcon});
  final String name;
  final IconData tabIcon;

  @override
  Widget build(BuildContext context) {
    return Tab(
      text: name,
      icon: Icon(tabIcon),
    );
  }
}
