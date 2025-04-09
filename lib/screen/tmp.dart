import 'package:flutter/material.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: "ID",
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "PASSWORD",
              ),
            )
          ],
        ),
      ),
      
    );
  }
}