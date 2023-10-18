class Point {
  final String longitude;
  final String latitude;

  const Point({
    required this.longitude,
    required this.latitude,
  });

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}

class Route {
  final Point start;
  final Point end;
  final List<Point> waypoints;

  const Route({
    required this.start,
    required this.end,
    this.waypoints = const [],
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      start: Point.fromJson(json['start']),
      end: Point.fromJson(json['end']),
      waypoints: (json['waypoints'] as List).map((i) => Point.fromJson(i)).toList(),
    );
  }
}
