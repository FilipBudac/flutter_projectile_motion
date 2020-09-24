import 'dart:io';

import 'package:mtmp_assignment/features/projectile_motion/data/models/point.dart';
import 'package:mtmp_assignment/core/failure.dart';
import 'package:mtmp_assignment/features/projectile_motion/data/repositories/projecttile_motion_repository.dart';
import 'package:mtmp_assignment/features/projectile_motion/presentation/bloc/projectile_motion_event.dart';
import 'package:mtmp_assignment/features/projectile_motion/presentation/bloc/projectile_motion_state.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';

class ProjectileMotionBloc extends Bloc<ProjectileMotionEvent, ProjectileMotionState> {

  final ProjectileMotionRepository projectileMotionRepository;

  ProjectileMotionBloc(this.projectileMotionRepository);

  @override
  ProjectileMotionState get initialState => InitialState();

  @override
  Stream<ProjectileMotionState> mapEventToState(
      ProjectileMotionEvent event,

      ) async* {
      yield MotionLoading();

      if (event is UpdateMotion) {
        try {
          Point point = await projectileMotionRepository.updateMotion(event.velocity, event.angle, event.time).timeout(Duration(seconds: 10));

          if (point == null || point.x == null || point.y == null) {
            throw PointNotFound();
          }

          yield MotionUpdate(point: point);
        } on TimeoutException {
          yield Error(message: ErrorMessage.NETWORK_ERROR);
        }on SocketException {
          yield Error(message: ErrorMessage.NETWORK_ERROR);
        } on PointNotFound {
          yield Error(message: ErrorMessage.POINT_NOT_FOUND);
        } catch (e) {
          print(e);
        }
      } else if (event is RefreshMotion) {
        yield InitialState();
      }
  }
}

