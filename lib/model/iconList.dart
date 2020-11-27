import 'package:flutter/material.dart';

class IconList{
  String timeArrived, timeDuration;
  List<LegsList> legs;

  IconList({
    this.timeArrived,
    this.timeDuration,
    this.legs,
  });
}

class LegsList{
  String subway, bus, bike, walk, route, routeColor, routeTextColor;

  LegsList({
    this.subway, 
    this.bus, 
    this.bike, 
    this.walk,
    this.route,
    this.routeColor,
    this.routeTextColor,
  });
}

class LegsInfo{
  String mode;
  String route;
  String routeColor;
  String routeTextColor;
  double lonOrig, latOrig, lonDest, latDest; //List<double> lonOrig, latOrig, lonDest, latDest;

  LegsInfo({
    this.mode,
    this.lonOrig, 
    this.latOrig, 
    this.lonDest, 
    this.latDest,
    this.route,
    this.routeColor,
    this.routeTextColor,
  });
}

class CardInfoRoutes {
  String hourStart;
  Widget iconTransportMedium;
  String hourEnds;
  String nameTrasportMedium;
  String placeStartIn;
  String placeEndsIn;
  Widget infoOfDistance;
  String time;
  CardInfoRoutes({
    this.hourStart,
    this.iconTransportMedium,
    this.hourEnds,
    this.nameTrasportMedium,
    this.placeStartIn,
    this.placeEndsIn,
    this.infoOfDistance,
    this.time,
  });
}

class InfoRouteServ {
  int duration;
  int startTime;
  int endTime;
  int walkTime;
  int waitingTime;
  double walkDistance;
  List<LegsInfo> legs;
  // List<double> latOrigin;
  // List<double> lonOrigin;
  // List<double> latDestiny;
  // List<double> lonDestiny;

  InfoRouteServ({
    this.duration,
    this.startTime,
    this.endTime,
    this.walkTime,
    this.waitingTime,
    this.walkDistance,
    this.legs,
  });
}