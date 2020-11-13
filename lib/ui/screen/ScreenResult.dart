import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/repository/ConsultServer.dart';
import 'package:movilizate/ui/widget/AutoCompleteDestiny2.dart';
import 'package:movilizate/ui/widget/AutoCompleteOrigin2.dart';
import 'package:movilizate/ui/widget/ModesOfTransport.dart';
import 'package:movilizate/ui/widget/DurationList.dart';
import 'package:provider/provider.dart';

class ScreenResult extends StatefulWidget {

  ConsultServer consult;

  ScreenResult(ConsultServer consult){
    this.consult = consult;
  }

  @override
  _ScreenResultState createState() => _ScreenResultState();
}

class _ScreenResultState extends State<ScreenResult> {

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return Future(() => false);
      },
      child: Scaffold(
        body: GestureDetector(
          onTap:(){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: [
              //Text(info2.title), //pendiente de borrar
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Color.fromRGBO(105, 190, 50, 1.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top:40.0),
                    ),
                    
                    Expanded(
                    flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 30.0),
                          ),
                          Expanded(
                            flex: 8,
                            child: AutoCompleteOrigin2(widget.consult),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30.0),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top:5.0),
                    ),

                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 30.0),
                          ),
                          Expanded(
                            flex: 8,
                            child: AutoCompleteDestiny2(widget.consult),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30.0),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: ModesOfTransport(),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 7.0),
                    ),

                    Expanded(
                      flex: 7,
                      child: DurationList(),
                    ),

                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}