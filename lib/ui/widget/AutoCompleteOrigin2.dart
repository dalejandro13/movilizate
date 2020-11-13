import 'package:flutter/material.dart';
import 'package:movilizate/repository/ConsultServer.dart';
import 'package:provider/provider.dart';
import 'package:movilizate/bloc/ProcessData.dart';

class AutoCompleteOrigin2 extends StatefulWidget {

  ConsultServer consult;

  AutoCompleteOrigin2(ConsultServer consult){
    this.consult = consult;
  }

  @override
  _AutoCompleteOrigin2State createState() => _AutoCompleteOrigin2State();
}

class _AutoCompleteOrigin2State extends State<AutoCompleteOrigin2> {

  //FocusNode _focusOrigin = FocusNode();
  //TextEditingController controller = TextEditingController(); 
  //ConsultServer consult = ConsultServer();

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<ProcessData>(context);
    var info2 = Provider.of<DataOfPlace>(context);
    return Container(
      height: 40.0,
      width: MediaQuery.of(context).size.width - 10.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white
      ),
      child: TextFormField(
        controller: info.dataOrigin,
        focusNode: info.focusOrigin2,
        style: TextStyle(
          fontFamily: "AurulentSans-Bold",
          color: Color.fromRGBO(81, 81, 81, 1.0),
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          hintText: "Origen",
          hintStyle: TextStyle(
            fontFamily: "AurulentSans-Bold",
            color: Color.fromRGBO(81, 81, 81, 1.0),
            fontSize: 20.0,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 15.8, right: 5.0, bottom: 7.0),
          prefixIcon: IconButton(
            icon: Icon(Icons.location_on),
            onPressed: (){},
            iconSize: 20.0,
            color: Color.fromRGBO(81, 81, 81, 1.0),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              //controller.text = "";
              info.dataOrigin.text = "";
              info2.infoPlace = [];
            },
            iconSize: 20.0,
            color: Color.fromRGBO(81, 81, 81, 1.0),
          ),
        ),
        onChanged: (val) async {
          // if(val.length >= 3){
          //   info.dataText.text = val;
          //   await widget.consult.getInfoInMaps(info, info2);
          // }
          // else if(val.length >= 0 && val.length <= 2 ){
          //   widget.consult.place = null;
          //   widget.consult.place = [];
          //   info2.infoPlace = [];
          // }
        },
      ),
    );
  }
}