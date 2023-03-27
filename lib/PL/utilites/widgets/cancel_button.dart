import 'package:flutter/material.dart';
import '../strings.dart';
import '../text_style/font_sizes.dart';

class CancelButton extends StatelessWidget {
  const CancelButton(
      {Key? key,
      this.textColor = Colors.white,
      this.fontSize = FontSizes.errorDialog})
      : super(key: key);
  final Color? textColor;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        Strings.cancel,
      ),
    );
  }
}
