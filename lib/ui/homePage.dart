// @dart=2.9

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'videoScreen.dart';
import 'imageScreen.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final String appPackageName = 'com.sudoStudio.whatsapp_status_saver';

  final html =
      '<h3><b>How To Use?</b></h3><p>- Check the Desired Status/Story...</p><p>- Come Back to App, Click on any Image or Video to View...</p><p>- Click the Save Button...<br />The Image/Video is Instantly saved to your Gallery :)</p><p>- You can also Use Multiple Saving. [to do]</p>';
  openUrl(String choice) async {
    if (choice == Constants.about) {
      if (await canLaunch(
          "https://sites.google.com/view/statussaver-sudostudio/home")) {
        await launch(
            "https://sites.google.com/view/statussaver-sudostudio/home");
      } else {
        throw 'Could not launch Url, please check your connection';
      }
    } else if (choice == Constants.rate) {
      if (await canLaunch(
          "https://play.google.com/store/apps/details?id=com.sudoStudio.whatsapp_status_saver")) {
        await launch(
            "https://play.google.com/store/apps/details?id=com.sudoStudio.whatsapp_status_saver");
      } else {
        throw 'Could not launch Url, please check your connection';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Status Saver'),
          backgroundColor: Colors.teal,
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.lightbulb_outline),
                onPressed: () {
                  AdaptiveTheme.of(context).toggleThemeMode();
                }),
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    //  onTap: choiceAction(choice)//kholDo(choice),
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
          bottom: const TabBar(tabs: [
            const Tab(
              text: 'VIDEOS',
            ),
            const Tab(
              text: 'IMAGES',
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            const VideoScreen(),
            const ImageScreen(),
          ],
        ),
        //Dashboard(),
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.about) {
      openUrl(choice);
      print('About App');
    } else if (choice == Constants.rate) {
      openUrl(choice);
      print('Rate App');
    } else if (choice == Constants.share) {
      // Share.share(
      //     'https://play.google.com/store/apps/details?id=com.sudoStudio.whatsapp_status_saver');
      log('Share with friends');
    }
  }
}

class Constants {
  static const String about = 'About App';
  static const String rate = 'Rate App';
  static const String share = 'Share with friends';

  static const List<String> choices = <String>[
    about,
    rate,
  ];
}
