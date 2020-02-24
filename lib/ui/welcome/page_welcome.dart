import 'package:flutter/material.dart';
import 'package:mobileclient/ui/welcome/subpage_welcome.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SubpageWelcome(),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildHyperLinkButton("View on GitHub", "https://github.com/rotor-ai/RotorController")])
        );
  }

  Widget _buildHyperLinkButton(String text, String url) {
    return FlatButton(child: Text(text, style: TextStyle(color: Colors.blue)), onPressed: () {launch(url);});
  }
}
