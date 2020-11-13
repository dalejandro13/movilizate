import 'package:flutter/material.dart';

class PlacesButton extends StatefulWidget {
  @override
  _PlacesButtonState createState() => _PlacesButtonState();
}

class _PlacesButtonState extends State<PlacesButton> {
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
                    new AssetImage('images/Buildings.png'),
                    color: Colors.grey,
                  ),
                  shape: CircleBorder(),
                  onPressed: () {},
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20, top: 7),
                child: Text(
                  "Places",
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