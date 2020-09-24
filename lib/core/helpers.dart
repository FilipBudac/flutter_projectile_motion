extension MapExtensions<T> on Map<String, T> {
  T pop(String key) => this[key];
}

const PI_CONST = 3.14;
double degreesToRadians(degrees) {
  return degrees * PI_CONST / 180;
}