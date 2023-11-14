import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/providers/bt_controller.dart';

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
    final provider = Provider.of<BtController>(context);
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35.0),
          child: Material(
            color:
                pressedDown ? const Color(0xFF001c3a) : const Color(0xFF1e5fa6),
            child: InkWell(
                child: Icon(widget.icon, color: const Color(0xFFd2e4ff))),
          ),
        ),
      ),
      onTapDown: (details) {
        provider.motorControl |= widget.value;
        provider.sendMessage();
        setState(() => pressedDown = true);
      },
      onTapUp: (details) {
        if (pressedDown) {
          provider.motorControl &= ~widget.value;
        }
        provider.sendMessage();
        setState(() => pressedDown = false);
      },
      onVerticalDragEnd: (details) {
        if (pressedDown) {
          provider.motorControl &= ~widget.value;
        }
        provider.sendMessage();
        setState(() => pressedDown = false);
      },
    );
  }
}
