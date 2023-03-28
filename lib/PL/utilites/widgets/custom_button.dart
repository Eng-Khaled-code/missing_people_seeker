import 'package:finalmps/PL/utilites/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final List<Color>? color;
  final String? text;
  final Function()? onPress;
  final Color? textColor;

  CustomButton(
      {this.color = const [
        Color(0xFF1E88E5),
        Color(0xFF0D47A1),
      ],
      @required this.text,
      required this.onPress,
      this.textColor = Colors.white});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  double? _scale;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller!.value;

    return InkWell(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTap: widget.onPress,
      child: Transform.scale(
        scale: _scale!,
        child: Container(
          height: 46,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.color!),
              boxShadow: [
                BoxShadow(
                  color: Color(0x80000000),
                  blurRadius: 30.0,
                  offset: Offset(0.0, 5.0),
                )
              ],
              borderRadius: BorderRadius.circular(20.0)),
          child: Center(
            child: Text(
              widget.text!,
              textAlign: TextAlign.center,
              style: TextStyles.title.copyWith(color: widget.textColor),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    _controller!.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller!.reverse();
  }
}
