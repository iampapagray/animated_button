import 'package:beauty_button/animated_button.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beautiful Button',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purpleAccent
      ),home: Scaffold(
        appBar: AppBar(
          title: Text('My Button Animation'),
        ),
        body: Center(
          child: AnimatedButton(
            onTap: (){
              print("done");
            },
            animationDuration: const Duration(milliseconds: 1000),
            initialText: "Confirm",
            finalText: "Submitted",
            iconData: Icons.check,
            iconSize: 32.0,
            buttonStyle: ButtonStyle(
              primaryColor: Colors.purpleAccent,
              secondaryColor: Colors.white,
              elevation: 20.0,
              initialTextStyle: TextStyle(
                fontSize: 22.0,
                color: Colors.white,
              ),
              finalTextStyle: TextStyle(
                fontSize: 22.0,
                color: Colors.purpleAccent,
              ),
              borderRadius: 10.0
            ),
          ),
        ),
      ),
    );
  }
}