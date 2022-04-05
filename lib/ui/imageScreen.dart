// @dart=2.9

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'viewphotos.dart';

final Directory _photoDir =
    Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key key}) : super(key: key);
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
    if (!Directory('${_photoDir.path}').existsSync()) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Install WhatsApp\n',
            style: TextStyle(fontSize: 18.0),
          ),
          const Text(
            "Your Friend's Status Will Be Available Here",
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      );
    } else {
      final imageList = _photoDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith('.jpg'))
          .toList(growable: false);
      print(imageList);
      if (imageList.length > 0) {
        return Container(
          margin: const EdgeInsets.all(8.0),
          child: StaggeredGridView.countBuilder(
            itemCount: imageList.length,
            crossAxisCount: 4,
            itemBuilder: (context, index) {
              final imgPath = imageList[index];
              return Material(
                elevation: 8.0,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: InkWell(
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
                  child: HeroMode(
                    child: Hero(
                        tag: imgPath,
                        child: Image.file(
                          File(imgPath),
                          fit: BoxFit.cover,
                        )),
                    enabled: false,
                  ),
                ),
              );
            },
            staggeredTileBuilder: (i) =>
                StaggeredTile.count(2, i.isEven ? 2 : 3),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
        );
      } else {
        return Scaffold(
          body: Center(
            child: Container(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: const Text(
                  'Sorry, No Image Found!',
                  style: TextStyle(fontSize: 18.0),
                )),
          ),
        );
      }
    }
  }
}
