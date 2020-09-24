import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mtmp_assignment/core/helpers.dart';
import 'package:mtmp_assignment/features/projectile_motion/data/models/graph_data.dart';
import 'package:mtmp_assignment/features/projectile_motion/data/models/point.dart';
import 'dart:async';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtmp_assignment/features/projectile_motion/presentation/bloc/projectile_motion_bloc.dart';
import 'package:mtmp_assignment/features/projectile_motion/presentation/bloc/projectile_motion_event.dart';
import 'package:mtmp_assignment/features/projectile_motion/presentation/bloc/projectile_motion_state.dart';
import 'package:mtmp_assignment/welcome_page.dart';


class ServerProjectileMotionPage extends StatefulWidget {
  final EventType eventType;

  const ServerProjectileMotionPage({Key key, this.eventType}) : super(key: key);

  @override
  _ServerProjectileMotionPageState createState() => _ServerProjectileMotionPageState();
}

class _ServerProjectileMotionPageState extends State<ServerProjectileMotionPage> {
  static const double GRAVITATIONAL_CONS = 9.8;

  List<Point> _points;
  double _velocity;
  double _angle;
  double _time;
  Point _point;
  Timer _timer;
  double _distance;
  List<GraphData> _graphData;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    _points = List<Point>();
    _angle = 0;
    _velocity = 0;
    _point = Point.empty();
    _graphData = List<GraphData>();
    _distance = 0;

