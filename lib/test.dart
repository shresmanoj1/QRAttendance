// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/Dashboardlecturer/viewexamattendance_screen.dart';
// import 'package:schoolworkspro_app/api/repositories/exam_repo.dart';
// import 'package:schoolworkspro_app/common_view_model.dart';
// import 'package:schoolworkspro_app/config/api_response_config.dart';
// import 'package:schoolworkspro_app/constants.dart';
// import 'package:schoolworkspro_app/request/lecturer/examattendance_request.dart';
// import 'package:schoolworkspro_app/request/lecturer/qrdataexam_request.dart';
// import 'package:schoolworkspro_app/response/idfromqr_response.dart';
//
// class ExaminationLecturer extends StatefulWidget {
//   const ExaminationLecturer({Key? key}) : super(key: key);
//
//   @override
//   _ExaminationLecturerState createState() => _ExaminationLecturerState();
// }
//
// class _ExaminationLecturerState extends State<ExaminationLecturer> {
//   @override
//   Widget build(BuildContext context) {
//     return ExaminationLecturerBody();
//   }
// }
//
// class ExaminationLecturerBody extends StatefulWidget {
//   const ExaminationLecturerBody({Key? key}) : super(key: key);
//
//   @override
//   _ExaminationLecturerBodyState createState() =>
//       _ExaminationLecturerBodyState();
// }
//
// class _ExaminationLecturerBodyState extends State<ExaminationLecturerBody> {
//   QrDataExamRequest? qr;
//
//   String _scanBarcode = 'Unknown';
//   List<dynamic> _list = <dynamic>[];
//   List<dynamic> _listForDisplay = <dynamic>[];
//   Widget? cusSearchBar;
//   TextEditingController _searchController = new TextEditingController();
//
//   Icon cusIcon = Icon(Icons.search);
//
//   late CommonViewModel _provider;
//   @override
//   void initState() {
//     // TODO: implement initState
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _provider = Provider.of<CommonViewModel>(context, listen: false);
//       _provider.fetchExamLecturer();
//
//       getData();
//     });
//
//     super.initState();
//   }
//
//   getData() async {
//
//     for (int i = 0; i < _provider.examslecturer.length; i++) {
//       setState(() {
//         _list.add(_provider.examslecturer[i]);
//         _listForDisplay = _list;
//       });
//     }
//     cusSearchBar = Text("Examination",style: TextStyle(color: Colors.black),);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//               onPressed: () {
//                 setState(() {
//                   if (this.cusIcon.icon == Icons.search) {
//                     this.cusIcon = Icon(
//                       Icons.cancel,
//                       color: Colors.grey,
//                     );
//                     this.cusSearchBar = TextField(
//                       autofocus: true,
//                       textInputAction: TextInputAction.go,
//                       controller: _searchController,
//                       decoration: const InputDecoration(
//                           hintText: 'search ...', border: InputBorder.none),
//                       onChanged: (text) {
//                         setState(() {
//                           _listForDisplay = _list.where((list) {
//                             var itemName = list['module'].toLowerCase();
//                             return itemName.contains(text);
//                           }).toList();
//                         });
//                       },
//                     );
//                   } else {
//                     this.cusIcon = Icon(Icons.search);
//                     _listForDisplay = _list;
//                     _searchController.clear();
//                     this.cusSearchBar = Text(
//                       "Examination",
//                       style: TextStyle(color: Colors.black),
//                     );
//                   }
//                 });
//               },
//               icon: cusIcon)
//         ],
//         title: cusSearchBar,
//         elevation: 0.0,
//         iconTheme: const IconThemeData(
//           color: Colors.black, //change your color here
//         ),
//         backgroundColor: Colors.white,
//       ),
//       body: _listForDisplay.isEmpty
//           ? const SpinKitDualRing(color: kPrimaryColor)
//           : getListView(),
//     );
//   }
//
//   Future<void> scanQR(dynamic id) async {
//     String barcodeScanRes;
//     DateTime now = DateTime.now();
//
//     var formattedtime = DateFormat('yyyyMMddmm').format(now);
//     // await Future.delayed(Duration(seconds: 5));
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//           '#ff6666', 'Cancel', true, ScanMode.QR);
//
//       final Map<String, dynamic> qrMap = json.decode(barcodeScanRes);
//       QrDataExamRequest qrD = QrDataExamRequest.fromJson(qrMap);
//       setState(() {
//         qr = qrD;
//       });
//
//       if (qr!.exams!.contains(id.toString())) {
//         final data = ExamAttendanceRequest(
//             username: qr!.username.toString(),
//             institution: qr!.institution.toString(),
//             exam: id.toString());
//         var full_name =
//             qr!.firstname.toString() + " " + qr!.lastname.toString();
//         hitAttendance(data, full_name);
//       } else {
//         Fluttertoast.showToast(msg: 'Examination not found');
//       }
//     } on PlatformException {
//       barcodeScanRes = 'Failed to get platform version.';
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     setState(() {
//       _scanBarcode = barcodeScanRes;
//     });
//   }
//
//   hitAttendance(ExamAttendanceRequest request, String name) async {
//     try {
//       final res = await ExamRepository().postExamAttendance(request);
//       if (res.success == true) {
//         Fluttertoast.showToast(msg: "${res.message} of $name");
//       } else {
//         Fluttertoast.showToast(msg: res.message.toString());
//       }
//     } on Exception catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//       // TODO
//     }
//   }
//
//   List<dynamic> getListElements() {
//     var items = List<dynamic>.generate(
//         _listForDisplay.length, (counter) => _listForDisplay[counter]);
//     return items;
//   }
//
//   Widget getListView() {
//     var listItems = getListElements();
//     var listview = ListView(
//       children: [
//         ...List.generate(
//             listItems.length,
//                 (index) => Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ListTile(
//                       title: RichText(
//                         text: TextSpan(
//                           text: 'Module Title: ',
//                           style: const TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold),
//                           children: <TextSpan>[
//                             TextSpan(
//                               text: listItems[index]['module'].toString(),
//                               style: const TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                           ],
//                         ),
//                       ),
//                       subtitle: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Builder(builder: (context) {
//                             DateTime now = DateTime.parse(
//                                 listItems[index]['startDate'].toString());
//
//                             now = now
//                                 .add(const Duration(hours: 5, minutes: 45));
//
//                             final formattedTime =
//                             DateFormat('y-MMMM-d hh:mm a').format(now);
//                             return RichText(
//                               text: TextSpan(
//                                 text: 'Date & time: ',
//                                 style: const TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold),
//                                 children: <TextSpan>[
//                                   TextSpan(
//                                     text: formattedTime.toString(),
//                                     style: const TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.normal),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }),
//                         ],
//                       ),
//                     ),
//                     ExpansionTile(
//                       title: Text(
//                         "Batch/Sections:",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 14),
//                       ),
//                       children: [
//                         Wrap(
//                           direction: Axis.horizontal,
//                           children: [
//                             for (int i = 0;
//                             i < listItems[index]['batch'].length;
//                             i++)
//                               Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 12),
//                                   child: Chip(
//                                     label:
//                                     Text(listItems[index]['batch'][i]),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           OutlinedButton(
//                             child: const Text("View Attendance"),
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           ViewExamAttendanceScreen(
//                                             examID: listItems[index]['_id'],
//                                           )));
//                             },
//                           ),
//                           OutlinedButton(
//                             child: const Text("Scan QR"),
//                             onPressed: () =>
//                                 scanQR(listItems[index]['_id']),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             )),
//       ],
//     );
//     return listview;
//   }
// }
