import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color? textcolor;
  const TextWidget({Key? key, required this.text, this.textcolor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(color: textcolor));
  }
}
