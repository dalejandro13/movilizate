import 'package:flutter/material.dart';

class MessageDialog extends StatefulWidget {
  @override
  _MessageDialogState createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Error"),
      content: Text("Problemas con el procesamiento de la informacion, vuelve a intentarlo"),
      actions: [
        FlatButton(
          child: Text("Aceptar"),
          textColor: Colors.blue,
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}