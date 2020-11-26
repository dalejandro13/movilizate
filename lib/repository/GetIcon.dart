import 'package:flutter/material.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:provider/provider.dart';

class GetIcon{

  InfoRouteServer info3;
  ValueNotifier<List<bool>> listOfTransport = null;
  //var info = Provider.of<ProcessData>(context);
  //var info2 = Provider.of<DataOfPlace>(context);
  //var info3 = Provider.of<InfoRouteServer>(context, listen: false);
  //info3.infoWalkList //obtengo la informacion de la base de datos

  GetIcon(BuildContext context){
    info3 = Provider.of<InfoRouteServer>(context);
    getButtonInterface();
  }
  
  getButtonInterface(){
    listOfTransport = null;
    listOfTransport = ValueNotifier([false, false, false, false]);
    for(int i = 0; i < info3.infoWalkList.length; i++){      
      for(int j = 0; j < info3.infoWalkList[i].legs.length; j++){
        if(info3.infoWalkList[i].legs[j].mode == "SUBWAY"){
          if(listOfTransport.value[0] == false){
            listOfTransport.value[0] = true;
          }
        }
        else if(info3.infoWalkList[i].legs[j].mode == "BUS"){
          if(listOfTransport.value[1] == false){
            listOfTransport.value[1] = true;
          }
        }
        else if(info3.infoWalkList[i].legs[j].mode == "BIKE"){
          if(listOfTransport.value[2] == false){
            listOfTransport.value[2] = true;
          }
        }
        else if(info3.infoWalkList[i].legs[j].mode == "WALK"){
          if(listOfTransport.value[3] == false){
            listOfTransport.value[3] = true;
          }
        }
      }
    }
    listOfTransport.notifyListeners();
  }
}