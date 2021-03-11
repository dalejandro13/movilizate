import 'package:flutter/material.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/ui/widget/ListOfLegs.dart';
import 'package:provider/provider.dart';

class DurationList extends StatefulWidget {
  @override
  _DurationListState createState() => _DurationListState();
}

class _DurationListState extends State<DurationList> {
  
  double sizeIcon = 35.0;

  @override
  Widget build(BuildContext context) {

    var info3 = Provider.of<InfoRouteServer>(context);
    var info = Provider.of<ProcessData>(context);
    
    return ListView.separated(
      separatorBuilder: (_, __) => Divider(height: 10.0, color: Colors.transparent),
      itemCount: !info3.filterActive ? info3.listOfInfo.length : info3.listOfInfoAux.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 170.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: CardInfoRoute(index, context, true),
        );
      },
    );
  }
}
