import 'package:flutter/material.dart';

import 'dart:developer' as dev;

class ControlButton extends StatefulWidget {
  final IconData icon;
  final int value;

  const ControlButton({super.key, required this.icon, required this.value});

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  bool pressedDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Material(
            color: pressedDown ? Colors.blueGrey : Colors.blue,
            child: InkWell(child: Icon(widget.icon)),
          ),
        ),
      ),
      onTapDown: (details) {
        // TODO: Add function to send message here
        setState(() => pressedDown = true);
        dev.log('1');
      },
      onTapUp: (details) {
        // TODO: Add function to send message here
        setState(() => pressedDown = false);
        dev.log('0');
      },
      onTapCancel: () {
        setState(() => pressedDown = false);
      },
      onVerticalDragStart: (details) {
        setState(() => pressedDown = true);
      },
      onVerticalDragEnd: (details) {
        // TODO: Add function to send message here
        setState(() => pressedDown = false);
      },
    );
  }
}
