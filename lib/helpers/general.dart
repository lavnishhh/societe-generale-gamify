import 'dart:math';
import 'package:flutter/material.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class AppButton extends StatefulWidget {
  final Widget content;
  final VoidCallback onTap;
  final Color color;
  const AppButton({super.key, required this.content, required this.onTap, this.color = Colors.transparent});

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(color: Theme.of(context).primaryColor),
          color: widget.color
        ),
        padding: EdgeInsets.all(12),
        child: widget.content,
      ),
    );
  }
}