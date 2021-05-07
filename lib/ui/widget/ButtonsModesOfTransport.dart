import 'package:flutter/material.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:provider/provider.dart';

class ButtonsModesOfTransport extends StatefulWidget {

  InfoRouteServer info3;
  ProcessData info;
  bool erase = true;
  List<int> listIndex;

  ButtonsModesOfTransport(BuildContext context) {
    info = Provider.of<ProcessData>(context);
    info3 = Provider.of<InfoRouteServer>(context, listen: false);
  }

  @override
  _ButtonsModesOfTransportState createState() => _ButtonsModesOfTransportState();
}

class _ButtonsModesOfTransportState extends State<ButtonsModesOfTransport>{

  double size = 60.0;

  Future<void> startIt() async {
    if(widget.info3.iconAux != null){
      if(widget.info3.iconAux.isNotEmpty){
        for(int i = 0; i < widget.info3.iconAux.length; i++){
          widget.info3.listOfInfo.add(widget.info3.iconAux[i]); //obtiene de nuevo el dato original que se habia borrado previamente
        }
      }
    }
    widget.info3.filterActive = true;
    widget.listIndex = null;
    widget.listIndex = [];
    widget.info3.iconAux = null;
    widget.info3.iconAux = [];
  }

  Future<void> selectTransport(String transport) async {
    if(transport == "cable_car"){
      widget.info.selectTransport = transport;
      widget.info.transportCableCar = true;
      widget.info.transportSubway = false;
      widget.info.transportBus = false;
      widget.info.transportBike = false;
      widget.info.transportWalk = false;
    }
    else if(transport == "subway"){
      widget.info.selectTransport = transport;
      widget.info.transportCableCar = false;
      widget.info.transportSubway = true;
      widget.info.transportBus = false;
      widget.info.transportBike = false;
      widget.info.transportWalk = false;
    }
    else if(transport == "bus"){
      widget.info.selectTransport = transport;
      widget.info.transportCableCar = false;
      widget.info.transportSubway = false;
      widget.info.transportBus = true;
      widget.info.transportBike = false;
      widget.info.transportWalk = false;
    }
    else if(transport == "bike"){
      widget.info.selectTransport = transport;
      widget.info.transportCableCar = false;
      widget.info.transportSubway = false;
      widget.info.transportBus = false;
      widget.info.transportBike = true;
      widget.info.transportWalk = false;
    }
    else if(transport == "walk") {
      widget.info.selectTransport = transport;
      widget.info.transportCableCar = false;
      widget.info.transportSubway = false;
      widget.info.transportBus = false;
      widget.info.transportBike = false;
      widget.info.transportWalk = true;
    }
  }

  Future<void> compareTransport() async {
    for(int i = 0; i < widget.info3.listOfInfo.length; i++){
      for(int j = 0; j < widget.info3.listOfInfo[i].legs.length; j++){
        if(widget.info3.listOfInfo[i].legs[j].cableCar.toLowerCase() == widget.info.selectTransport){
          widget.erase = false;
        }
        else if(widget.info3.listOfInfo[i].legs[j].subway.toLowerCase() == widget.info.selectTransport){
          widget.erase = false;
        }
        else if(widget.info3.listOfInfo[i].legs[j].bus.toLowerCase() == widget.info.selectTransport){
          widget.erase = false;
        }
        else if(widget.info3.listOfInfo[i].legs[j].bike.toLowerCase() == widget.info.selectTransport){
          widget.erase = false;
        }
        else if(widget.info3.listOfInfo[i].legs[j].walk.toLowerCase() == widget.info.selectTransport){
          widget.erase = false;
        }

      }

      if(widget.erase){
        widget.erase = true;
        widget.info3.iconAux = null;
        widget.info3.iconAux = [];
        widget.listIndex.add(i);
      }
      else{
        widget.erase = true; 
      }

    }
  }

  Future<void> filterIt() async {
    if(widget.info3.listOfInfo.isNotEmpty){
      if(widget.listIndex.isNotEmpty){
        widget.erase = true;
        widget.info3.listOfInfoAux = null;
        widget.info3.listOfInfoAux = [];
        for(int b = 0; b < widget.listIndex.length; b++){ //lista de indices
          for(int a = 0; a < widget.info3.listOfInfo.length; a++){ //lista con la informacion original de la base de datos
            if(a != widget.listIndex[b]){
              //widget.info3.iconAux.add(widget.info3.listOfInfo[widget.listIndex[b]]);
              //widget.info3.listOfInfo.removeAt(widget.listIndex[b]);
              //widget.info3.listOfInfoAux = widget.info3.listOfInfo;
              widget.info3.listOfInfoAux.add(widget.info3.listOfInfo[a]);
              print("listo");
              print("listo");
            }
          }
        }
      }
      else{
        widget.erase = true;
        widget.info3.filterActive = false;
      }
    }
  }

