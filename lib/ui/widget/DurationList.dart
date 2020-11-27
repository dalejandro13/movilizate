import 'package:flutter/material.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/model/iconList.dart';
import 'package:movilizate/ui/screen/ScreenRoutesInfo.dart';
import 'package:movilizate/ui/widget/ListOfLegs.dart';
import 'package:provider/provider.dart';



class DurationList extends StatefulWidget {

  GetDataOfRoutes routes;

  DurationList(BuildContext context){
    routes = GetDataOfRoutes(context);
  }

  @override
  _DurationListState createState() => _DurationListState();
}

class _DurationListState extends State<DurationList> {

  double sizeIcon = 35.0;

  @override
  Widget build(BuildContext context) {
    //final routes = Provider.of<GetDataOfRoutes>(context); //GetDataOfRoutes(context);
    return ValueListenableBuilder(
      valueListenable: widget.routes.infoCard.listOfInfo, //widget.dataLegs.ic.listOfTransport,
      builder: (BuildContext context, dynamic value, Widget child){
        return ListView.separated(
          separatorBuilder: (_,__) => Divider(height: 10.0, color: Colors.transparent,),
          itemCount: widget.routes.infoCard.listOfInfo.value.length, //widget.dataLegs.ic.listOfTransport.value.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 170.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: CardInfoRoute(index, /*widget.routes.infoCard.listOfInfo.value[index],*/ context, true), //cardInfoRoute(index, widget.routes.infoCard.listOfInfo.value[index], context, true),
            );
          }
        );
      }
    );
  }
}