    print(widget.eventType);
  }

  void _onStartServer() {
    _distance = pow(_velocity, 2) / GRAVITATIONAL_CONS * sin(degreesToRadians(2 * _angle));

    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if(_points.isEmpty) {
        _points.add(Point.empty());
      }

      BlocProvider.of<ProjectileMotionBloc>(context).add(UpdateMotion(angle: _angle, velocity: _velocity, time: timer.tick / 10));
    });
  }


  void _onStartClient() {
    _distance = pow(_velocity, 2) / GRAVITATIONAL_CONS * sin(degreesToRadians(2 * _angle));
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if(_points.isEmpty) {
        _points.add(Point.empty());
      }

      double time = timer.tick / 10;
      double x = _velocity * time * cos(degreesToRadians(_angle));
      double y = _velocity * time * sin(degreesToRadians(_angle)) - ((GRAVITATIONAL_CONS * 0.5) * pow(time, 2));

      setState(() {
        _point.y = -y;
        _point.x = x;
      });

      if (_point.x >= _distance) {
        setState(() {
          _point.y = 0;
        });
        _timer.cancel();
      } else {
        _points.add(Point(x, y, 0.0));
        _graphData.add(GraphData(time: time, axisY: y));
      }

    });
  }

  void _onRefresh() {
    BlocProvider.of<ProjectileMotionBloc>(context).add(RefreshMotion());
  }

  List<dynamic> _getGraphData() {
    List<charts.Series<GraphData, int>> series = [
      charts.Series(
        id: "Projectile Motion",
        data: _graphData,
        domainFn: (GraphData series, _) => int.parse(series.time.toStringAsFixed(0)),
        measureFn: (GraphData series, _) => widget.eventType == EventType.SERVER ? -series.axisY: series.axisY,
      )
    ];
    return series;
  }

  List<dynamic> _getTrajectoryData() {
    List<charts.Series<Point, int>> series = [
      charts.Series(
        id: "Projectile Motion",
        data: _points,
        domainFn: (Point series, _) => int.parse(series.x.toStringAsFixed(0)),
        measureFn: (Point series, _) => series.y,
      )
    ];
    return series;
  }

  Future<void> _onGraphDisplay() async {
    await _displayGraph(context, _getGraphData, "Graph");
  }

  Future<void> _onTrajectoryDisplay() async {
    await _displayGraph(context, _getTrajectoryData, "Projectile trajectory");
  }

  Future<void> _displayGraph(BuildContext context, Function dataSeries, String title) {
    return showDialog<void>(
        context: context,
        builder: (_) => new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Builder(
            builder: (context) {
              double height = MediaQuery.of(context).size.height;
              double width = MediaQuery.of(context).size.width;

              return Container(
                height: height - 150,
                width: width - 150,
                child: Column(children: [
                  Text(title),
                  Expanded(child: charts.LineChart(dataSeries(), animate: true,)),
                  SizedBox(height: 25),
                ]),
              );
            },
          ),
          actions: <Widget>[
            RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.close, color: Colors.red, size: 20),
                    Text("CLOSE", style: TextStyle(color: Colors.red)),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _blocListener(),
      backgroundColor: Colors.white,
    );
  }

  BlocListener _blocListener() {
    return BlocListener<ProjectileMotionBloc, ProjectileMotionState>(
        listener: (context, state) async {
          if (state is InitialState) {
            _points = List<Point>();
            _graphData = List<GraphData>();
            _distance = 0;
            _point = Point.empty();
            _time = 0;
          } else if (state is MotionUpdate) {
            _point = state.point;

            if (_point.x >= _distance) {
              setState(() {
                _point.y = 0;
              });
              _timer.cancel();
            } else {
              _graphData.add(GraphData(time: _time, axisY: state.point.y));
              _points.add(Point(state.point.x, -state.point.y, 0.0));
            }
          } else if (state is Error) {
            Scaffold.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      state.message,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Ubuntu'
                      ),
                  ),
                )
            );
            _timer.cancel();
          }
        },
        child: _blocBuilder());
  }

  BlocBuilder _blocBuilder() {
    return BlocBuilder<ProjectileMotionBloc, ProjectileMotionState>(
      builder: (context, state) {
        if (state is InitialState) {
          return _defaultSetUp();
        } else if (state is MotionUpdate) {
          return _defaultSetUp();
        } else if (state is Error) {
          return _defaultSetUp();
        }
        return _defaultSetUp();
      },
    );
  }

  Widget _startButton() {
    Function startFunction = _onStartClient;

    if (widget.eventType == EventType.SERVER) {
      startFunction = _onStartServer;
    }

    return RaisedButton(
      color: Colors.red,
      textColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: widget.eventType == EventType.CLIENT ? Text("Shoot".toUpperCase()) : Text("Shoot [SEVER]".toUpperCase()),
      onPressed: startFunction,
    );
  }
  Widget _defaultSetUp() {
    _time = _timer != null ? _timer.tick / 10 : 0;

    double pointY = _point.y;
    if (_point.y != 0) {
      pointY = _point.y * (-1);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          flex: 5,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Text("Angle: ${_angle.toStringAsFixed(0)}°"),
                        SizedBox(width: 37.0,),
                        Slider(
                          activeColor: Colors.red,
                          inactiveColor: Colors.red.shade100,
                          value: _angle,
                          min: 0,
                          max: 90,
                          divisions: 90,
                          label: _angle.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _angle = value;
                            });
                          },
                        ),
                        Text("X: ${_point.x.toStringAsFixed(2)}  Y: ${pointY.toStringAsFixed(2)}"),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text("Velocity: ${_velocity.toStringAsFixed(0)} m/s"),
                      Slider(
                        activeColor: Colors.red,
                        inactiveColor: Colors.red.shade100,
                        value: _velocity,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: _velocity.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _velocity = value;
                          });
                        },
                      ),
                      Text("Time: ${_time.toStringAsFixed(0)} s")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _startButton(),
                      SizedBox(width: 5,),
                      Container(
                        width: 60,
                        child: RaisedButton(
                            textColor: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            color: Colors.red,
                            child: Icon(Icons.timeline),
                            onPressed: _onGraphDisplay
                        ),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: 60,
                        child: RaisedButton(
                            textColor: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            color: Colors.red,
                            child: Icon(Icons.assessment),
                            onPressed: _onTrajectoryDisplay
                        ),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: 60,
                        child: RaisedButton(
                            textColor: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            color: Colors.red,
                            child: Icon(Icons.replay),
                            onPressed: _onRefresh
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 6,
          child: Stack(
            children: [
              AnimatedContainer(
                transform: Matrix4.translationValues(_point.x, _point.y, _point.z),
                alignment: Alignment(-1, 1),
                duration: Duration(milliseconds: 0),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: new BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}