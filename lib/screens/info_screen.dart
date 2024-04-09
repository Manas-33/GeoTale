import 'dart:async';
import 'package:ai_app/components/connection_flag.dart';
import 'package:ai_app/components/drawer.dart';
import 'package:ai_app/connections/gemini.dart';
import 'package:ai_app/connections/lg.dart';
import 'package:ai_app/constants.dart';
import 'package:ai_app/models/city.dart';
import 'package:ai_app/models/orbit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:group_button/group_button.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toasty_box.dart';

class CityInformation extends StatefulWidget {
  final String cityName;
  final double cityLat;
  final double cityLong;

  const CityInformation(
      {super.key,
      required this.cityName,
      required this.cityLat,
      required this.cityLong});
  @override
  State<CityInformation> createState() => CityInformationState();
}

class CityInformationState extends State<CityInformation> {
  bool connectionStatus = false;
  late LGConnection lg;
  String story = "";
  bool isLoading = true;
  List<String> descriptionsChosen = [];
  Future<void> _connectToLG() async {
    bool? result = await lg.connectToLG();
    setState(() {
      connectionStatus = result!;
    });
  }

  late City city;

  getCityData() async {
    String cityname = widget.cityName;
    city = await Gemini().getCoordinates(cityname);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    lg = LGConnection();
    _connectToLG();
    getCityData();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    List<String> buttonsValue = [
      "Geographic",
      "Exciting",
      "Historic",
      "Scenic",
      "Cultural",
      "Fascinating",
    ];
    String getString(List<String> descriptions) {
      String result = "";
      for (int i = 0; i < descriptions.length; ++i) {
        result += "${descriptions[i]} ";
      }
      print(result);
      return result;
    }

    CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(widget.cityLat, widget.cityLong),
      zoom: 11,
    );
    final Completer<GoogleMapController> _controllerGoogleMap =
        Completer<GoogleMapController>();
    late GoogleMapController newGoogleMapController;

