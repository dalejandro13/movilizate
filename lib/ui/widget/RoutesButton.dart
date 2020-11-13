import 'package:flutter/material.dart';

class RoutesButton extends StatefulWidget {
  @override
  _RoutesButtonState createState() => _RoutesButtonState();
}

class _RoutesButtonState extends State<RoutesButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 60,
                width: 60,
                child: RaisedButton(
                  color: Colors.white,
                  child: ImageIcon(
                    new AssetImage('images/List-Routes.png'),
                    color: Colors.grey,
                  ),
                  shape: CircleBorder(),
                  onPressed: () {},
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20, top: 7),
                child: Text(
                  "Routes",
                  style: TextStyle(
                      color: Colors.grey[800], fontFamily: "AvenirLT-Light"),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}