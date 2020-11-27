import 'package:flutter/material.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:provider/provider.dart';
import 'package:movilizate/repository/ConsultServer.dart';

class MatchList extends StatefulWidget {

  // ConsultServer consult;

  // MatchList(ConsultServer consult){
  //   //this.consult = consult;
  // }

  @override
  _MatchListState createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  
  // List<String> details = ["uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve", "diez",
  // "once", "doce", "trece", "catorce", "quince", "dieciseis", "diecisiete", "dieciocho", "diecinueve", "veinte"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    //widget.consult.getPreviousInfo();
  }

  // void _onFocusChange(ProcessData info, DataOfPlace info2, int index){
  //   try{
  //     if(info.focusOrigin.hasFocus){
  //       info.dataOrigin.text = info2.infoPlace[index].title;
  //       //almacenar latitud y longitud de origen
  //       info.getLatitudeOrigin = info2.infoPlace[index].lat;
  //       info.getLongitudeOrigin = info2.infoPlace[index].lon;
  //     }
  //   }
  //   catch(e){
  //     print("Error $e");
  //   }
  // }

  // void _onFocusChange2(ProcessData info, DataOfPlace info2, int index){
  //   try{
  //     if(info.focusDestiny.hasFocus){ 
  //       info.dataDestiny.text = info2.infoPlace[index].title;
  //       //almacenar latitud y longitud de destino
  //       info.getLatitudeDestiny = info2.infoPlace[index].lat;
  //       info.getLongitudeDestiny = info2.infoPlace[index].lon;
  //       info.focusDestiny.dispose();
  //     }
  //   }
  //   catch(e){
  //     print("Error $e");
  //   }
  // }

  void checkFocus(ProcessData info, DataOfPlace info2, int index) {
    try{
      if(info.focusOrigin.hasFocus){
        info.dataOrigin.text = info2.infoPlace[index].title;
        //almacenar latitud y longitud de origen
        info.getLatitudeOrigin = info2.infoPlace[index].lat;
        info.getLongitudeOrigin = info2.infoPlace[index].lon;
      }
      else{
        if(info.focusDestiny.hasFocus){
          info.dataDestiny.text = info2.infoPlace[index].title;
          //almacenar latitud y longitud de destino
          info.getLatitudeDestiny = info2.infoPlace[index].lat;
          info.getLongitudeDestiny = info2.infoPlace[index].lon;
        }
      }
      // if(info.focusOrigin2.hasFocus){
      //   info.dataOrigin.text = info2.infoPlace[index].title;
      //   //almacenar latitud y longitud de origen
      //   info.getLatitudeOrigin = info2.infoPlace[index].lat;
      //   info.getLongitudeOrigin = info2.infoPlace[index].lon;
      // }
      // else{
      //   if(info.focusDestiny2.hasFocus){
      //     info.dataDestiny.text = info2.infoPlace[index].title;
      //     //almacenar latitud y longitud de destino
      //     info.getLatitudeDestiny = info2.infoPlace[index].lat;
      //     info.getLongitudeDestiny = info2.infoPlace[index].lon;
      //   }
      // }
    }
    catch(e){
      print("Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<ProcessData>(context);
    var info2 = Provider.of<DataOfPlace>(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: ListView.separated(
        itemCount: info2.infoPlace.length,
        separatorBuilder: (_, __) => Divider(height: 1.5),
        
        itemBuilder: (BuildContext context, int index){
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 100.0,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListTile(
              title: Text(
                "Nombre: " + info2.infoPlace[index].title,
                style: TextStyle(
                  fontFamily: "AurulentSans-Bold",
                  fontSize: 25.0,
                  color: Color.fromRGBO(105, 190, 50, 1.0)
                ),
              ),
              subtitle: Text(
                "Prueba - Autocompletado - lista",
                style: TextStyle(
                  fontFamily: "AurulentSans-Bold",
                ),
              ),
              leading: Icon(
                Icons.location_on,
                size: 40.0,
                color: Color.fromRGBO(105, 190, 50, 1.0),
              ),
              onTap: (){
                try{
                  checkFocus(info, info2, index);
                  //info.focusOrigin.addListener(_onFocusChange(info, info2, index));
                  //info.focusDestiny.addListener(_onFocusChange2(info, info2, index));
                }
                catch(e){
                  print("Error $e");
                }
              },
            ),
          );
        },
      ),
    );
  }
}