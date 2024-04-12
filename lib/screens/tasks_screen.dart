import 'package:ai_app/components/connection_flag.dart';
import 'package:ai_app/components/drawer.dart';
import 'package:ai_app/connections/lg.dart';
import 'package:ai_app/constants.dart';
import 'package:ai_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool connectionStatus = false;
  late LGConnection lg;
  Future<void> _connectToLG() async {
    bool? result = await lg.connectToLG();
    setState(() {
      connectionStatus = result!;
    });
  }

  @override
  void initState() {
    super.initState();
    lg = LGConnection();
    _connectToLG();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    var size = MediaQuery.of(context).size;
    return Scaffold(
        endDrawer: AppDrawer(size: size),
        key: _scaffoldKey,
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(135.0),
          child: Container(
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: secondColor,
              toolbarHeight: 150,
              elevation: 0,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            child: Image.asset(
                              'assets/images/logoplain.png',
                              scale: 4.5.h,
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Container(
                            child: Image.asset(
                              'assets/images/logo2.png',
                              scale: 4.5.h,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: ConnectionFlag(
                          status: connectionStatus,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color.fromARGB(255, 53, 161, 255)),
                      child: Image.asset(
                        "assets/images/home.png",
                        color: Colors.white,
                      )),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ));
                  },
                ),
                SizedBox(
                  width: 30.h,
                ),
                IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState!.openEndDrawer();
                    },
                    icon: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 60, 0),
                      child: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 35.sp,
                      ),
                    ))
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width * 0.88,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await lg.relaunchLG();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Relaunch Rig",
                                textAlign: TextAlign.center,
                                style: googleTextStyle(
                                    32.sp, FontWeight.w700, backgroundColor),
                              ),
                              width: size.width * 0.39,
                              height: size.width * 0.145,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 15,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(60)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await lg.shutdownLG();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Shutdown Rig",
                                textAlign: TextAlign.center,
                                style: googleTextStyle(
                                    32.sp, FontWeight.w700, backgroundColor),
                              ),
                              width: size.width * 0.39,
                              height: size.width * 0.145,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 15,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(60)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Container(
                      width: size.width * 0.88,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await lg.cleanVisualization();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Clean KML",
                                textAlign: TextAlign.center,
                                style: googleTextStyle(
                                    32.sp, FontWeight.w700, backgroundColor),
                              ),
                              width: size.width * 0.39,
                              height: size.width * 0.145,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 15,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                  color: Color.fromARGB(255, 103, 244, 108),
                                  borderRadius: BorderRadius.circular(60)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await lg.rebootLG();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Reboot Rig",
                                textAlign: TextAlign.center,
                                style: googleTextStyle(
                                    32.sp, FontWeight.w700, backgroundColor),
                              ),
                              width: size.width * 0.39,
                              height: size.width * 0.145,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 15,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                  color: Color.fromARGB(255, 76, 232, 240),
                                  borderRadius: BorderRadius.circular(60)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Container(
                      width: size.width * 0.88,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await lg.cleanBalloon();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Clean Logos",
                                textAlign: TextAlign.center,
                                style: googleTextStyle(
                                    32.sp, FontWeight.w700, backgroundColor),
                              ),
                              width: size.width * 0.39,
                              height: size.width * 0.145,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 15,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(60)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await lg.setRefresh();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Set Refresh",
                                textAlign: TextAlign.center,
                                style: googleTextStyle(
                                    32.sp, FontWeight.w700, backgroundColor),
                              ),
                              width: size.width * 0.39,
                              height: size.width * 0.145,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 15,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                  color: Color.fromARGB(255, 255, 145, 0),
                                  borderRadius: BorderRadius.circular(60)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
