import 'package:flutter/material.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:provider/provider.dart';
import 'package:movilizate/repository/ConsultServer.dart';

class MatchList extends StatefulWidget {

  FocusNode focusOrigin, focusDestiny;

  MatchList(FocusNode focusOrigin, FocusNode focusDestiny){
    this.focusOrigin = focusOrigin;
    this.focusDestiny = focusDestiny;
  }

  @override
  _MatchListState createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {

  Future<void> checkFocus(ProcessData info, DataOfPlace info2, int index) async {
    try{
      if(widget.focusOrigin.hasFocus){
        info.dataOrigin.text = info2.infoPlace[index].title;
        //almacenar latitud y longitud de origen
        info.getLatitudeOrigin = info2.infoPlace[index].lat;
        info.getLongitudeOrigin = info2.infoPlace[index].lon;

        //animacion para TextFormField de origen
        info.opacityLevelOrigin = info.opacityLevelOrigin == 1.0 ? 0.5 : 1.0;
        await Future.delayed(Duration(milliseconds: 200));                         
        info.opacityLevelOrigin = info.opacityLevelOrigin == 1.0 ? 1.0 : 1.0;

      }
      else{
        if(widget.focusDestiny.hasFocus){
          info.dataDestiny.text = info2.infoPlace[index].title;
          //almacenar latitud y longitud de destino
          info.getLatitudeDestiny = info2.infoPlace[index].lat;
          info.getLongitudeDestiny = info2.infoPlace[index].lon;

          //animacion para TextFormField de destino
          info.opacityLevelDestiny = info.opacityLevelDestiny == 1.0 ? 0.5 : 1.0;
          await Future.delayed(Duration(milliseconds: 200));                                   
          info.opacityLevelDestiny = info.opacityLevelDestiny == 1.0 ? 1.0 : 1.0;

        }
      }
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
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200.0, minHeight: 100.0),
            child: Material(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  info2.infoPlace[index].title,
                  style: TextStyle(
                    fontFamily: "AurulentSans-Bold",
                    fontSize: 25.0,
                    color: Color.fromRGBO(105, 190, 50, 1.0),
                  ),
                ),
                subtitle: Text(
                  info2.infoPlace[index].title,
                  style: TextStyle(
                    fontFamily: "AurulentSans-Bold",
                  ),
                ),
                leading: Icon(
                  Icons.location_on,
                  size: 40.0,
                  color: widget.focusDestiny.hasFocus ? Color.fromRGBO(105, 190, 50, 1.0) : Color.fromRGBO(0, 0, 0, 1.0),
                ),
                onTap: () async {                  
                  try{
                    await checkFocus(info, info2, index);
                  }
                  catch(e){
                    print("Error $e");
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}