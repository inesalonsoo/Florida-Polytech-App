// lib/pages/about_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  final Uri url = Uri.parse(
      'https://my.togetherplatform.com/login?organizationId=n8jcSc7guDBdI5QvBMq3&isRegistration=true&programId=tlY2lvv63lgEzCokaMQg');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Florida Poly'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: ListTile(
            leading: Icon(Icons.info, color: Colors.purple),
            title: Text('Visit Florida Poly About Page'),
            onTap: () async {
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
        ),
      ),
    );
  }
}
