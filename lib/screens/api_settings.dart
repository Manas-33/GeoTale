import 'package:ai_app/components/connection_flag.dart';
import 'package:ai_app/components/drawer.dart';
import 'package:ai_app/connections/lg.dart' as Lg;
import 'package:ai_app/connections/lg.dart';
import 'package:ai_app/constants.dart';
import 'package:ai_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';
import 'package:vitality/vitality.dart';

class APIPage extends StatefulWidget {
  const APIPage({Key? key}) : super(key: key);

  @override
  _APIPageState createState() => _APIPageState();
}

class _APIPageState extends State<APIPage> {
  bool connectionStatus = false;

  late LGConnection lg;
  Future<void> _connectToLG() async {
    bool? result = await lg.connectToLG();
    setState(() {
      connectionStatus = result!;
    });
  }

  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _geminiAPIController.text = prefs.getString('gemniAPI') ?? '';
      _mapsAPIController.text = prefs.getString('mapsAPI') ?? '';
      _deepgramAPIController.text = prefs.getString('deepgramAPI') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    lg = LGConnection();
    _loadSettings();
    _connectToLG();
  }

  final TextEditingController _geminiAPIController = TextEditingController();
  final TextEditingController _mapsAPIController = TextEditingController();
  final TextEditingController _deepgramAPIController = TextEditingController();

  @override
  void dispose() {
    _geminiAPIController.dispose();
    _mapsAPIController.dispose();
    _deepgramAPIController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_geminiAPIController.text.isNotEmpty) {
      await prefs.setString('gemniAPI', _geminiAPIController.text);
    }
    if (_mapsAPIController.text.isNotEmpty) {
      await prefs.setString('mapsAPI', _mapsAPIController.text);
    }
    if (_deepgramAPIController.text.isNotEmpty) {
      await prefs.setString('deepgramAPI', _deepgramAPIController.text);
    }
    print(_geminiAPIController.text);
    print(_mapsAPIController.text);
    print(_deepgramAPIController.text);
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, connectionStatus);
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: AppDrawer(size: size),
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(125.0),
          child: Container(
            child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: backgroundColor,
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
                                'assets/images/logo.png',
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
                            color: secondColor),
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
                        padding: const EdgeInsets.fromLTRB(0, 0, 45, 0),
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 35.sp,
                        ),
                      ))
                ]),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30.h,
              ),
              Container(
                width: size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: secondColor,
                      ),
                      width: size.width * 0.4,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              "Gemini Key",
                              style: googleTextStyle(
                                  25.sp, FontWeight.w600, Colors.white),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            TextField(
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              style: googleTextStyle(
                                  16.sp, FontWeight.w500, backgroundColor),
                              controller: _geminiAPIController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15)),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5.0,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 15),
                                    child: Image.asset(
                                      "assets/images/google-gemini-icon.png",
                                      width: 25,
                                      height: 25,
                                      color: Colors.cyan,
                                    ),
                                  ),
                                ),
                                hintText: 'Enter Gemini API',
                                hintStyle: googleTextStyle(
                                    16.sp, FontWeight.w500, backgroundColor),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 30),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: secondColor,
                      ),
                      width: size.width * 0.4,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              "Google Maps API Key",
                              style: googleTextStyle(
                                  25.sp, FontWeight.w600, Colors.white),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            TextField(
                              obscureText: true,
                              style: googleTextStyle(
                                  16.sp, FontWeight.w500, backgroundColor),
                              controller: _mapsAPIController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15)),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5.0,
                                  ),
                                  child: Icon(
                                    Icons.public_rounded,
                                    color: Colors.cyan,
                                    size: 25,
                                  ),
                                ),
                                hintText: 'Enter the Maps API',
                                hintStyle: googleTextStyle(
                                    16.sp, FontWeight.w500, backgroundColor),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 30),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.h),
              Container(
                width: size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: secondColor,
                      ),
                      width: size.width * 0.4,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              "Deepgram API",
                              style: googleTextStyle(
                                  25.sp, FontWeight.w600, Colors.white),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            TextField(
                              obscureText: true,
                              style: googleTextStyle(
                                  16.sp, FontWeight.w500, backgroundColor),
                              controller: _deepgramAPIController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15)),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5.0,
                                  ),
                                  child: Icon(
                                    Icons.volume_up,
                                    color: Colors.cyan,
                                    size: 25,
                                  ),
                                ),
                                hintText: 'Enter the Deepgram API',
                                hintStyle: googleTextStyle(
                                    16.sp, FontWeight.w500, backgroundColor),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 30),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
              SizedBox(height: 25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () async {
            await _saveSettings();
            // bool? result = await lg.connectToLG();
            // print(result);
            // if (result == true) {
            //   setState(() {
            //     connectionStatus = true;
            //   });
            ToastService.showSuccessToast(
              context,
              length: ToastLength.medium,
              expandedHeight: 100,
              message: "Successfully Connected!",
            );
            //   print('Connected to LG successfully');
            // }
            // if (result == false || result == null) {
            //   print("asdas");
            //   ToastService.showErrorToast(
            //     context,
            //     length: ToastLength.medium,
            //     expandedHeight: 100,
            //     message: "Could not connect to the Rig!",
            //   );
            // }
          },
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "Set the API Keys",
              textAlign: TextAlign.center,
              style: googleTextStyle(20.sp, FontWeight.w700, backgroundColor),
            ),
            width: size.width * 0.1,
            height: size.width * 0.1,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
                color: const Color.fromARGB(255, 99, 222, 239),
                borderRadius: BorderRadius.circular(100)),
          ),
        ),
      ),
    );
  }
}
