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
  String cableCar, subway, bus, bike, walk, route, routeColor, routeTextColor;

  LegsList({
    this.cableCar,
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
  int startTime;
  int endTime;
  String mode;
  String route;
  String routeColor;
  String routeId;
  String routeTextColor;
  double lonOrig, latOrig, lonDest, latDest, distance; //List<double> lonOrig, latOrig, lonDest, latDest;
  String nameFrom, nameTo, tripId, stopIdFrom, stopIdTo;
  double durationTransport;
  List<double> ltWalk, lgWalk;

  LegsInfo({
    this.distance,
    this.startTime,
    this.endTime,
    this.mode,
    this.lonOrig, 
    this.latOrig,
    this.nameFrom,
    this.lonDest, 
    this.latDest,
    this.nameTo,
    this.route,
    this.routeColor,
    this.routeId,
    this.routeTextColor,
    this.durationTransport,
    this.tripId,
    this.stopIdFrom,
    this.stopIdTo,
    this.ltWalk,
    this.lgWalk,
  });
}

class CardInfoRoutes {
  String hourStart;
  Widget iconTransportMedium;
  String hourEnds;
  Widget startIcon;
  Widget currentIcon;
  Container lineRoute;
  Widget endIcon;
  String nameTrasportMedium;
  String placeStartIn;
  String placeEndsIn;
  Widget infoOfDistance;
  String time;
  CardInfoRoutes({
    this.hourStart,
    this.iconTransportMedium,
    this.hourEnds,
    this.startIcon,
    this.currentIcon,
    this.lineRoute,
    this.endIcon,
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

class CoordInfo{
  int secuence, distance;
  double latitude, longitude;
  CoordInfo({
    this.secuence,
    this.distance,
    this.latitude,
    this.longitude,
  });
}