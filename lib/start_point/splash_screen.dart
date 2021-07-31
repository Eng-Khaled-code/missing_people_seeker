import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: width,
                height: height,
                child: Container(),
              ),
              Container(
                height: height,
                width: width,
                child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/images/splach_bg.png',
                      fit: BoxFit.fill,
                    )),
              ),
              Shimmer.fromColors(
                period: Duration(milliseconds: 1000),
                baseColor: Colors.blue,
                highlightColor: Colors.pink,
                child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "الباحث عن الاشخاص المفقودين",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: width * .08,
                          fontWeight: FontWeight.bold,
                          shadows: <Shadow>[
                            Shadow(
                                blurRadius: 18.0,
                                color: Colors.black87,
                                offset: Offset.fromDirection(120, 12))
                          ]),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
