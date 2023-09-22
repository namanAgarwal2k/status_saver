import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:status_saver/ui/constant.dart';
import 'package:status_saver/ui/homePage.dart';
// import 'package:flutter_html/flutter_html.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int? _storagePermissionCheck;
  Future<int>? _storagePermissionChecker;

  int? androidSDK;

  Future<int> _loadPermission() async {
    //Get phone SDK version first inorder to request correct permissions.

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
    });
    //
    if (androidSDK! >= 33) {
      //request management permissions for android 13 and higher devices
      final _requestPhotos = await Permission.photos.request();
      final _requestVideos = await Permission.videos.request();
      //Update Provider model
      if (_requestPhotos.isGranted && _requestVideos.isGranted) {
        return 1;
      } else {
        return 0;
      }
    } else {
      //For older phones simply request the typical storage permissions
      //Check first if we already have the permissions
      final _currentStatusStorage = await Permission.storage.status;
      if (_currentStatusStorage.isGranted) {
        //Update provider
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestPermission() async {
    if (androidSDK! >= 33) {
      //request management permissions for android 13 and higher devices
      final _requestPhotos = await Permission.photos.request();
      final _requestVideos = await Permission.videos.request();
      //Update Provider model
      if (_requestPhotos.isGranted && _requestVideos.isGranted) {
        return 1;
      } else {
        return 0;
      }
    } else {
      final _requestStatusStorage = await Permission.storage.request();
      //Update provider model
      if (_requestStatusStorage.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestStoragePermission() async {
    /// PermissionStatus result = await
    /// SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    final result = await [Permission.storage].request();
    setState(() {});
    if (result[Permission.storage]!.isDenied) {
      return 0;
    } else if (result[Permission.storage]!.isGranted) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _storagePermissionChecker = (() async {
      int storagePermissionCheckInt;
      int finalPermission;

      if (_storagePermissionCheck == null || _storagePermissionCheck == 0) {
        _storagePermissionCheck = await _loadPermission();
      } else {
        _storagePermissionCheck = 1;
      }
      if (_storagePermissionCheck == 1) {
        storagePermissionCheckInt = 1;
      } else {
        storagePermissionCheckInt = 0;
      }

      if (storagePermissionCheckInt == 1) {
        finalPermission = 1;
      } else {
        finalPermission = 0;
      }

      return finalPermission;
    })();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Status Saver',
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: customThemeMode,
      home: DefaultTabController(
        length: 2,
        child: FutureBuilder(
          future: _storagePermissionChecker,
          builder: (context, status) {
            if (status.connectionState == ConnectionState.done) {
              if (status.hasData) {
                if (status.data == 1) {
                  return MyHome();
                } else {
                  return Scaffold(
                    body: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Colors.lightBlue.shade100,
                            Colors.lightBlue.shade200,
                            Colors.lightBlue.shade300,
                            Colors.lightBlue.shade200,
                            Colors.lightBlue.shade50,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'storage permission required',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: TextButton(
                              child: const Text(
                                'Allow Storage Permission',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              onPressed: () {
                                _storagePermissionChecker = requestPermission();
                                setState(() {});
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              } else {
                return Scaffold(
                  body: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colors.lightBlue.shade100,
                        Colors.lightBlue.shade200,
                        Colors.lightBlue.shade300,
                        Colors.lightBlue.shade200,
                        Colors.lightBlue.shade50,
                      ],
                    )),
                    child: const Center(
                      child: Text(
                        '''
Something went wrong.. Please uninstall and Install Again.''',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'presented by',
                        style: TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                      Text(
                        'Sudo Studio',
                        style: TextStyle(fontSize: 24, letterSpacing: 1),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      SizedBox(
                        width: 80,
                        child: LinearProgressIndicator(
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
