import 'dart:io';

import 'package:flutter/material.dart';
import 'package:status_saver/ui/constant.dart';
import 'viewphotos.dart';

final Directory _newPhotoDir =
    Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);
  @override
  ImageScreenState createState() => ImageScreenState();
}

class ImageScreenState extends State<ImageScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!Directory('${_newPhotoDir.path}').existsSync()) {
      return Container(
        color: isDark ? Colors.black : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Install WhatsApp\n',
              style: TextStyle(
                fontSize: 18.0,
                color: textColor,
              ),
            ),
            Text(
              "Your Friend's Status Will Be Available Here",
              style: TextStyle(
                fontSize: 18.0,
                color: textColor,
              ),
            ),
          ],
        ),
      );
    } else {
      final imageList = _newPhotoDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith('.jpg'))
          .toList(growable: false);
      if (imageList.length > 0) {
        return Container(
            color: isDark ? Colors.black : Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              key: PageStorageKey(widget.key),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 0.5, maxCrossAxisExtent: 150),
              itemCount: imageList.length,
              itemBuilder: (BuildContext context, int index) {
                final String imgPath = imageList[index];
                return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewPhotos(
                              imgPath: imgPath,
                            ),
                          ),
                        );
                      },
                      child: Image.file(
                        File(imageList[index]),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                      ),
                    ));
              },
            ));
      } else {
        return Scaffold(
          body: Center(
            child: Container(
                color: isDark ? Colors.black : Colors.white,
                padding: const EdgeInsets.only(bottom: 60.0),
                child: Text(
                  'Sorry, No Image Found!\n'
                  'Watch your friend status first and than try reopening the app',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: textColor,
                  ),
                )),
          ),
        );
      }
    }
  }
}
