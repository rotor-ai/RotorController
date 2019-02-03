import 'package:flutter/material.dart';

class Notice extends StatelessWidget {
  String _title = "";
  Color _color;

  Notice(this._title, this._color);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Padding(
                child: Text(
                  _title,
                  textScaleFactor: 1.25,
                ),
                padding: EdgeInsets.only(top: 4, bottom: 4))),
        color: _color);
  }
}
