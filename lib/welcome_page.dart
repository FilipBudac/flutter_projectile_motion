import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mtmp_assignment/route_generator.dart';

enum EventType {
  SERVER,
  CLIENT
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: Text("Welcome!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 50.0),)),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 60,
                        child: RaisedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("ENTER - CLIENT", style: TextStyle(fontSize: 16)),
                              SizedBox(width: 5,),
                              Icon(Icons.forward, size: 18,)
                            ],
                          ),
                          color: Colors.white,
                          textColor: Colors.black,
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                          onPressed: () {
                            Navigator.of(context).pushNamed(RouteGenerator.HOME_PART1, arguments: EventType.CLIENT);
                          },
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        height: 60,
                        child: RaisedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("ENTER - SEVER", style: TextStyle(fontSize: 16)),
                              SizedBox(width: 5,),
                              Icon(Icons.forward, size: 18,)
                            ],
                          ),
                          color: Colors.white,
                          textColor: Colors.black,
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                          onPressed: () {
                            Navigator.of(context).pushNamed(RouteGenerator.HOME_PART2, arguments: EventType.SERVER);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
  
}