  Future<void> endIt() async {
    if(widget.info3.iconAux != null){
      if(widget.info3.iconAux.isNotEmpty){
        for(int i = 0; i < widget.info3.iconAux.length; i++){
          widget.info3.listOfInfo.add(widget.info3.iconAux[i]); //obtiene de nuevo el dato original que se habia borrado previamente
        }
      }
    }
    widget.info3.filterActive = false;
    widget.info3.listOfInfoAux = null;
    widget.info3.listOfInfoAux = [];
    widget.erase = true;
    widget.listIndex = null;
    widget.listIndex = [];
    widget.info3.iconAux = null;
    widget.info3.iconAux = [];
    widget.info.selectTransport = "";
    widget.info.transportCableCar = false;
    widget.info.transportSubway = false;
    widget.info.transportBus = false;
    widget.info.transportBike = false;
    widget.info.transportWalk = false;
  }

  Widget cardButton(int index, bool value, bool transport) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: transport ? Color.fromRGBO(87, 114, 26, 1.0) : Colors.transparent,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: 
                index == 0 ? () async {
                  if(!widget.info.transportCableCar){
                    await startIt();

                    await selectTransport("cable_car");

                    await compareTransport();

                    await filterIt();

                  }
                  else{
                    await endIt();
                  }
                }:
                index == 1 ? () async {
                  if(!widget.info.transportSubway){
                    await startIt();
                    
                    await selectTransport("subway");

                    await compareTransport();

                    await filterIt();

                  }
                  else{
                    await endIt();
                  }
                }:
                index == 2 ? () async {
                  if(!widget.info.transportBus){
                    await startIt();
                    
                    await selectTransport("bus");

                    await compareTransport();

                    await filterIt();

                  }
                  else{
                    await endIt();
                  }
                }:
                index == 3 ? () async {
                  if(!widget.info.transportBike){
                    await startIt();
                    
                    await selectTransport("bike");

                    await compareTransport();

                    await filterIt();

                  }
                  else{
                    await endIt();
                  }
                }:
                () async {
                  if(!widget.info.transportWalk){
                    await startIt();
                    
                    await selectTransport("walk");

                    await compareTransport();

                    await filterIt();

                  }
                  else{
                    await endIt();
                  }
                },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    index == 0 ? 
                      ImageIcon(
                        AssetImage("images/cablewayWhite.png"), //TODO: CHANGE THE IMAGE
                        size: 60.0,
                        color: Colors.white,
                      ): 
                    index == 1 ? 
                      Icon(
                        Icons.directions_subway,
                        size: size,
                        color: Colors.white,
                      ): 
                    index == 2 ? 
                      Icon(
                        Icons.directions_bus,
                        size: size,
                        color: Colors.white,
                      ):
                    index == 3 ? 
                      Icon(
                        Icons.directions_bike,
                        size: size,
                        color: Colors.white,
                      ):
                      Icon(
                        Icons.directions_walk,
                        size: size,
                        color: Colors.white,
                      ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.info3.bestTime} min", //tiempo optimo
                          style: TextStyle(
                            fontFamily: "AurulentSans-Bold",
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          " ",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      separatorBuilder: (_,__) => Divider(height: 20.0, color: Colors.transparent,),
      itemCount: widget.info3.listOfTransport.length, //widget.dataLegs.ic.listOfTransport.value.length,
      itemBuilder: (BuildContext context, int index){  
        if(index == 0 && widget.info3.listOfTransport[index]){
          return cardButton(index, widget.info3.listOfTransport[index], widget.info.transportCableCar);
        }
        else if(index == 1 && widget.info3.listOfTransport[index]){
          return cardButton(index, widget.info3.listOfTransport[index], widget.info.transportSubway);
        }
        else if(index == 2 && widget.info3.listOfTransport[index]){
          return cardButton(index, widget.info3.listOfTransport[index], widget.info.transportBus);
        }
        else if(index == 3 && widget.info3.listOfTransport[index]){
          return cardButton(index, widget.info3.listOfTransport[index], widget.info.transportBike);
        }
        else if(index == 4 && widget.info3.listOfTransport[index]){
          return cardButton(index, widget.info3.listOfTransport[index], widget.info.transportWalk);
        }
        else{
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.transparent,
            ),
          );
        }
      },
    );
  }
}