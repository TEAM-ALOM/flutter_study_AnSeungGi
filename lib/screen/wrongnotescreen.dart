import 'package:flutter/material.dart';
import 'package:flutter_app/screen/wrongbar.dart';
class Wrongnotescreen extends StatefulWidget {
  const Wrongnotescreen({super.key});

  @override
  State<Wrongnotescreen> createState() => _WrongnotescreenState();
}

class _WrongnotescreenState extends State<Wrongnotescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '오답',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
        
      ),
      
    );
  }
}