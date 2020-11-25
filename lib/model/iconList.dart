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