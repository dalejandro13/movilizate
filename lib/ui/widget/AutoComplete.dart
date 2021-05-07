import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:here_sdk/core.dart';
//import 'package:here_sdk/mapview.dart';
import 'package:movilizate/RoutingExample.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/repository/ConsultServer.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:ext_storage/ext_storage.dart';

// https://geocoder.ls.hereapi.com/search/6.2/geocode.json
// ?languages=en-US
// &maxresults=4
// &searchtext=Sunnyvale
// &apiKey={YOUR_API_KEY}

//https://geocode.search.hereapi.com/v1/geocode?limit=50&qq=country=colombia;state=antioquia;city=medellin&apiKey=UXMqWoRbB7fHSTkIRgcP9l7BgUSgUEDNx6D5ggQnP9w

class AutoComplete extends StatelessWidget {

  BuildContext context;
  List<DataOfPlace> place = [];

  AutoComplete(context){
    this.context = context;
  }

  TextEditingController controller = TextEditingController(); 
  AutoCompleteTextField searchTextField;
  //String urlBase = "https://geocode.search.hereapi.com/v1/geocode?languages=es&limit=50&qq=";
  //String urlUbication = "country=colombia;city=";
  //String apiKey = "&apiKey=UXMqWoRbB7fHSTkIRgcP9l7BgUSgUEDNx6D5ggQnP9w";
  RoutingExample routing = null;
  GlobalKey<AutoCompleteTextFieldState<DataOfPlace>> key = GlobalKey();
  ConsultServer consult = ConsultServer();
  // List<DataOfPlace> place = null;
  //bool enter = true;
  //_AutoCompleteState();



  @override
  Widget build(BuildContext context) {
    var info = Provider.of<ProcessData>(context);
    var info2 = Provider.of<DataOfPlace>(context);
    //routing = RoutingExample(context, info.mapController);
    return searchTextField = AutoCompleteTextField<DataOfPlace>(
      key: key,
      clearOnSubmit: false,
      suggestions: consult.place,
      decoration: InputDecoration(
        hintText: "¿A dónde quieres ir?",
        hintStyle: TextStyle(fontFamily: "AvenirLT-Light"),
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(left: 15.8, top: 15.5, right: 10.8),
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
          iconSize: 20.0
        ),
      ),
      
      itemBuilder: (context, item){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              item.title,
              style: TextStyle(
                fontSize: 16.0
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
            ),
            // Text(
            //   item.lat.toString(),
            // ),
          ],
        );
      },
      
      textChanged: (val) async {
        if(val.length >= 3){
          info.dataText.text = val;
          await consult.getInfoInSearch(info, info2, place);
        }
        if(val.length >= 0 && val.length <= 2 ){
          consult.place = null;
          consult.place = [];
        }
      },

      itemFilter: (item, query){
        return item.title.toLowerCase().startsWith(query.toLowerCase());
      },
      itemSorter: (a, b){
        return a.title.compareTo(b.title);
      },
      itemSubmitted: (item){
        //setState((){
          info.dataText.text = item.title;
          searchTextField.textField.controller.text = item.title;
        //});
      }, 
    );
  }
}



// class AutoComplete extends StatefulWidget {

//   BuildContext context;

//   AutoComplete(context){
//     this.context = context;
//   }

//   @override
//   _AutoCompleteState createState() => _AutoCompleteState();
// }

// class _AutoCompleteState extends State<AutoComplete> {
//   TextEditingController controller = TextEditingController(); 
//   AutoCompleteTextField searchTextField;
//   //String urlBase = "https://geocode.search.hereapi.com/v1/geocode?languages=es&limit=50&qq=";
//   //String urlUbication = "country=colombia;city=";
//   //String apiKey = "&apiKey=UXMqWoRbB7fHSTkIRgcP9l7BgUSgUEDNx6D5ggQnP9w";
//   RoutingExample routing = null;
//   GlobalKey<AutoCompleteTextFieldState<DataOfPlace>> key = GlobalKey();
//   ConsultServer consult = ConsultServer();
//   // List<DataOfPlace> place = null;
//   //bool enter = true;
//   _AutoCompleteState();

//   @override
//   void initState() { 
//     super.initState();
//     //consult = ConsultServer(widget.context);
//     consult.place = null;
//     consult.place = [];
//     consult.getPreviousInfo();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var info = Provider.of<ProcessData>(context);
//     var info2 = Provider.of<DataOfPlace>(context);
//     routing = RoutingExample(context, info.mapController);
//     return searchTextField = AutoCompleteTextField<DataOfPlace>(
//       key: key,
//       clearOnSubmit: false,
//       suggestions: consult.place,
//       decoration: InputDecoration(
//         hintText: "¿A dónde quieres ir?",
//         hintStyle: TextStyle(fontFamily: "AvenirLT-Light"),
//         border: InputBorder.none,
//         contentPadding: EdgeInsets.only(left: 15.8, top: 15.5, right: 10.8),
//         suffixIcon: IconButton(
//           icon: Icon(Icons.search),
//           onPressed: () {},
//           iconSize: 20.0
//         ),
//       ),
      
//       itemBuilder: (context, item){
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Text(
//               item.title,
//               style: TextStyle(
//                 fontSize: 16.0
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(15.0),
//             ),
//             // Text(
//             //   item.lat.toString(),
//             // ),
//           ],
//         );
//       },
//       //controller: searchTextField,
//       //textInputAction: TextInputAction.go,
//       // textSubmitted: (value) async {
//       //   await getInfoInMaps(info);
//       // },
      
//       textChanged: (val) async {
//         if(val.length >= 3){
//           info.dataText.text = val;
//           await consult.getInfoInMaps(info, info2);
//         }
//         if(val.length >= 0 && val.length <= 2 ){
//           consult.place = null;
//           consult.place = [];
//         }
//       },

//       itemFilter: (item, query){
//         return item.title.toLowerCase().startsWith(query.toLowerCase());
//       },
//       itemSorter: (a, b){
//         return a.title.compareTo(b.title);
//       },
//       itemSubmitted: (item){
//         setState((){
//           info.dataText.text = item.title;
//           searchTextField.textField.controller.text = item.title;
//         });
//       }, 
//     );
//   }
// }