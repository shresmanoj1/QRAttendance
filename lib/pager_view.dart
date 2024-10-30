import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance/attendance_stats.dart';
import 'package:qr_attendance/common_view_model.dart';
import 'package:qr_attendance/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../response/login_response.dart';

class PagerView extends StatefulWidget {
  final initialpage;
  const PagerView({Key? key, this.initialpage}) : super(key: key);
  static const String routeName = "/pager";

  @override
  State<PagerView> createState() => _PagerViewState();
}

class _PagerViewState extends State<PagerView> {
  int selectedIndex = 0;
  late CommonViewModel _commonViewModel;
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    selectedIndex = widget.initialpage;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
      _commonViewModel.fetchInstitution(context);
    });
    super.initState();
    // getUser();

    // checkversion();
  }

  // getUser() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String? userData = sharedPreferences.getString('_auth_');
  //   Map<String, dynamic> userMap = json.decode(userData!);
  //   User userD = User.fromJson(userMap);
  //   setState(() {
  //     user = userD;
  //   });
  // }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure'),
            content: const Text('Are you sure you want to close application'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    // _dismissDialog();
                    Navigator.of(context).pop();
                  },
                  child: const Text('No')),
              TextButton(
                onPressed: () => exit(0),
                child: const Text('Yes'),
              )
            ],
          );
        });
  }

  final _key2 = GlobalKey();
  final _key3 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: selectedIndex);
    _itemTapped(int selectedIndex) {
      pageController.jumpToPage(selectedIndex);
      setState(() {
        this.selectedIndex = selectedIndex;
      });
    }

    return WillPopScope(
      onWillPop: () {
        _showMaterialDialog();
        return Future.value(false);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: PageView(
            children: [
              HomePage(),
              AttendanceStatsScreen(),
            ],
          )),
    );
  }
}
