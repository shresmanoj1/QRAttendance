import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance/common_view_model.dart';
import 'package:qr_attendance/request/date_request.dart';

import 'config/api_response_config.dart';

class StudentDailyAttendanceReportScreen extends StatefulWidget {
  const StudentDailyAttendanceReportScreen({Key? key}) : super(key: key);
  @override
  StudentDailyAttendanceReportStateScreen createState() =>
      StudentDailyAttendanceReportStateScreen();
}

class StudentDailyAttendanceReportStateScreen
    extends State<StudentDailyAttendanceReportScreen> {
  String? mySelection;
  String? selected_batch;

  List<dynamic> _studentListForDisplay = <dynamic>[];
  List<dynamic> _studentlist = <dynamic>[];

  bool show = false;
  late CommonViewModel _provider;
  Widget cusSearchBar = const Text(
    'Student Attendance',
    style: TextStyle(color: Colors.black),
  );
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<CommonViewModel>(context, listen: false);

      DateTime now = DateTime.now();

      final request = DateRequest(date: now);

      // _provider.fetchAllStudentAttendance(request).then((_){
      //   getSearchData();
      // });
      getSearchData(request);
      _provider.fetchCourses();
    });
    super.initState();
  }

  getSearchData(DateRequest request){
    setState(() {
      _studentListForDisplay.clear();
    });
    _provider.fetchAllStudentAttendance(request).then((_){

      for (int i = 0; i < _provider.allStudentAttendanceReport.dailyStdAttendance!.length; i++) {
        setState(() {
          var presentStudents = _provider.allStudentAttendanceReport.dailyStdAttendance?[i]["presentStudents"];

          presentStudents = presentStudents.map((v) => ({
            ...v,
            "moduleTitle": _provider.allStudentAttendanceReport.dailyStdAttendance[i]["moduleData"]
            ["moduleTitle"]
          })
          ).toList();
          _studentlist = [..._studentlist,...presentStudents];
          _studentListForDisplay = _studentlist;
        });
      }
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _searchController.dispose();
    mySelection = null;
    selected_batch = null;
    super.dispose();
  }
  // TextEditingController _searchController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<CommonViewModel>(builder: (context, value, child) {
      return Scaffold(
          body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: [
          TextFormField(
            // controller: _searchController,
            onChanged: (textChange){

                setState(() {
                  _studentListForDisplay = _studentlist.where((list) {
                    var studentName = list['firstname'].toLowerCase() +
                        " " +
                        list['lastname'].toLowerCase();
                    return studentName.contains(textChange);
                  }).toList();
                });

            },
            decoration: const InputDecoration(
              hintText: "Search by name",
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),

          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Course/Class',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DropdownButtonFormField(
            isExpanded: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              filled: true,
              hintText: 'Select a course',
            ),
            icon: const Icon(Icons.arrow_drop_down_outlined),
            items: value.courses.map((pt) {
              return DropdownMenuItem(
                value: pt.courseSlug,
                child: Text(
                  pt.courseName.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (newVal) {
              setState(() {
                mySelection = newVal as String?;
                selected_batch = null;
                show = true;
                value.fetchCourseBatch(mySelection.toString());
                DateTime now = DateTime.now();

                final request = DateRequest(date: now, course: mySelection);
                getSearchData(request);
              });
            },
            value: mySelection,
          ),
          SizedBox(
            height: 12,
          ),
          show == false
              ? SizedBox()
              : isLoading(value.courseBatchApiResponse)
                  ? Container()
                  : value.courseBatch.batches == null ||
                          value.courseBatch.batches!.isEmpty
                      ? const Text("No batch assigned in this module")
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Section/Batch',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DropdownButtonFormField(
                              hint: const Text('Select a batch'),
                              value: selected_batch,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                              ),
                              icon: const Icon(Icons.arrow_drop_down_outlined),
                              items: value.courseBatch.batches!.map((pt) {
                                return DropdownMenuItem(
                                  value: pt["batch"],
                                  child: Text(
                                    pt["batch"],
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  selected_batch = newVal as String?;
                                  Map<String, dynamic> request = {
                                    "batch": selected_batch,
                                    "fromDate": null,
                                    "toDate": null
                                  };
                                  DateTime now = DateTime.now();

                                  final request2 = DateRequest(
                                      date: now,
                                      course: mySelection,
                                      batch: selected_batch);
                                  getSearchData(request2);
                                  // value.fetchAllStudentAttendance(request2).then((_)=>getSearchData(request2));
                                });
                              },
                            ),
                          ],
                        ),
          SizedBox(
            height: 10,
          ),
          // selected_batch == null
          //     ? SizedBox()
          //     :
          isLoading(value.allStudentAttendanceReportApiResponse)
              ? const Center(child: CircularProgressIndicator())
              : value.allStudentAttendanceReport.dailyStdAttendance == null
                  ? Container()
                  : Builder(builder: (context) {
                      return Column(
                        children: [
                          ...List.generate(
                              _studentListForDisplay.length, (index) {
                            var datas = _studentListForDisplay[index];

                            return Container(
                              child: Card(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                  text: 'Name: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black),
                                                  children: [
                                                    TextSpan(
                                                      text: datas[
                                                      'firstname'] +
                                                          " " +
                                                          datas
                                                          ['lastname'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .normal,
                                                          color:
                                                          Colors.black),
                                                    ),
                                                  ]),
                                            ),
                                            datas
                                            ["contact"] ==
                                                null
                                                ? Text("contact: n/a")
                                                : RichText(
                                              text: TextSpan(
                                                  text: 'contact: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      color: Colors
                                                          .black),
                                                  children: [
                                                    TextSpan(
                                                      text: datas
                                                      ["contact"],
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .normal,
                                                          color: Colors
                                                              .black),
                                                    ),
                                                  ]),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  text: 'Module: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black),
                                                  children: [
                                                    TextSpan(
                                                      text: datas
                                                      ["moduleTitle"],
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .normal,
                                                          color:
                                                          Colors.black),
                                                    ),
                                                  ]),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            );
                          }),
                          SizedBox(height: 80)
                        ],
                      );
                    })
        ],
      ));
    });
  }
}
