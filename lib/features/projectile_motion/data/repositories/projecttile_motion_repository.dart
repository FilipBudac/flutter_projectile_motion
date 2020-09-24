import 'package:mtmp_assignment/features/projectile_motion/data/services/projectile_motion_service.dart';
import 'package:mtmp_assignment/features/projectile_motion/data/models/point.dart';

abstract class Repository {
  Future<Point> updateMotion(double velocity, double angle, double time);
}

class ProjectileMotionRepository extends Repository {

  @override
  Future<Point> updateMotion(double velocity, double angle, double time) async {
    Point point = await Service.instance.updateMotion(velocity, angle, time);

    return point;
  }

}