import 'package:flutter/material.dart';
import 'package:movilizate/model/iconList.dart';
import 'package:movilizate/ui/screen/ScreenRoutesInfo.dart';

class CardInfoRoute extends StatelessWidget {

  int index;
  IconList icon; 
  BuildContext context; 
  bool enable;

  CardInfoRoute(int index, IconList icon, BuildContext context, bool enable){
    this.index = index;
    this.icon = icon;
    this.enable = enable;
  }

  Color hexColor(String hexString){
    var buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7){
      buffer.write('ff');
    } 
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  List<Widget> getIcon(IconList icon){
    List<Widget> tile = null;
    tile = [];
    double sizeIcon = 35.0;

    for(int j = 0; j < icon.legs.length; j++){
      if(icon.legs[j].subway == "SUBWAY"){
        tile.add(
          Icon(
            Icons.directions_subway,
            size: sizeIcon,
            color: Colors.black,
          )
        );
        if(icon.legs[j].routeColor != null && icon.legs[j].routeTextColor != null){
          tile.add(
            Container(
              height: 27.0,
              width: 27.0,
              decoration: BoxDecoration(
                color: hexColor(icon.legs[j].routeColor),
              ),
              child: Center(
                child: Text(
                  icon.legs[j].route,
                  style: TextStyle(
                    fontFamily: "AurulentSans-Bold",
                    color: hexColor(icon.legs[j].routeTextColor),
                  ),
                ),
              ),
            ),
          );
        }
        tile.add(
          Icon(
            Icons.chevron_right,
            size: sizeIcon,
            color: Color.fromRGBO(105, 190, 50, 1.0),
          )
        );
      }
      else{
        if(icon.legs[j].bus == "BUS"){
          if(icon.legs[j].routeColor != null && icon.legs[j].routeTextColor != null){
            tile.add(
              Icon(
                Icons.directions_bus,
                size: sizeIcon,
                color: Colors.black,
              ),
            );
            tile.add(
              Container(
                height: 27.0,
                width: 27.0,
                decoration: BoxDecoration(
                  color: hexColor(icon.legs[j].routeColor),
                ),
                child: Center(
                  child: Text(
                    icon.legs[j].route,
                    style: TextStyle(
                      fontFamily: "AurulentSans-Bold",
                      color: hexColor(icon.legs[j].routeTextColor),
                    ),
                  ),
                ),
              ),
            );
          }
          tile.add(
            Icon(
              Icons.chevron_right,
              size: sizeIcon,
              color: Color.fromRGBO(105, 190, 50, 1.0),
            )
          );
        }
        else{
          if(icon.legs[j].bike == "BIKE"){
            tile.add(
              Icon(
                Icons.directions_bike,
                size: sizeIcon,
                color: Colors.black,
              )
            );
            tile.add(
              Icon(
                Icons.chevron_right,
                size: sizeIcon,
                color: Color.fromRGBO(105, 190, 50, 1.0),
              )
            );
          }
          else{
            if(icon.legs[j].walk == "WALK"){
              tile.add(
                Icon(
                  Icons.directions_walk,
                  size: sizeIcon,
                  color: Colors.black,
                ),
              );
              tile.add(
                Icon(
                  Icons.chevron_right,
                  size: sizeIcon,
                  color: Color.fromRGBO(105, 190, 50, 1.0),
                )
              );
            }
          }
        }
      }
    }
    tile.removeLast();
    return tile;

    // return ListTile(
    //   title: tile,
    //   onTap: null,
    // );
  }


  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Padding(
        padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: Container(
          height: 140.0,
          width: 70.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      icon.timeArrived,
                      style: TextStyle(
                        fontFamily: "AurulentSans-Bold",
                        color: Color.fromRGBO(105, 190, 50, 1.0),
                        fontSize: 20.0,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      "Duration",
                      style: TextStyle(
                        fontFamily: "AurulentSans-Bold",
                        color: Color.fromRGBO(105, 190, 50, 1.0),
                        fontSize: 20.0,
                      ),
                    ),
                  ),

                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                    child: Container(
                      height: 50.0,
                      width: 160.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index){
                          return Row(
                            children: [
                              getIcon(icon)[index],
                            ],
                          );
                        }
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(right: 8.0, bottom: 10.0),
                    child: Row(
                      children: [
                        Text(
                          icon.timeDuration, 
                          style: TextStyle(
                            fontFamily: "AurulentSans-Bold",
                            color: Color.fromRGBO(105, 190, 50, 1.0),
                            fontSize: 35.0,
                          ),
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(""),

                            Text(
                              "min",
                              style: TextStyle(
                                fontFamily: "AurulentSans-Bold",
                                color: Color.fromRGBO(105, 190, 50, 1.0),
                              ),
                            )
                          ],
                        )

                      ],
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
      onTap: enable ? (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenMap(index, context)));
      }:
      (){
        
      },
    );
  }
}