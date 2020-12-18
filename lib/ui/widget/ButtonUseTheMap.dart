import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movilizate/ui/screen/ScreenBigMap.dart';

class UseTheMap extends StatefulWidget {
  @override
  _UseTheMapState createState() => _UseTheMapState();
}

class _UseTheMapState extends State<UseTheMap> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: RaisedButton(
        color: Colors.white,
        onPressed: () async {
          try {
            var result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenBigMap()));
            }
            else{
              Fluttertoast.showToast(
                msg: "Estas desconectado de internet, intenta conectarte a una red",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 20.0,
              );
            }
          } 
          catch(e) {
            Fluttertoast.showToast(
              msg: "Estas desconectado de internet, intenta conectarte a una red",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 20.0,
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
            ),
            Text(
              "Use the map",
              style: TextStyle(
                fontFamily: "AurulentSans-Bold",
                color: Color.fromRGBO(81, 81, 81, 1.0),
                fontSize: 25.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}