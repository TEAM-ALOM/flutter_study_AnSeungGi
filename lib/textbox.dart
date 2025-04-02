import 'package:flutter/material.dart';


class Textbox extends StatefulWidget {
  final String question;
  const Textbox({super.key, required this.question});
  
  @override
  State<Textbox> createState() => _TextboxState();
}

class _TextboxState extends State<Textbox> {
  String Q = '';
  @override
  void initState(){
    super.initState();
    Q = widget.question;
  }
  
  @override
  void didUpdateWidget(covariant Textbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.question != widget.question) {
      setState(() {
        Q = widget.question;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(Q,
      textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
      ),
      );
  }
}
