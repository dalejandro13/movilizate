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
  List<DataOfPlace> place;
  int increment = 0;

  TextOriginDestiny(String text, ConsultServer consult, Color color, TextEditingController control, FocusNode focusText, bool activate, bool isSecondScreen){
    this.text = text;
    this.consult = consult;
    this.color = color;
    this.control = control;
    this.focusText = focusText;
    this.activate = activate;
    this.isSecondScreen = isSecondScreen;
    place = [];
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
        focusNode: focusText,
        style: TextStyle(
          fontFamily: "AurulentSans-Bold",
          color: color,
          fontSize: 18.0,
        ),
        decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(
            fontFamily: "AurulentSans-Bold",
            color: color,
            fontSize: 20.0,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 15.8, right: 5.0, bottom: 7.0),
          prefixIcon: IconButton(
            icon: Icon(Icons.location_on),
            onPressed: (){},
            iconSize: 20.0,
            color: color,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              //controller.text = "";
              //info.dataOrigin.text = "";
              control.text = "";
              increment = 0;
              info2.infoPlace = [];
              if(isSecondScreen){
                info2.infoPlace = null;
                info2.infoPlace = [];
                place = null;
                place = [];
                Navigator.pop(context, text);
              }
            },
            iconSize: 20.0,
            color: color,
          ),
        ),
        onChanged: activate ? (val) async {
          
          if(val.length >= 3){
            if(val.length > increment){ //evitar la consulta cuando se empieza a borra en el TextFormField
              increment = val.length;
              info.dataText.text = val;
              await consult.getInfoInSearch(info, info2, place); //consulto en la base de datos para llenar la lista
            }
            else{
              increment = val.length;
            }
          }
          else if(val.length >= 0 && val.length <= 2){
            consult.place = null;
            info2.infoPlace = null;
            consult.place = [];
            info2.infoPlace = [];
            place = null;
            place = [];
            increment = 0;
          }
          else if(val.length < 0){
            increment = 0;
            consult.place = null;
            info2.infoPlace = null;
            consult.place = [];
            info2.infoPlace = [];
            place = null;
            place = [];
          }
        }:
        null,
      ),
    );
  }
}