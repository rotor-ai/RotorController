import 'package:flutter/material.dart';

class Notice extends StatelessWidget {
  final String title;
  final Color color;

  Notice({Key key, this.title, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Padding(
                child: Text(
                  title,
                  textScaleFactor: 1.25,
                ),
                padding: EdgeInsets.only(top: 4, bottom: 4))),
        color: color);
  }
}
