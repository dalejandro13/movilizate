import 'package:flutter/material.dart';

class MessageDialog extends StatefulWidget {
  String information = null;
  MessageDialog(@required String informacion){
    this.information = information;
  }

  @override
  _MessageDialogState createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Error"),
      content: Text(widget.information),
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