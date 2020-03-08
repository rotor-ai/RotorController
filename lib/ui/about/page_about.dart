import 'package:flutter/material.dart';
import 'package:mobileclient/ui/about/subpage_about.dart';

class PageAbout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About rotor.ai"),),
      body: SubpageAbout()
      );
  }

}