import 'package:flutter/material.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:provider/provider.dart';

class ButtonsModesOfTransport extends StatefulWidget {
  GetDataLegs dataLegs;
  bool subway = false, bus = false, bike = false, walk = false;
  GetInnerIconsInfo gii;

  ButtonsModesOfTransport(BuildContext context) {
    this.subway = subway;
    this.bus = bus;
    this.bike = bike;
    this.walk = walk;
    dataLegs = GetDataLegs(context);
    gii = GetInnerIconsInfo(context);
  }

  @override
  _ButtonsModesOfTransportState createState() =>
      _ButtonsModesOfTransportState();
}

class _ButtonsModesOfTransportState extends State<ButtonsModesOfTransport>{

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
                onTap: index == 0 ? (){
                  setState(() {
                    widget.subway = true;
                    widget.bus = false;
                    widget.bike = false;
                    widget.walk = false;
                  });
                }:
                index == 1 ? (){
                  setState(() {
                    widget.subway = false;
                    widget.bus = true;
                    widget.bike = false;
                    widget.walk = false;
                  });              
                }:
                index == 2 ? (){
                  setState(() {
                    widget.subway = false;
                    widget.bus = false;
                    widget.bike = true;
                    widget.walk = false;
                  });
                }:
                (){
                  setState(() {
                    widget.subway = false;
                    widget.bus = false;
                    widget.bike = false;
                    widget.walk = true;
                    widget.gii.infoInner.tile.value[0] = null;
                    widget.gii.infoInner.tile.value[1] = null;
                    widget.gii.infoInner.tile.value[2].clear();
                  });
                },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    index == 0 ? 
                      Icon(
                        Icons.directions_subway,
                        size: 60.0,
                        color: Colors.white,
                      ): 
                    index == 1 ? 
                      Icon(
                        Icons.directions_bus,
                        size: 60.0,
                        color: Colors.white,
                      ): 
                    index == 2 ? 
                      Icon(
                        Icons.directions_bike,
                        size: 60.0,
                        color: Colors.white,
                      ): 
                    Icon(
                      Icons.directions_walk,
                      size: 60.0,
                      color: Colors.white,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "35 min",
                          style: TextStyle(
                            fontFamily: "AurulentSans-Bold",
                            color: Colors.white
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
    //widget.gii = Provider.of<GetInnerIconsInfo>(context);

    return ValueListenableBuilder(
      valueListenable: widget.dataLegs.ic.listOfTransport,
      builder: (BuildContext context, dynamic value, Widget child){

        //gii.infoInner.tile.value[index]
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          separatorBuilder: (_,__) => Divider(height: 10.0, color: Colors.transparent,),
          shrinkWrap: true,
          itemCount: widget.dataLegs.ic.listOfTransport.value.length,
          itemBuilder: (BuildContext context, int index) {
            if(index == 0 && widget.dataLegs.ic.listOfTransport.value[index]){
              return cardButton(index, widget.dataLegs.ic.listOfTransport.value[index], widget.subway);
            } 
            else{
              if(index == 1 && widget.dataLegs.ic.listOfTransport.value[index]){
                return cardButton(index, widget.dataLegs.ic.listOfTransport.value[index], widget.bus);
              } 
              else{
                if(index == 2 && widget.dataLegs.ic.listOfTransport.value[index]){
                  return cardButton(index, widget.dataLegs.ic.listOfTransport.value[index], widget.bike);
                } 
                else{
                  if(index == 3 && widget.dataLegs.ic.listOfTransport.value[index]){
                    return cardButton(index, widget.dataLegs.ic.listOfTransport.value[index], widget.walk);
                  }
                  else{
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.transparent,
                      ),
                    );
                  }
                }
              }
            }
          },
        );
      });
  }
}
