import 'package:flutter/material.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:provider/provider.dart';

class CardWithInfo extends StatelessWidget {

  int index;

  CardWithInfo(BuildContext context, int index){
    this.index = index;
  }
  
  @override
  Widget build(BuildContext context) {
    var info = Provider.of<ProcessData>(context);
    var info3 = Provider.of<InfoRouteServer>(context);
    return ListView.separated(
      separatorBuilder: (_,__) => Container(width: 20.0, height: 20.0,child: Divider(height: 5.0, color: Colors.grey[300])),
      itemCount: info.infoRoutList[index].length,
      itemBuilder: (BuildContext context, int inx){
        return Container(
          height: 180.0,
          child: ListTile(
          onTap: null,
          title: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                    ),
                    Text(
                      info.infoRoutList[index][inx].hourStart,
                      style: TextStyle(
                        fontFamily: "AurulentSans-Bold",
                        fontSize: 10.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    info.infoRoutList[index][inx].iconTransportMedium,
                    Text(
                      info.infoRoutList[index][inx].hourEnds,
                      style: TextStyle(
                        fontFamily: "AurulentSans-Bold",
                        fontSize: 10.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.0),
                ),

                
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    inx == 0 ?
                      info.infoRoutList[index][inx].startIcon: //icono de inicio
                      info.infoRoutList[index][inx].currentIcon, //icono corriente

                    info.infoRoutList[index][inx].lineRoute, //muestra la linea de ruta

                    info.infoRoutList[index].length - 1 == inx ? 
                      info.infoRoutList[index][inx].endIcon : //muestra el icono de punto de destino
                      Container(),
                  ],
                ),

                
                Padding(
                  padding: EdgeInsets.only(left: 5.0),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                    ),
                    Text(
                      "Starts in: ",
                      style: TextStyle(
                        color: Colors.grey[350],
                        fontFamily: "AurulentSans-Bold",
                        //fontSize: 14.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      info.infoRoutList[index][inx].nameTrasportMedium,
                      style: TextStyle(
                        fontFamily: "AurulentSans-Bold",
                        fontSize: 13.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Ends in: ",
                      style: TextStyle(
                        color: Colors.grey[350],
                        fontFamily: "AurulentSans-Bold",
                        //fontSize: 14.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                    ),
                    Tooltip(
                      message: info.infoRoutList[index][inx].placeStartIn,
                      child: Container(
                        width: 100.0,
                        child: Text(
                          info.infoRoutList[index][inx].placeStartIn, //informacion de lugar de inicio
                          style: TextStyle(
                            fontFamily: "AurulentSans-Bold",
                            fontSize: 10.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    info.infoRoutList[index][inx].infoOfDistance, //aca va el widget que muestra la informacion de las rutas
                    Tooltip(
                      message: info.infoRoutList[index][inx].placeEndsIn,
                      child: Container(
                        width: 100.0,
                        child: Text(
                          info.infoRoutList[index][inx].placeEndsIn, //informacion de lugar de llegada
                          style: TextStyle(
                            fontFamily: "AurulentSans-Bold",
                            fontSize: 10.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      info.infoRoutList[index][inx].time,
                      style: TextStyle(
                        fontFamily: "AurulentSans-Bold",
                        //fontSize: 10.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                ),
              ],
            ),
            ),
          ),
        );
      },
    );
  }
}