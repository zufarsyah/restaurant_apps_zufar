import 'package:flutter/material.dart';
import 'package:restaurant_apps/ui/main_screen.dart';

class SplashPage extends StatelessWidget {
  static const routeName = '/splash_screen';

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
    });
    return Container(
      color: Colors.blue,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.no_food_outlined,
              color: Colors.white,
              size: 90,
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 80),
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white)),
              ))
        ],
      ),
    );
  }
}