    var size = MediaQuery.of(context).size;
    return Scaffold(
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
                          height: 45.h,
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
                            // Container(
                            //   child: Image.asset(
                            //     'assets/images/logo.png',
                            //     scale: 4.5.h,
                            //   ),
                            // ),
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
                ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        Container(
                          width: size.width * 0.30,
                          child: Text(
                            widget.cityName,
                            style: googleTextStyle(
                                28.sp, FontWeight.w700, Colors.white),
                            // softWrap: true,
                            overflow: TextOverflow.clip,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      "Customize your story!",
                      style:
                          googleTextStyle(25.sp, FontWeight.w600, Colors.cyan),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Choose some keywords for the story -",
                      style:
                          googleTextStyle(17.sp, FontWeight.w500, Colors.white),
                    ),
                    SizedBox(
                      height: 35.h,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: size.width * 0.35,
                      child: GroupButton(
                          onSelected: (value, index, isSelected) {
                            if (descriptionsChosen.length < 3) {
                              if (descriptionsChosen
                                  .contains(buttonsValue[index])) {
                                descriptionsChosen.remove(buttonsValue[index]);
                              } else {
                                descriptionsChosen.add(buttonsValue[index]);
                              }
                            } else if (descriptionsChosen
                                .contains(buttonsValue[index])) {
                              descriptionsChosen.remove(buttonsValue[index]);
                            } else {
                              ToastService.showErrorToast(
                                context,
                                isClosable: true,
                                length: ToastLength.medium,
                                expandedHeight: 100,
                                message: "Maximum Three can be selected!",
                              );
                            }
                          },
                          maxSelected: 3,
                          options: GroupButtonOptions(
                            selectedShadow: const [],
                            selectedTextStyle: googleTextStyle(
                                15.sp, FontWeight.w700, Colors.cyan),
                            selectedColor: secondColor,
                            unselectedShadow: const [],
                            unselectedColor: Colors.cyan,
                            unselectedTextStyle: googleTextStyle(
                                15.sp, FontWeight.w700, secondColor),
                            selectedBorderColor: Colors.black,
                            unselectedBorderColor: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                            spacing: 12,
                            runSpacing: 12,
                            groupingType: GroupingType.wrap,
                            direction: Axis.horizontal,
                            buttonHeight: 60,
                            buttonWidth: 120,
                            mainGroupAlignment: MainGroupAlignment.start,
                            crossGroupAlignment: CrossGroupAlignment.start,
                            groupRunAlignment: GroupRunAlignment.start,
                            textAlign: TextAlign.center,
                            textPadding: EdgeInsets.zero,
                            alignment: Alignment.center,
                            elevation: 8,
                          ),
                          isRadio: false,
                          buttons: buttonsValue),
                    ),
                    SizedBox(
                      height: 45.h,
                    ),

                    Container(
                      alignment: Alignment.center,
                      width: size.width * 0.35,
                      child: Container(
                        width: size.width * 0.17,
                        height: 80,
                        child: AnimatedTapBuilder(
                          onTap: isLoading
                              ? null
                              : () async {
                                  // story = await Gemini().getStory(
                                  //     widget.cityName, getString(descriptionsChosen));
                                  print(city.places[0].coordinates.latitude);
                                },
                          builder: (context, state, isFocused, cursorLocation,
                              cursorAlignment) {
                            cursorAlignment = state == TapState.pressed
                                ? Alignment(
                                    -cursorAlignment.x, -cursorAlignment.y)
                                : Alignment.center;
                            return AnimatedContainer(
                              height: 200,
                              transformAlignment: Alignment.center,
                              transform:
                                  Matrix4.rotationX(-cursorAlignment.y * 0.2)
                                    ..rotateY(cursorAlignment.x * 0.2)
                                    ..scale(
                                      state == TapState.pressed ? 0.94 : 1.0,
                                    ),
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  fit: StackFit.passthrough,
                                  children: [
                                    AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        opacity: state == TapState.pressed
                                            ? 0.6
                                            : 0.8,
                                        child: Container(
                                          color: secondColor,
                                        )
                                        //     Image.asset(
                                        //   'assets/images/orbit1.jpg',
                                        //   fit: BoxFit.cover,
                                        // ),
                                        ),
                                    AnimatedContainer(
                                      height: 200,
                                      transformAlignment: Alignment.center,
                                      transform: Matrix4.translationValues(
                                        cursorAlignment.x * 3,
                                        cursorAlignment.y * 3,
                                        0,
                                      ),
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: const Center(
                                        child: Text(
                                          'Generate Story',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: AnimatedAlign(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        alignment: Alignment(-cursorAlignment.x,
                                            -cursorAlignment.y),
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.01),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(
                                                    state == TapState.pressed
                                                        ? 0.2
                                                        : 0.0),
                                                blurRadius: 200,
                                                spreadRadius: 130,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    Row(
                      children: [
                        Container(
                          width: size.width * 0.17,
                          height: 120,
                          child: AnimatedTapBuilder(
                            onTap: () async {
                                    String placesdata =
                                        Orbit().generateOrbit(city.places);
                                    String content =
                                        Orbit().buildOrbit(placesdata);
                                    print(content);
                                    await lg.buildOrbit(content);
                                  },
                            builder: (context, state, isFocused, cursorLocation,
                                cursorAlignment) {
                              cursorAlignment = state == TapState.pressed
                                  ? Alignment(
                                      -cursorAlignment.x, -cursorAlignment.y)
                                  : Alignment.center;
                              return AnimatedContainer(
                                height: 200,
                                transformAlignment: Alignment.center,
                                transform:
                                    Matrix4.rotationX(-cursorAlignment.y * 0.2)
                                      ..rotateY(cursorAlignment.x * 0.2)
                                      ..scale(
                                        state == TapState.pressed ? 0.94 : 1.0,
                                      ),
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    fit: StackFit.passthrough,
                                    children: [
                                      AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        opacity: state == TapState.pressed
                                            ? 0.6
                                            : 0.8,
                                        child: Image.asset(
                                          'assets/images/orbit1.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      AnimatedContainer(
                                        height: 200,
                                        transformAlignment: Alignment.center,
                                        transform: Matrix4.translationValues(
                                          cursorAlignment.x * 3,
                                          cursorAlignment.y * 3,
                                          0,
                                        ),
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: const Center(
                                          child: Text(
                                            'Start Orbit',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: AnimatedAlign(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          alignment: Alignment(
                                              -cursorAlignment.x,
                                              -cursorAlignment.y),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.01),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(state ==
                                                              TapState.pressed
                                                          ? 0.2
                                                          : 0.0),
                                                  blurRadius: 200,
                                                  spreadRadius: 130,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Container(
                          width: size.width * 0.17,
                          height: 120,
                          child: AnimatedTapBuilder(
                            onTap: () {},
                            builder: (context, state, isFocused, cursorLocation,
                                cursorAlignment) {
                              cursorAlignment = state == TapState.pressed
                                  ? Alignment(
                                      -cursorAlignment.x, -cursorAlignment.y)
                                  : Alignment.center;
                              return AnimatedContainer(
                                height: 200,
                                transformAlignment: Alignment.center,
                                transform:
                                    Matrix4.rotationX(-cursorAlignment.y * 0.2)
                                      ..rotateY(cursorAlignment.x * 0.2)
                                      ..scale(
                                        state == TapState.pressed ? 0.94 : 1.0,
                                      ),
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    fit: StackFit.passthrough,
                                    children: [
                                      AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        opacity: state == TapState.pressed
                                            ? 0.6
                                            : 0.8,
                                        child:
                                            // Container(
                                            //   color: secondColor,
                                            // )
                                            Image.asset(
                                          'assets/images/story.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      AnimatedContainer(
                                        height: 200,
                                        transformAlignment: Alignment.center,
                                        transform: Matrix4.translationValues(
                                          cursorAlignment.x * 3,
                                          cursorAlignment.y * 3,
                                          0,
                                        ),
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: const Center(
                                          child: Text(
                                            'Narrate Story',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: AnimatedAlign(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          alignment: Alignment(
                                              -cursorAlignment.x,
                                              -cursorAlignment.y),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.01),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(state ==
                                                              TapState.pressed
                                                          ? 0.2
                                                          : 0.0),
                                                  blurRadius: 200,
                                                  spreadRadius: 130,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    // Row(
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () {},
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //           boxShadow: [
                    //             BoxShadow(
                    //               color: Colors.grey.withOpacity(0.2),
                    //               spreadRadius: 3,
                    //               blurRadius: 10,
                    //               offset:
                    //                   Offset(0, 0), // changes position of shadow
                    //             ),
                    //           ],
                    //           borderRadius: BorderRadius.circular(20),
                    //           color: secondColor,
                    //         ),
                    //         child: Stack(
                    //           children: [
                    //             Positioned(
                    //                 left: 50,
                    //                 child: Image.asset(
                    //                   "assets/images/orbit.png",
                    //                   scale: 1.5,
                    //                 )),
                    //             Positioned(
                    //               right: 50,
                    //               top: 30,
                    //               child: Text(
                    //                 "Start Orbit",
                    //                 style: googleTextStyle(
                    //                     20.sp, FontWeight.w600, Colors.white),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         height: size.height * 0.13,
                    //         width: size.width * 0.17,
                    //       ),
                    //     ),
                    //     SizedBox(width: 20.w),
                    //     GestureDetector(
                    //       onTap: () {},
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //           boxShadow: [
                    //             BoxShadow(
                    //               color: Colors.grey.withOpacity(0.2),
                    //               spreadRadius: 3,
                    //               blurRadius: 10,
                    //               offset:
                    //                   Offset(0, 0), // changes position of shadow
                    //             ),
                    //           ],
                    //           borderRadius: BorderRadius.circular(20),
                    //           color: secondColor,
                    //         ),
                    //         child: Stack(
                    //           children: [
                    //             Positioned(
                    //                 left: 100,
                    //                 bottom: 10,
                    //                 child: Image.asset(
                    //                   "assets/images/narrate.png",
                    //                   scale: 1.2,
                    //                 )),
                    //             Positioned(
                    //               left: 30,
                    //               top: 22,
                    //               child: Column(
                    //                 children: [
                    //                   Text(
                    //                     "Start",
                    //                     style: googleTextStyle(
                    //                         20.sp, FontWeight.w600, Colors.white),
                    //                   ),
                    //                   Text(
                    //                     "Story",
                    //                     style: googleTextStyle(
                    //                         20.sp, FontWeight.w600, Colors.white),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         height: size.height * 0.13,
                    //         width: size.width * 0.17,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
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
                    height: size.height * 0.725,
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

// class AnimatedStateButton extends StatelessWidget {
//   const AnimatedStateButton({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return 
//     Row(
//       children: [
//         Container(
//           width: size.width * 0.17,
//           height: 120,
//           child: AnimatedTapBuilder(
//             onTap: () async{
//               // await lg.buildOrbit();
//             },
//             builder:
//                 (context, state, isFocused, cursorLocation, cursorAlignment) {
//               cursorAlignment = state == TapState.pressed
//                   ? Alignment(-cursorAlignment.x, -cursorAlignment.y)
//                   : Alignment.center;
//               return AnimatedContainer(
//                 height: 200,
//                 transformAlignment: Alignment.center,
//                 transform: Matrix4.rotationX(-cursorAlignment.y * 0.2)
//                   ..rotateY(cursorAlignment.x * 0.2)
//                   ..scale(
//                     state == TapState.pressed ? 0.94 : 1.0,
//                   ),
//                 duration: const Duration(milliseconds: 200),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.black,
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Stack(
//                     fit: StackFit.passthrough,
//                     children: [
//                       AnimatedOpacity(
//                         duration: const Duration(milliseconds: 200),
//                         opacity: state == TapState.pressed ? 0.6 : 0.8,
//                         child:
//                             // Container(
//                             //   color: secondColor,
//                             // )
//                             Image.asset(
//                           'assets/images/orbit1.jpg',
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       AnimatedContainer(
//                         height: 200,
//                         transformAlignment: Alignment.center,
//                         transform: Matrix4.translationValues(
//                           cursorAlignment.x * 3,
//                           cursorAlignment.y * 3,
//                           0,
//                         ),
//                         duration: const Duration(milliseconds: 200),
//                         child: const Center(
//                           child: Text(
//                             'Start Orbit',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w800,
//                               fontSize: 25,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned.fill(
//                         child: AnimatedAlign(
//                           duration: const Duration(milliseconds: 200),
//                           alignment:
//                               Alignment(-cursorAlignment.x, -cursorAlignment.y),
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 200),
//                             width: 10,
//                             height: 10,
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.01),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.white.withOpacity(
//                                       state == TapState.pressed ? 0.2 : 0.0),
//                                   blurRadius: 200,
//                                   spreadRadius: 130,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         SizedBox(
//           width: 20.w,
//         ),
//         Container(
//           width: size.width * 0.17,
//           height: 120,
//           child: AnimatedTapBuilder(
//             onTap: () {},
//             builder:
//                 (context, state, isFocused, cursorLocation, cursorAlignment) {
//               cursorAlignment = state == TapState.pressed
//                   ? Alignment(-cursorAlignment.x, -cursorAlignment.y)
//                   : Alignment.center;
//               return AnimatedContainer(
//                 height: 200,
//                 transformAlignment: Alignment.center,
//                 transform: Matrix4.rotationX(-cursorAlignment.y * 0.2)
//                   ..rotateY(cursorAlignment.x * 0.2)
//                   ..scale(
//                     state == TapState.pressed ? 0.94 : 1.0,
//                   ),
//                 duration: const Duration(milliseconds: 200),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.black,
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Stack(
//                     fit: StackFit.passthrough,
//                     children: [
//                       AnimatedOpacity(
//                         duration: const Duration(milliseconds: 200),
//                         opacity: state == TapState.pressed ? 0.6 : 0.8,
//                         child:
//                             // Container(
//                             //   color: secondColor,
//                             // )
//                             Image.asset(
//                           'assets/images/story.jpg',
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       AnimatedContainer(
//                         height: 200,
//                         transformAlignment: Alignment.center,
//                         transform: Matrix4.translationValues(
//                           cursorAlignment.x * 3,
//                           cursorAlignment.y * 3,
//                           0,
//                         ),
//                         duration: const Duration(milliseconds: 200),
//                         child: const Center(
//                           child: Text(
//                             'Narrate Story',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w800,
//                               fontSize: 25,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned.fill(
//                         child: AnimatedAlign(
//                           duration: const Duration(milliseconds: 200),
//                           alignment:
//                               Alignment(-cursorAlignment.x, -cursorAlignment.y),
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 200),
//                             width: 10,
//                             height: 10,
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.01),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.white.withOpacity(
//                                       state == TapState.pressed ? 0.2 : 0.0),
//                                   blurRadius: 200,
//                                   spreadRadius: 130,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
