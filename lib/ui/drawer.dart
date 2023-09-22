import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

import 'constant.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);
  openUrl() async {
    // ignore: deprecated_member_use
    if (await canLaunch(
        "https://sites.google.com/view/statussaver-sudostudio/home")) {
      // ignore: deprecated_member_use
      await launch("https://sites.google.com/view/statussaver-sudostudio/home");
    } else {
      throw 'Could not launch Url, please check your connection';
    }
  }

  openApp() async {
    // ignore: deprecated_member_use
    if (await canLaunch(
        "https://play.google.com/store/apps/details?id=com.sudoStudio.status_saver")) {
      // ignore: deprecated_member_use
      await launch(
          "https://play.google.com/store/apps/details?id=com.sudoStudio.status_saver");
    } else {
      throw 'Could not launch Url, please check your connection';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.teal.shade400,
        child: Column(
          children: <Widget>[
            AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              shadowColor: Colors.transparent,
              backgroundColor: Colors.blue.shade900,
              toolbarHeight: 180,
              title: Row(
                children: [
                  Icon(
                    Icons.supervised_user_circle,
                    size: 80,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to Status Saver',
                          // style: GoogleFonts.rajdhani(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'by',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontStyle: FontStyle.italic),
                        ),
                        Text(
                          'Sudo Studio',
                          style: TextStyle(fontSize: 24, color: Colors.purple),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              automaticallyImplyLeading: false, //back button of
            ),
            Divider(
              color: Colors.black12,
            ),
            ListTile(
              leading: const Icon(
                Icons.share,
                color: Colors.black,
              ),
              title: const Text('Share with friends'),
              onTap: () {
                Share.share(
                    'https://play.google.com/store/apps/details?id=com.sudoStudio.status_saver');
              },
            ),
            Divider(
              color: Colors.black12,
              endIndent: 20,
            ),
            ListTile(
              leading: Icon(
                Icons.privacy_tip_outlined,
                color: Colors.black,
              ),
              title: Text('Privacy Policy'),
              onTap: () {
                openUrl();
              },
            ),
            Divider(
              color: Colors.black12,
              endIndent: 30,
            ),
            ListTile(
              leading: Icon(
                Icons.star_sharp,
                color: Colors.black,
              ),
              title: Text('Rate Us '),
              onTap: () {
                openApp();
              },
            ),
            Divider(
              color: Colors.black12,
              endIndent: 40,
            ),
          ],
        ),
      ),
    );
  }
}
