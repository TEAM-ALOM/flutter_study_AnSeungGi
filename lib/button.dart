import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String text;
  final bool flag;
  final bool isCo;
  final bool? isRe;
  final VoidCallback? onPressed;
  const Button({
    super.key,
    required this.text,
    required this.flag,
    required this.isCo,
    this.isRe = false,
    required this.onPressed,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child:
          widget.isRe == false
              ? SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onPressed,
                  child: Text(widget.text, style: TextStyle(fontSize: 20)),
                ),
              )
              : Padding(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: ElevatedButton(
                  onPressed: widget.onPressed,
                  child: Text(widget.text, style: TextStyle(fontSize: 20)),
                ),
              ),
    );
  }
}
