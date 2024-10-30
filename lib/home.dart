import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance/common_view_model.dart';
import 'package:qr_attendance/components/constants.dart';
import 'package:qr_attendance/lecturer_qr_screen.dart';
import 'package:qr_attendance/login.dart';
import 'package:qr_attendance/response/idfromqr_response.dart';
import 'package:qr_attendance/response/login_response.dart';
import 'package:qr_attendance/services/punch_service.dart';
import 'package:qr_attendance/student_qr_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IdRequestFromQr? qr;
  User? user;
  late CommonViewModel _provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<CommonViewModel>(context, listen: false);
      _provider.fetchRoutinePreference();

    });
    getData();
    // checkVersion();
    super.initState();
  }

  String _scanBarcode = 'Unknown';
  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString(kAuth);
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
    _provider.fetchEncryptStudentQr({"institution": user!.institution.toString()});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommonViewModel>(builder: (context, common, child) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                'Scan QR For Attendance',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: const Text("Are you sure"),
                              content:
                                  const Text("Are you sure you want to logout"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No")),
                                TextButton(
                                    onPressed: () async {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      await sharedPreferences.clear();

                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()));
                                    },
                                    child: const Text("Yes")),
                              ],
                            );
                          });
                        },
                      );
                    },
                    icon: const Icon(Icons.logout)),
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () => scanQR(),
                )
              ],
              backgroundColor: const Color(0xFF004D96),
              elevation: 0.0,
              iconTheme: const IconThemeData(color: Colors.white),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(55),
                child: Builder(builder: (context) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TabBar(
                      physics: NeverScrollableScrollPhysics(),
                      unselectedLabelColor: Colors.white,
                      labelColor: Colors.black,
                      labelStyle:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                      indicator: BoxDecoration(
                        border: Border(),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                        color: Colors.white,
                      ),
                      tabs: [
                        Tab(text: "Staff QR"),
                        Tab(
                          text: "Student QR",
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                LecturerQrScreen(user: user),
                const QrAttendanceScreen(),
              ],
            )),
      );
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      Map<String, dynamic> qrMap = json.decode(barcodeScanRes);
      IdRequestFromQr qrD = IdRequestFromQr.fromJson(qrMap);
      setState(() {
        qr = qrD;
      });

      if (qr?.type == "Student") {
        final data = jsonEncode({
          "username": qr?.username.toString(),
        });

        final res = await PunchService().studentAttendance(data);

        Fluttertoast.showToast(msg: res.message.toString());
        //
      }
      else {
        final data = IdRequestFromQr(
            institution: qr?.institution.toString(),
            username: qr?.username.toString());

        final res = await PunchService().punchInOut(data);

        Fluttertoast.showToast(msg: res.message.toString());
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }
}
