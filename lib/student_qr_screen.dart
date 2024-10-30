import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance/response/encryp_student_qr_response.dart';
import 'package:qr_attendance/response/login_response.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common_view_model.dart';
import 'components/constants.dart';
import 'config/api_response_config.dart';

class QrAttendanceScreen extends StatefulWidget {
  const QrAttendanceScreen({Key? key})
      : super(key: key);

  @override
  State<QrAttendanceScreen> createState() =>
      _QrAttendanceScreenState();
}

class _QrAttendanceScreenState extends State<QrAttendanceScreen> {

  late CommonViewModel _provider;
  // QrData? qrData;
  Timer? _timer;

  Widget? showMessage;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<CommonViewModel>(context, listen: false);
      getData();

    });
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 20), (Timer t) {
      getData();
    });
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }
  User? user;

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
    return Consumer<CommonViewModel>(
        builder: (context, common, child) {
          return Scaffold(
              body: isLoading(common.encryptStudentQrApiResponse) ?
              const Center(child: CircularProgressIndicator()) :
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isLoading(common.institutionApiResponse)
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                        children: [
                          common.institution == null
                              ? const SizedBox()
                              : Container(
                            child: common.institution["footerLogo"] ==
                                null
                                ? const Text(
                                "Institution logo not available")
                                : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0),
                              child: Image.network(
                                "https://api.schoolworkspro.com/uploads/institutions/" +
                                    common.institution[
                                    "footerLogo"],
                                height: 100,
                                width: double.infinity,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 20)),
                          builder: (context, snapshot) {
                            return Column(
                              children: [
                                common.encryptStudentQr.qrData == null
                                    ? const Center(
                                  child: Text("No data found"),
                                )
                                    :
                                Center(
                                  child: QrImageView(
                                    data: jsonEncode((common.encryptStudentQr.qrData!.toJson())
                                      ..addAll({'type': 'StudentQr'})),
                                    version: QrVersions.auto,
                                    size: 350.0,
                                  ),
                                ),
                              ],
                            );
                          }),
                      StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            return Column(
                              children: [
                                Text(
                                  DateFormat('y-MMMM-d').format(DateTime.now()),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 21),
                                ),
                                Text(
                                  DateFormat('hh:mm:ss a').format(DateTime.now()),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 21),
                                ),
                              ],
                            );
                          }),
                      const SizedBox(
                        height: 50,
                      ),
                      const Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            "Powered by",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                      Image.asset('assets/images/schoolworkspro.png', width: 150),
                    ],
                  ),
                ),
              ));
        }
    );
  }
}
