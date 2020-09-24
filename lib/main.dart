import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mtmp_assignment/route_generator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MTMP App',
      debugShowCheckedModeBanner: false,
      initialRoute: RouteGenerator.ROOT_ROUTE,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}