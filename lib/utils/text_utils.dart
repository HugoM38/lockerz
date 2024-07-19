import 'package:flutter/material.dart';

class TextUtil extends StatelessWidget {
  final String text;
  final bool weight;
  final double size;
  final Color? color;

  const TextUtil({
    required this.text,
    this.weight = false,
    this.size = 14,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight ? FontWeight.bold : FontWeight.normal,
        color: color ?? Colors.white,
      ),
    );
  }
}
