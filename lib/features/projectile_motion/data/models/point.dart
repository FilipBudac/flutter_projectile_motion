class Point {
  double x;
  double y;
  double z;

  Point(x, y, z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  Point.empty() {
    this.x = 0.0;
    this.y = 0.0;
    this.z = 0.0;
  }

  factory Point.fromJson(Map<String, dynamic> json) => Point(
    json["x"],
    json["y"],
    0.0
  );

  @override
  String toString() {
    return 'Point{x: $x, y: $y, z: $z}';
  }
}