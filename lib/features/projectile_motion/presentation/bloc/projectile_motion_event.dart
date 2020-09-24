import 'package:equatable/equatable.dart';

abstract class ProjectileMotionEvent extends Equatable {
  const ProjectileMotionEvent();
}

class StartMotion extends ProjectileMotionEvent {
  final double velocity;
  final double angle;

  const StartMotion({this.velocity, this.angle});

  @override
  List<Object> get props => [velocity, angle];
}

class UpdateMotion extends ProjectileMotionEvent {
  final double velocity;
  final double angle;
  final double time;

  const UpdateMotion({this.velocity, this.angle, this.time});

  @override
  List<Object> get props => [velocity, angle, time];
}

class RefreshMotion extends ProjectileMotionEvent {

  const RefreshMotion();

  @override
  List<Object> get props => [];
}