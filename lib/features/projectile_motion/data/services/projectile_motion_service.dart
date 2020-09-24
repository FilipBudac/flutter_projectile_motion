import 'dart:convert';
import 'package:http/http.dart';

import 'package:mtmp_assignment/features/projectile_motion/data/models/point.dart';

abstract class Service {
  static final Service instance = _ProjectileMotionService();

  Future<Point> updateMotion(double velocity, double angle, double time);
}


class _ProjectileMotionService extends Service {
  static const _SUCCESS_STATUS_CODE = 200;
  static const _AUTHORITY_URL = "10.0.2.2:5000";
  static const _UPDATE_MOTION_PATH = "/update";


  @override
  Future<Point> updateMotion(double velocity, double angle, double time) async {
    try {
      Map<String, dynamic> data = {
        "velocity": velocity,
        "angle": angle,
        "time": time
      };

      final Uri uri = Uri.http(_AUTHORITY_URL, _UPDATE_MOTION_PATH, {"data": jsonEncode(data)});
      final Response response = await get(uri, headers: {"Content-Type": "application/json", "Accept": "application/json"});

      print(response.body);

      if (_SUCCESS_STATUS_CODE != response.statusCode) {
        return null;
      }

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      final Point point = Point.fromJson(responseJson);

      return point;
    } catch (e) {
      print(e);
    }

    return null;
  }

}