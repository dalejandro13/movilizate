import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String msg) {
    AlertDialog alert = AlertDialog(
      title: Text("Advertencia"),
      content: Text(msg),
      actions: [
        FlatButton(
          child: Text("Aceptar"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }