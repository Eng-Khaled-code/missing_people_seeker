import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body:Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: height,
                width: width,
                child: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      'assets/images/splach_bg.png',
                      fit: BoxFit.fill,
                    )),
              ),
              Shimmer.fromColors(
                period: Duration(milliseconds: 1000),
                baseColor: Colors.blue,
                highlightColor: Color(0xffe100ff),
                child:  Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.pink)),
                        SizedBox(height: 15),
                        Text(
                          "انتظر لحظه...",
                          style: TextStyle(
                              color: Colors.black, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
