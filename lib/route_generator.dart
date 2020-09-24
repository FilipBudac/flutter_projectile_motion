import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtmp_assignment/welcome_page.dart';
import 'features/projectile_motion/data/repositories/projecttile_motion_repository.dart';
import 'features/projectile_motion/presentation/bloc/projectile_motion_bloc.dart';
import 'features/projectile_motion/presentation/pages/server_projectile_motion_page.dart';


class RouteGenerator {
  static const ROOT_ROUTE = "/";
  static const HOME_PART1 = "/part1";
  static const HOME_PART2 = "/part2";

  static Route<dynamic> generateRoute (RouteSettings settings) {
    switch (settings.name) {
      case ROOT_ROUTE:
        return MaterialPageRoute(builder: (_) => WelcomePage());

      case HOME_PART1:
        EventType eventType = settings.arguments;
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(
                create: (context) => ProjectileMotionBloc(ProjectileMotionRepository()),
                child: ServerProjectileMotionPage(eventType: eventType),
              ),
        );

      case HOME_PART2:
        EventType eventType = settings.arguments;

        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(
                create: (context) => ProjectileMotionBloc(ProjectileMotionRepository()),
                child: ServerProjectileMotionPage(eventType: eventType),
              ),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: Text("Error!"),
        ),
        body: Center(
          child: Text("Routing error has occured."),
        ),
      );
    });
  }
}

