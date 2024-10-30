import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance/request/date_request.dart';
import 'package:qr_attendance/response/staff_attendanceresponse.dart';
import 'package:qr_attendance/services/attendance_report.dart';
import 'package:qr_attendance/services/student_attendance_report.dart';
import 'package:qr_attendance/student_daily_attendance_screen.dart';

import 'components/constants.dart';

class AttendanceStatsScreen extends StatefulWidget {
  const AttendanceStatsScreen({Key? key}) : super(key: key);

  @override
  _AttendanceStatsScreenState createState() => _AttendanceStatsScreenState();
}

class _AttendanceStatsScreenState extends State<AttendanceStatsScreen> {
  // Future<StaffAttendanceResponse>? response;
  List<dynamic> _list = <dynamic>[];
  List<dynamic> _listForDisplay = <dynamic>[];

  List<dynamic> _studentListForDisplay = <dynamic>[];
  List<dynamic> _studentlist = <dynamic>[];
  List<dynamic> _originalList = [];

  List<String> filerByStaffType = [];

  Widget? cusSearchBar;
  Widget? cusStudentSearchBar;

  bool checkIsStaff = false;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    getStudentData();
    // checkVersion();
    _studentListForDisplay.clear();
    filerByStaffType.clear();
    super.initState();
  }

  List selectOption = [
    {"name": "All", "value": "all"},
    {"name": "Staff", "value": "Staff"},
    {"name": "Teacher/Lecturer", "value": "Lecturer"}
  ];

  // checkVersion() async {
  //   final new_version = NewVersion(
  //     androidId: "np.edu.swp.qrattendance",
  //     iOSId: "np.edu.swp.qrattendance",
  //   );
  //
  //   final status = await new_version.getVersionStatus();
  //   print('heello world:::' + status!.storeVersion);
  //   print('heello world:::' + status.localVersion);
  //
  //   if (Platform.isAndroid) {
  //     if (status.localVersion != status.storeVersion) {
  //       new_version.showUpdateDialog(
  //           dialogText: "You need to update this application",
  //           context: context,
  //           versionStatus: status);
  //     }
  //   } else if (Platform.isIOS) {
  //     if (status.canUpdate) {
  //       new_version.showUpdateDialog(
  //           dialogText: "You need to update this application",
  //           context: context,
  //           versionStatus: status);
  //     }
  //   }
  // }

  TextEditingController _searchController = new TextEditingController();
  TextEditingController _searchStudentController = new TextEditingController();

  Icon cusIcon = const Icon(Icons.search);
  Icon cusStudentIcon = const Icon(Icons.search);

  int presentCount = 0;
  int studentPresentCount = 0;
  int totalCount = 0;
  num studentTotalCount = 0;
  int absentStudent = 0;

  int selectedIndex = 0;
  String title = 'Staffs';

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      DateTime now = DateTime.now();
      filerByStaffType.clear();

      final request = DateRequest(date: now);
      final data = await StaffAttendanceService().getstats(request);
      await StaffAttendanceService().getStaff().then((value) {
        if (value.staffs != null || value.staffs!.isNotEmpty) {
          for (int p = 0; p < value.staffs!.length; p++) {
            setState(() {
              filerByStaffType.add(value.staffs![p]);
            });
          }
        }
      });

      for (int i = 0; i < data.attendanceData!.length; i++) {
        setState(() {
          _list.add(data.attendanceData?[i]);
          _listForDisplay = _list;
          _originalList = List.from(_list);
          isLoading = false;
          totalCount = data.attendanceData!.length;
        });

        if (data.attendanceData?[i]["attendance"] == 1) {
          setState(() {
            presentCount = presentCount + 1;
          });
        }
        cusSearchBar = Text(
          "Today's Attendance ${presentCount.toString()}/${data.attendanceData?.length.toString()}",
          style: TextStyle(color: Colors.black),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  getStudentData() async {
    DateTime now = DateTime.now();

    final request = DateRequest(date: now);
    final data = await StudentAttendanceReportService()
        .studentDailyAttendanceReport(request);

    for (int i = 0; i < data.dailyStdAttendance!.length; i++) {
      setState(() {
        var presentStudents = data.dailyStdAttendance?[i]["presentStudents"];

        presentStudents = presentStudents
            .map((v) => ({
                  ...v,
                  "moduleTitle": data.dailyStdAttendance[i]["moduleData"]
                      ["moduleTitle"]
                }))
            .toList();
        _studentlist = [..._studentlist, ...presentStudents];
        _studentListForDisplay = _studentlist;
        absentStudent = (absentStudent +
                data.dailyStdAttendance?[i]["absentStudents"].length)
            .toInt();
      });
    }
    studentTotalCount = _studentlist.length + absentStudent;
    cusStudentSearchBar = Text(
      "Daily Attendance",
      style: TextStyle(color: Colors.black),
    );
  }

  _onPageChanged(int index) {
    // onTap
    setState(() {
      selectedIndex = index;
      switch (index) {
        case 0:
          {
            title = "Staffs";
          }
          break;
        case 1:
          {
            title = "Students";
          }
          break;
      }
    });
  }

  PageController pagecontroller = PageController();

  _itemTapped(int selectedIndex) {
    pagecontroller.jumpToPage(selectedIndex);
    setState(() {
      this.selectedIndex = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
              child: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == menubar.all) {
                    setState(() {
                      isLoading = true;
                    });
                    setState(() {
                      _listForDisplay.clear();
                      _list.clear();
                    });
                    DateTime now = DateTime.now();

                    final request = DateRequest(date: now);
                    final data =
                        await StaffAttendanceService().getstats(request);

                    for (int i = 0; i < data.attendanceData!.length; i++) {
                      setState(() {
                        _list.add(data.attendanceData?[i]);
                        _listForDisplay = _list;
                      });
                    }
                    setState(() {
                      isLoading = false;
                    });
                  } else if (value == menubar.arrived) {
                    setState(() {
                      _listForDisplay.clear();
                      _list.clear();
                    });
                    setState(() {
                      isLoading = true;
                    });
                    DateTime now = DateTime.now();

                    final request = DateRequest(date: now);
                    final data =
                        await StaffAttendanceService().getstats(request);

                    for (int i = 0; i < data.attendanceData!.length; i++) {
                      if (data.attendanceData?[i]['attendance'] == 1) {
                        setState(() {
                          _list.add(data.attendanceData?[i]);
                          _listForDisplay = _list;
                        });
                      }
                    }
                    setState(() {
                      isLoading = false;
                    });
                  } else if (value == menubar.not_arrived) {
                    setState(() {
                      isLoading = true;
                    });
                    setState(() {
                      _listForDisplay.clear();
                      _list.clear();
                    });
                    DateTime now = DateTime.now();

                    final request = DateRequest(date: now);
                    final data =
                        await StaffAttendanceService().getstats(request);

                    for (int i = 0; i < data.attendanceData!.length; i++) {
                      if (data.attendanceData?[i]['attendance'] == 0) {
                        setState(() {
                          _list.add(data.attendanceData?[i]);
                          _listForDisplay = _list;
                        });
                      }
                    }
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return menubar.settings.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
                icon: const Icon(
                  Icons.filter_alt_outlined,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.green,
              onPressed: () {},
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: _itemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: "Staffs",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.black,
            ),
            label: 'Students',
          ),
        ],
      ),
      appBar: selectedIndex == 0
          ? AppBar(
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (this.cusIcon.icon == Icons.search) {
                          this.cusIcon = const Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          );
                          this.cusSearchBar = TextField(
                            autofocus: true,
                            textInputAction: TextInputAction.go,
                            controller: _searchController,
                            decoration: const InputDecoration(
                                hintText: 'search ...',
                                border: InputBorder.none),
                            onChanged: (text) {
                              setState(() {
                                _listForDisplay = _list.where((list) {
                                  var itemName =
                                      list['firstname'].toLowerCase() +
                                          " " +
                                          list['lastname'].toLowerCase();
                                  return itemName.contains(text);
                                }).toList();
                              });
                            },
                          );
                        } else {
                          this.cusIcon = Icon(Icons.search);
                          _listForDisplay = _list;
                          _searchController.clear();
                          this.cusSearchBar = Text(
                            "Today's Attendance ${presentCount.toString()}/${totalCount.toString()}",
                            style: TextStyle(color: Colors.black),
                          );
                        }
                      });
                    },
                    icon: cusIcon)
              ],
              title: cusSearchBar,
              elevation: 0.0,
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.white,
            )
          : AppBar(
              automaticallyImplyLeading: false,
              title: const Text("Daily Attendance",
                  style: TextStyle(color: Colors.black)),
              elevation: 0.0,
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.white,
            ),
      body: PageView(
        controller: pagecontroller,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonFormField(
                    value: 'all',
                    hint: const Text('Select Option'),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                    ),
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    items: selectOption.map((pt) {
                      return DropdownMenuItem(
                        value: pt["value"],
                        child: Text(pt["name"]),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        if (newVal == "all") {
                          setState(() {
                            checkIsStaff = false;
                          });
                          _listForDisplay = List.from(_originalList);
                        } else if (newVal == "Lecturer") {
                          setState(() {
                            checkIsStaff = false;
                          });
                          _listForDisplay = _list
                              .where((element) => element["type"] == "Lecturer")
                              .toList();
                        } else if (newVal == "Staff") {
                          setState(() {
                            checkIsStaff = true;
                          });
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                checkIsStaff == true
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButtonFormField(
                          hint: const Text('Select type'),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                          ),
                          icon: const Icon(Icons.arrow_drop_down_outlined),
                          items: filerByStaffType.map((pt) {
                            return DropdownMenuItem(
                              value: pt,
                              child: Text(pt),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              _listForDisplay = _list.where((list) {
                                var itemName = list['type'];
                                return itemName == newVal;
                              }).toList();
                            });
                          },
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 10,
                ),
                isLoading == false
                    ? _listForDisplay.isNotEmpty
                        ? ListView.builder(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? _searchBar()
                                  : _listItem(index - 1);
                            },
                            itemCount: _listForDisplay.length + 1,
                          )
                        : const Center(child: Text("No Data Found"))
                    : const Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      ),
                const SizedBox(
                  height: 75,
                ),
              ],
            ),
          ),
          _studentListForDisplay.isNotEmpty
              ? const StudentDailyAttendanceReportScreen()
              : const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                ),
        ],
      ),
    );
  }

  _searchBar() {
    return SizedBox();
  }

  _listItem(index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            _listForDisplay[index]['firstname'] +
                " " +
                _listForDisplay[index]['lastname'],
            style: const TextStyle(fontSize: 16),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _listForDisplay[index]['email'],
                style: const TextStyle(fontSize: 16),
              ),
              Text(_listForDisplay[index]['type']),
              _listForDisplay[index]['punchIn_Out'] == "absent"
                  ? const SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(builder: (context) {
                          if (_listForDisplay[index]['punchIn_Out'][0]
                                  ['punchIn'] !=
                              null) {
                            DateTime now = DateTime.parse(_listForDisplay[index]
                                    ['punchIn_Out'][0]['punchIn']
                                .toString());

                            now = now.add(Duration(hours: 5, minutes: 45));

                            var formattedTime =
                                DateFormat('hh:mm a').format(now);
                            return Text("In time: " + formattedTime);
                          }
                          return Text("");
                        }),
                        Builder(builder: (context) {
                          if (_listForDisplay[index]['punchIn_Out'][0]
                                  ['punchOut'] !=
                              null) {
                            DateTime now = DateTime.parse(_listForDisplay[index]
                                    ['punchIn_Out'][0]['punchOut']
                                .toString());

                            DateTime innow = DateTime.parse(
                                _listForDisplay[index]['punchIn_Out'][0]
                                        ['punchIn']
                                    .toString());
                            innow = innow.add(Duration(hours: 5, minutes: 45));
                            now = now.add(Duration(hours: 5, minutes: 45));

                            Duration diff = now.difference(innow).abs();
                            final hours = diff.inHours;
                            final minutes = diff.inMinutes % 60;
                            var formattedTime =
                                DateFormat('hh:mm a').format(now);
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Out Time: " + formattedTime.toString()),
                                Text("Work duration: " +
                                    hours.toString() +
                                    " hours " +
                                    minutes.toString() +
                                    " minutes")
                              ],
                            );
                          }
                          return Text("");
                        }),
                      ],
                    )
            ],
          ),
          trailing: _listForDisplay[index]['attendance'] == 0
              ? Icon(
                  Icons.cancel,
                  color: Colors.red,
                )
              : Icon(
                  Icons.check,
                  color: Colors.green,
                ),
        ),
      ],
    );
  }

  List<dynamic> getListElements() {
    var items = List<dynamic>.generate(_studentListForDisplay.length,
        (counter) => _studentListForDisplay[counter]);
    return items;
  }

  Widget getListView() {
    var listItems = getListElements();
    var listview = ListView.builder(
        shrinkWrap: true,
        itemCount: listItems.length,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  _studentListForDisplay[index]['firstname'] +
                      " " +
                      _studentListForDisplay[index]['lastname'],
                  style: const TextStyle(fontSize: 16),
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _studentListForDisplay[index]['username'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      _studentListForDisplay[index]['moduleTitle'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
    return listview;
  }
}

class menubar {
  static const String all = "All";
  static const String not_arrived = "Not Arrived";
  static const String arrived = "Arrived";

  static const List<String> settings = <String>[all, not_arrived, arrived];
}
