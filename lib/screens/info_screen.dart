import 'dart:async';

import 'package:ai_app/components/cities.dart';
import 'package:ai_app/components/connection_flag.dart';
import 'package:ai_app/connections/lg.dart';
import 'package:ai_app/constants.dart';
import 'package:ai_app/connections/lg.dart' as Lg;
import 'package:ai_app/screens/home_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:group_button/group_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityInformation extends StatefulWidget {
  @override
  State<CityInformation> createState() => CityInformationState();
}

class CityInformationState extends State<CityInformation> {
  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    bool connectionStatus = false;
    late LGConnection lg;
    final apiKey = dotenv.env['MAP_API_KEY'];
    TextEditingController _textEditingController = TextEditingController();

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

    CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(19.0760, 72.8777),
      zoom: 11,
    );
    final Completer<GoogleMapController> _controllerGoogleMap =
        Completer<GoogleMapController>();

    late GoogleMapController newGoogleMapController;
    var size = MediaQuery.of(context).size;
    List<String> adjectives = [
      "Creative",
      "Exciting",
      "Mysterious",
      "Romantic",
      "Thrilling",
      "Inspiring",
      "Fascinating",
    ];
    return Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 35,
                      ),
                      SizedBox(
                        width: 5.h,
                      ),
                      Text(
                        "Mumbai, India",
                        style: googleTextStyle(
                            25.sp, FontWeight.w600, Colors.white),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GroupButton(
                      options: GroupButtonOptions(
                        selectedShadow: const [],
                        selectedTextStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.pink[900],
                        ),
                        selectedColor: Colors.pink[100],
                        unselectedShadow: const [],
                        unselectedColor: Colors.amber[100],
                        unselectedTextStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.amber[900],
                        ),
                        selectedBorderColor: Colors.pink[900],
                        unselectedBorderColor: Colors.amber[900],
                        borderRadius: BorderRadius.circular(100),
                        spacing: 10,
                        runSpacing: 10,
                        groupingType: GroupingType.wrap,
                        direction: Axis.horizontal,
                        buttonHeight: 60,
                        buttonWidth: 60,
                        mainGroupAlignment: MainGroupAlignment.start,
                        crossGroupAlignment: CrossGroupAlignment.start,
                        groupRunAlignment: GroupRunAlignment.start,
                        textAlign: TextAlign.center,
                        textPadding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        elevation: 0,
                      ),
                      isRadio: false,
                      buttons: [
                        "Creative",
                        "Exciting",
                        "Mysterious",
                        "Thrilling",
                        "Inspiring",
                        "Fascinating",
                      ]),
                  SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: secondColor,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                              left: 50,
                              child: Image.asset(
                                "assets/images/orbit.png",
                                scale: 1.5,
                              )),
                          Positioned(
                            right: 30,
                            top: 30,
                            child: Text(
                              "Generate Story",
                              style: googleTextStyle(
                                  20.sp, FontWeight.w600, Colors.white),
                            ),
                          ),
                        ],
                      ),
                      height: size.height * 0.13,
                      width: size.width * 0.17,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                            color: secondColor,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                  left: 50,
                                  child: Image.asset(
                                    "assets/images/orbit.png",
                                    scale: 1.5,
                                  )),
                              Positioned(
                                right: 50,
                                top: 30,
                                child: Text(
                                  "Start Orbit",
                                  style: googleTextStyle(
                                      20.sp, FontWeight.w600, Colors.white),
                                ),
                              ),
                            ],
                          ),
                          height: size.height * 0.13,
                          width: size.width * 0.17,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                            color: secondColor,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                  left: 100,
                                  bottom: 10,
                                  child: Image.asset(
                                    "assets/images/narrate.png",
                                    scale: 1.2,
                                  )),
                              Positioned(
                                left: 30,
                                top: 22,
                                child: Column(
                                  children: [
                                    Text(
                                      "Start",
                                      style: googleTextStyle(
                                          20.sp, FontWeight.w600, Colors.white),
                                    ),
                                    Text(
                                      "Story",
                                      style: googleTextStyle(
                                          20.sp, FontWeight.w600, Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          height: size.height * 0.13,
                          width: size.width * 0.17,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 40.w,
              ),
              Container(
                height: size.height * .75,
                width: size.width * 0.001,
                color: Colors.grey,
              ),
              SizedBox(
                width: 40.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(22)),
                    width: size.width * 0.5,
                    height: size.height * 0.75,
                    child: GoogleMap(
                      myLocationEnabled: false,
                      zoomGesturesEnabled: false,
                      mapType: MapType.satellite,
                      myLocationButtonEnabled: false,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controllerGoogleMap.complete(controller);
                        newGoogleMapController = controller;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
