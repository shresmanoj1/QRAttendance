import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance/common_view_model.dart';
import 'package:qr_attendance/components/constants.dart';
import 'package:qr_attendance/login.dart';
import 'package:qr_attendance/pager_view.dart';
import 'package:qr_attendance/routes/route_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/environment.config.dart';
import 'config/preference_utils.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await EnvironmentConfig().init();
  await PreferenceUtils.init();
  ByteData data =
      await PlatformAssetBundle().load('assets/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  SharedPreferences preferences = PreferenceUtils.instance;
  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp(
    entry: preferences.getString(kToken) == null ? false : true,
  ));
}

class MyApp extends StatelessWidget {
  bool entry;
  MyApp({Key? key, required this.entry}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return OverlayKit(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<CommonViewModel>(
            create: (_) => CommonViewModel(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'QR Attendance',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute:
          entry == true ? PagerView.routeName : LoginScreen.routeName,
          onGenerateRoute: RouteGenerator.generateRoute,
        )
      ),
    );
  }

}
