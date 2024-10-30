import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance/common_view_model.dart';
import 'package:qr_attendance/response/login_response.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'config/api_response_config.dart';

class LecturerQrScreen extends StatelessWidget {
  final User? user;
  const LecturerQrScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CommonViewModel>(builder: (context, common, child) {
      return SingleChildScrollView(
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
                              child: common.institution["footerLogo"] == null
                                  ? const Text("Institution logo not available")
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Image.network(
                                        "https://api.schoolworkspro.com/uploads/institutions/" +
                                            common.institution["footerLogo"],
                                        height: 100,
                                        width: double.infinity,
                                      ),
                                    ),
                            )
                    ],
                  ),
            const SizedBox(
              height: 35,
            ),
            isLoading(common.routinePreferenceApiResponse)
                ? Container()
                : StreamBuilder(
                    stream: Stream.periodic(
                        Duration(seconds: common.routinePreference.refreshTime ?? 60)),
                    builder: (context, snapshot) {
                      DateTime now = DateTime.now();
                      var formattedtime = DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);
                      return Column(
                        children: [
                          Center(
                            child: QrImageView(
                              data:
                                  "https://api.schoolworkspro.com/staffAttendance/institution=${user?.institution.toString()}?$formattedtime",
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Image.asset('assets/images/schoolworkspro.png', width: 150),
          ],
        ),
      );
    });
  }
}
