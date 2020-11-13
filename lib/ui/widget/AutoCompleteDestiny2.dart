import 'package:flutter/material.dart';
import 'package:movilizate/repository/ConsultServer.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:provider/provider.dart';

class AutoCompleteDestiny2 extends StatefulWidget {

  ConsultServer consult;

  AutoCompleteDestiny2(ConsultServer consult){
    this.consult = consult;
  }

  @override
  _AutoCompleteDestiny2State createState() => _AutoCompleteDestiny2State();
}

class _AutoCompleteDestiny2State extends State<AutoCompleteDestiny2> {

  //FocusNode _focusDestiny2 = FocusNode();
  //TextEditingController controller = TextEditingController(); 
  //ConsultServer consult = ConsultServer();

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<ProcessData>(context);
    var info2 = Provider.of<DataOfPlace>(context);
    return Container(
      height: 40.0,
      width: MediaQuery.of(context).size.width - 10.0, //310.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white
      ),
      child: TextFormField(
        onTap: (){
          print("presionaste TextField");
        },
        controller: info.dataDestiny,
        focusNode: info.focusDestiny2,
        style: TextStyle(
          fontFamily: "AurulentSans-Bold",
          fontSize: 20.0,
          color: Color.fromRGBO(105, 190, 50, 1.0)
        ),
        decoration: InputDecoration(
          hintText: "Destino",
          hintStyle: TextStyle(
            fontFamily: "AurulentSans-Bold",
            fontSize: 20.0,
            color: Color.fromRGBO(105, 190, 50, 1.0)
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 15.8, right: 5.0, bottom: 7.0),
          prefixIcon: IconButton(
            icon: Icon(Icons.location_on),
            onPressed: (){},
            iconSize: 20.0,
            color: Color.fromRGBO(105, 190, 50, 1.0),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              //controller.text = "";
              info.dataDestiny.text = "";
              info2.infoPlace = [];
            },
            iconSize: 20.0,
            color: Color.fromRGBO(105, 190, 50, 1.0),
          ),
        ),
        onChanged: (val) async {
          // if(val.length >= 3){
          //   info.dataText.text = val;
          //   await widget.consult.getInfoInMaps(info, info2);
          // }
          // if(val.length >= 0 && val.length <= 2 ){
          //   widget.consult.place = null;
          //   widget.consult.place = [];
          //   info2.infoPlace = [];
          // }
        },
      ),
    );
  }
}