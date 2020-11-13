import 'package:flutter/material.dart';

class SettingsButton extends StatefulWidget {
  @override
  _SettingsButtonState createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: IconButton(
        icon: Icon(Icons.settings), 
        iconSize: 20.0, 
        onPressed: () {}
      )
    );
  }
}