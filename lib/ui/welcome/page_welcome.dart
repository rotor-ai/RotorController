import 'package:flutter/material.dart';
import 'package:mobileclient/ui/about/page_about.dart';
import 'package:mobileclient/ui/devicelist/page_device_list.dart';
import 'package:mobileclient/ui/welcome/subpage_welcome.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SubpageWelcome(),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(child: Text("About"), onPressed: () => Navigator.pushNamed(context, 'About'))
          ])
        );
  }

  Widget _buildHyperLinkButton(String text, String url) {
    return FlatButton(child: Text(text, style: TextStyle(color: Colors.blue)), onPressed: () {launch(url);});
  }
}
