import 'package:mtmp_assignment/features/projectile_motion/data/models/point.dart';
import 'package:equatable/equatable.dart';

abstract class ProjectileMotionState extends Equatable {
  const ProjectileMotionState();
}


class InitialState extends ProjectileMotionState {
  const InitialState();

  @override
  List<Object> get props => [];
}

class MotionUpdate extends ProjectileMotionState {
  final Point point;

  const MotionUpdate({this.point});

  @override
  List<Object> get props => [this.point];
}

class MotionLoading extends ProjectileMotionState {
  const MotionLoading();

  @override
  List<Object> get props => [];
}

class Error extends ProjectileMotionState {
  final String message;
  const Error({this.message});

  @override
  List<Object> get props => [this.message];
}