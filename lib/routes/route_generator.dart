import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance/login.dart';
import 'package:qr_attendance/pager_view.dart';

import '../common_view_model.dart';


class RouteGenerator {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {Object? args}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: args);
  }

  static Future<dynamic> replacePage(String routeName, {Object? args}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: args);
  }

  static goBack() {
    return navigatorKey.currentState?.pop();
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final arg = settings.arguments;
    switch (settings.name) {

      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case PagerView.routeName:
        return MaterialPageRoute(builder: (_) => const PagerView(initialpage: 0,));

      default:
        _onPageNotFound();
    }
  }

  static Route<dynamic> _onPageNotFound() {
    return MaterialPageRoute(
      builder: (_) => Consumer<CommonViewModel>(builder: (_, value, child) {
        return const Scaffold(body: Text("Page not found"));
      }),
    );
  }
}
