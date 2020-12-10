import 'package:flutter/material.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/repository/ConsultServer.dart';
import 'package:provider/provider.dart';

class TextOriginDestiny extends StatelessWidget {

  String text;
  ConsultServer consult;
  Color color;
  TextEditingController control;
  FocusNode focusText;
  bool activate;
  bool isSecondScreen;

  TextOriginDestiny(String text, ConsultServer consult, Color color, TextEditingController control, FocusNode focusText, bool activate, bool isSecondScreen){
    this.text = text;
    this.consult = consult;
    this.color = color;
    this.control = control;
    this.focusText = focusText;
    this.activate = activate;
    this.isSecondScreen = isSecondScreen;
  }

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<ProcessData>(context);
    var info2 = Provider.of<DataOfPlace>(context);
    return Container(
      height: 40.0,
      width: MediaQuery.of(context).size.width - 3.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white
      ),
      child: TextFormField(
        controller: control,
        focusNode: focusText, //_focusOrigin, //info.focusOrigin,
        style: TextStyle(
          fontFamily: "AurulentSans-Bold",
          color: color, //Color.fromRGBO(81, 81, 81, 1.0),
          fontSize: 18.0,
        ),
        decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(
            fontFamily: "AurulentSans-Bold",
            color: color, //Color.fromRGBO(81, 81, 81, 1.0),
            fontSize: 20.0,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 15.8, right: 5.0, bottom: 7.0),
          prefixIcon: IconButton(
            icon: Icon(Icons.location_on),
            onPressed: (){},
            iconSize: 20.0,
            color: color, //Color.fromRGBO(81, 81, 81, 1.0),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              //controller.text = "";
              //info.dataOrigin.text = "";
              control.text = "";
              info2.infoPlace = [];
              if(isSecondScreen){
                info2.infoPlace = null;
                info2.infoPlace = [];
                Navigator.pop(context, text);
              }
            },
            iconSize: 20.0,
            color: color, //Color.fromRGBO(81, 81, 81, 1.0),
          ),
        ),
        onChanged: activate ? (val) async {
          if(val.length >= 3){
            info.dataText.text = val;
            await consult.getInfoInMaps(info, info2);
          }
          else if(val.length >= 0 && val.length <= 2){
            consult.place = null;
            info2.infoPlace = null;
            consult.place = [];
            info2.infoPlace = [];
          }
          else if(val.length < 0){
            consult.place = null;
            info2.infoPlace = null;
            consult.place = [];
            info2.infoPlace = [];
          }
        }:
        null,
      ),
    );
  }
}