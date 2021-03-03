import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/repository/ConsultServer.dart';
import 'package:movilizate/ui/screen/ScreenSearch.dart';
import 'package:provider/provider.dart';

void main() {
  //
  //int index = 0;
  SdkContext.init(IsolateOrigin.main);
  // Making sure that BuildContext has MaterialLocalizations widget in the widget tree,
  // which is part of MaterialApp.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProcessData()),
        ChangeNotifierProvider(create: (_) => DataOfPlace()),
        ChangeNotifierProvider(create: (_) => InfoRouteServer()),
        ChangeNotifierProvider(create: (BuildContext context) => InnerIconsInfo(context)),
        //ChangeNotifierProvider(create: (BuildContext context) => GetIconInList(context)),
      ],
      child: MaterialApp(
        title: "Movilizate",
        initialRoute: "home",
        debugShowCheckedModeBanner: false,
        routes: {
          "home": (context) => ScreenSearch(context), //ScreenMap(), //ScreenResult(), //ScreenSearch(), //MyApp(),
        },
      ),
    )
  );
}

// class MyApp extends StatelessWidget {
//   ProcessData info;

//   @override
//   Widget build(BuildContext context) {
//     //_context = context;
//     //info = Provider.of<ProcessData>(context);
//     return Scaffold(
//       body: Stack(
//         children: [
//           HereMap(
//             onMapCreated: onMapCreated,
//           ),
//           Positioned(
//             top: 70.0,
//             right: 15.0,
//             left: 15.0,
//             child: Container(
//               height: 50.0,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 color: Colors.white,
//               ),
//               child: AutoComplete(context),

//               // child: TextField(
//               //   decoration: InputDecoration(
//               //     hintText: "¿A dónde quieres ir?",
//               //     hintStyle: TextStyle(fontFamily: "AvenirLT-Light"),
//               //     border: InputBorder.none,
//               //     contentPadding:
//               //         EdgeInsets.only(left: 15.8, top: 15.5, right: 10.8),
//               //     suffixIcon: IconButton(
//               //       icon: Icon(Icons.search),
//               //       onPressed: () {},
//               //       iconSize: 20.0
//               //     ),
//               //   ),
//               //   onChanged: (val) {}
//               // ),

//             ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [SettingsButton()],
//               )
//             ],
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [PlacesButton(), RoutesButton()],
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void onMapCreated(HereMapController hereMapController) {
//     info.mapController = hereMapController;
//     hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
//         (MapError error) {
//       if (error == null) {
//       } else {
//         print("Map scene not loaded. MapError: " + error.toString());
//       }
//     });
//   }

//   // A helper method to add a button on top of the HERE map.
//   Align button(String buttonLabel, Function callbackFunction) {
//     return Align(
//       alignment: Alignment.topCenter,
//       child: RaisedButton(
//         color: Colors.lightBlueAccent,
//         textColor: Colors.white,
//         onPressed: () => callbackFunction(),
//         child: Text(buttonLabel, style: TextStyle(fontSize: 20)),
//       ),
//     );
//   }
// }