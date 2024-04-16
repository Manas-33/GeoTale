import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ai_app/components/connection_flag.dart';
import 'package:ai_app/components/drawer.dart';
import 'package:ai_app/components/info_card.dart';
import 'package:ai_app/connections/gemini.dart';
import 'package:ai_app/connections/lg.dart';
import 'package:ai_app/constants.dart';
import 'package:ai_app/models/city.dart';
import 'package:ai_app/models/orbit.dart';
import 'package:ai_app/models/place.dart';
import 'package:ai_app/screens/tasks_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:group_button/group_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:http/http.dart' as http;

class CityInformation extends StatefulWidget {
  final String cityName;
  final String sName;
  final double cityLat;
  final double cityLong;

  const CityInformation(
      {super.key,
      required this.cityName,
      required this.cityLat,
      required this.cityLong, required this.sName});
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
    city = await Gemini().getCoordinates(cityname,widget.sName);
    setState(() {
      isLoading = false;
    });
    initCards(city);
  }

  @override
  void initState() {
    super.initState();
    lg = LGConnection();
    _connectToLG();
    getCityData();
  }

  bool isDesc = true;
  List<Widget> carouselCards = [];
  void initCards(City city) {
    int length = city.places.length;
    for (int i = 0; i < length; i++) {
      Place place = city.places[i];
      carouselCards.add(InformationCard(
          size: MediaQuery.of(context).size,
          placeName: place.name,
          placeDescription: place.description));
    }
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

    textToVoice(String content) async {
      final url =
          Uri.parse("https://api.deepgram.com/v1/speak?model=aura-zeus-en");
      String voiceApiKey = dotenv.env['DEEPGRAM_API_KEY']!;
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Token $voiceApiKey"
          },
          body: jsonEncode({"text": content}));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/textToSpeech.wav');
        await file.writeAsBytes(bytes);
        final player = AudioPlayer();
        await player.play(DeviceFileSource(file.path));
      }
    }

    CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(widget.cityLat, widget.cityLong),
      zoom: 11,
    );
    final Completer<GoogleMapController> _controllerGoogleMap =
        Completer<GoogleMapController>();
    late GoogleMapController newGoogleMapController;

    void moveCameraToNewPosition(
        LatLng newPosition, double zoom, double bearing) {
      newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: newPosition, zoom: zoom, tilt: 60, bearing: bearing))
          // newLatLngZoom(newPosition, zoom)
          );
    }

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
              actions: [
                Container(
                  padding: EdgeInsets.only(right: 30),
                  child: Row(
                    children: [
                      isLoading
                          ? Row(
                              children: [
                                CircularProgressIndicator(
                                  strokeAlign: 2,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 15,
                                )
                              ],
                            )
                          : Row(
                              children: [
                                Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                SizedBox(
                                  width: 15,
                                )
                              ],
                            ),
                      Text(
                        isLoading
                            ? "Generating Content"
                            : "AI Content Generated",
                        style: isLoading
                            ? googleTextStyle(
                                17.sp, FontWeight.w700, Colors.red)
                            : googleTextStyle(
                                20.sp, FontWeight.w700, Colors.green),
                      ),
                      IconButton(
                        icon: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Color.fromARGB(255, 53, 161, 255)),
                            child: Image.asset(
                              "assets/images/tasks.png",
                              color: Colors.white,
                            )),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TaskScreen(),
                          ));
                        },
                      ),
                      SizedBox(
                        width: 30.h,
                      ),
                    ],
                  ),
                )
              ],
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
                            "${widget.cityName}, ${widget.sName}",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 30.w,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                isDesc = true;
                              });
                              print(isDesc);
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: isDesc
                                      ? Color.fromARGB(255, 106, 255, 215)
                                      : Colors.white,
                                ),
                                alignment: Alignment.center,
                                width: size.width * 0.14,
                                height: 55,
                                child: Text(
                                  "Story",
                                  style: googleTextStyle(
                                      20.sp, FontWeight.w600, secondColor),
                                ))),
                        SizedBox(
                          width: 25.w,
                        ),
                        GestureDetector(
                            onTap: isLoading
                                ? () {
                                    ToastService.showErrorToast(
                                      context,
                                      isClosable: true,
                                      length: ToastLength.medium,
                                      expandedHeight: 100,
                                      message: "Content is being generated!",
                                    );
                                  }
                                : () {
                                    setState(() {
                                      isDesc = false;
                                    });
                                    print(isDesc);
                                  },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: isDesc
                                      ? Colors.white
                                      : Color.fromARGB(255, 106, 255, 215),
                                ),
                                alignment: Alignment.center,
                                width: size.width * 0.14,
                                height: 55,
                                child: Text(
                                  "Description",
                                  style: googleTextStyle(
                                      20.sp, FontWeight.w600, Colors.black),
                                ))),
                      ],
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    isDesc
                        ? Column(
                            children: [
                              Text(
                                "Customize your story!",
                                style: googleTextStyle(
                                    25.sp, FontWeight.w600, Colors.cyan),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                "Choose some keywords for the story -",
                                style: googleTextStyle(
                                    17.sp, FontWeight.w500, Colors.white),
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
                                          descriptionsChosen
                                              .remove(buttonsValue[index]);
                                        } else {
                                          descriptionsChosen
                                              .add(buttonsValue[index]);
                                        }
                                      } else if (descriptionsChosen
                                          .contains(buttonsValue[index])) {
                                        descriptionsChosen
                                            .remove(buttonsValue[index]);
                                      } else {
                                        ToastService.showErrorToast(
                                          context,
                                          isClosable: true,
                                          length: ToastLength.medium,
                                          expandedHeight: 100,
                                          message:
                                              "Maximum Three can be selected!",
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
                                      mainGroupAlignment:
                                          MainGroupAlignment.start,
                                      crossGroupAlignment:
                                          CrossGroupAlignment.start,
                                      groupRunAlignment:
                                          GroupRunAlignment.start,
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
                              SizedBox(
                                height: 22.h,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: size.width * 0.17,
                                    height: 120,
                                    child: AnimatedTapBuilder(
                                      onTap: isLoading
                                          ? () {
                                              ToastService.showErrorToast(
                                                context,
                                                isClosable: true,
                                                length: ToastLength.medium,
                                                expandedHeight: 100,
                                                message:
                                                    "Content is being generated!",
                                              );
                                            }
                                          : () async {
                                              for (var i = 0; i < 2; i++) {
                                                String placesdata = Orbit()
                                                    .generateOrbit(city.places);
                                                String content = Orbit()
                                                    .buildOrbit(placesdata);
                                                print(content);
                                                await lg.buildOrbit(content);
                                                await Future.delayed(Duration(seconds: 1));
                                              }

                                              for (int i = 0;
                                                  i < city.places.length;
                                                  i++) {
                                                textToVoice(
                                                    city.places[i].description);
                                                await lg.openBalloon(
                                                    "orbitballoon",
                                                    city.places[i].name,
                                                    city.name,
                                                    240,
                                                    city.places[i].description,
                                                    city.places[i].coordinates
                                                        .latitude,
                                                    city.places[i].coordinates
                                                        .longitude);
                                                double bearing = 0;
                                                int orbit = 0;
                                                while (orbit <= 36) {
                                                  if (bearing >= 360)
                                                    bearing -= 360;
                                                  moveCameraToNewPosition(
                                                      LatLng(
                                                          city
                                                              .places[i]
                                                              .coordinates
                                                              .latitude,
                                                          city
                                                              .places[i]
                                                              .coordinates
                                                              .longitude),
                                                      17,
                                                      bearing);
                                                  bearing += 10;
                                                  orbit += 1;
                                                  await Future.delayed(Duration(
                                                      milliseconds: 500));
                                                }

                                                await Future.delayed(
                                                    Duration(seconds: 2));
                                              }
                                            },
                                      builder: (context, state, isFocused,
                                          cursorLocation, cursorAlignment) {
                                        cursorAlignment =
                                            state == TapState.pressed
                                                ? Alignment(-cursorAlignment.x,
                                                    -cursorAlignment.y)
                                                : Alignment.center;
                                        return AnimatedContainer(
                                          height: 200,
                                          transformAlignment: Alignment.center,
                                          transform: Matrix4.rotationX(
                                              -cursorAlignment.y * 0.2)
                                            ..rotateY(cursorAlignment.x * 0.2)
                                            ..scale(
                                              state == TapState.pressed
                                                  ? 0.94
                                                  : 1.0,
                                            ),
                                          duration:
                                              const Duration(milliseconds: 200),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.black,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Stack(
                                              fit: StackFit.passthrough,
                                              children: [
                                                AnimatedOpacity(
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  opacity:
                                                      state == TapState.pressed
                                                          ? 0.6
                                                          : 0.8,
                                                  child: Image.asset(
                                                    'assets/images/orbit1.jpg',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                AnimatedContainer(
                                                  height: 200,
                                                  transformAlignment:
                                                      Alignment.center,
                                                  transform:
                                                      Matrix4.translationValues(
                                                    cursorAlignment.x * 3,
                                                    cursorAlignment.y * 3,
                                                    0,
                                                  ),
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  child: const Center(
                                                    child: Text(
                                                      'Start Orbit',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned.fill(
                                                  child: AnimatedAlign(
                                                    duration: const Duration(
                                                        milliseconds: 200),
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
                                                                        TapState
                                                                            .pressed
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
                                      onTap: () async {
                                        story = await Gemini().getStory(
                                            widget.cityName,
                                            getString(descriptionsChosen));
                                        print(story);
                                        await textToVoice(story);
                                      },
                                      builder: (context, state, isFocused,
                                          cursorLocation, cursorAlignment) {
                                        cursorAlignment =
                                            state == TapState.pressed
                                                ? Alignment(-cursorAlignment.x,
                                                    -cursorAlignment.y)
                                                : Alignment.center;
                                        return AnimatedContainer(
                                          height: 200,
                                          transformAlignment: Alignment.center,
                                          transform: Matrix4.rotationX(
                                              -cursorAlignment.y * 0.2)
                                            ..rotateY(cursorAlignment.x * 0.2)
                                            ..scale(
                                              state == TapState.pressed
                                                  ? 0.94
                                                  : 1.0,
                                            ),
                                          duration:
                                              const Duration(milliseconds: 200),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.black,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Stack(
                                              fit: StackFit.passthrough,
                                              children: [
                                                AnimatedOpacity(
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  opacity:
                                                      state == TapState.pressed
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
                                                  transformAlignment:
                                                      Alignment.center,
                                                  transform:
                                                      Matrix4.translationValues(
                                                    cursorAlignment.x * 3,
                                                    cursorAlignment.y * 3,
                                                    0,
                                                  ),
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  child: const Center(
                                                    child: Text(
                                                      'Narrate Story',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned.fill(
                                                  child: AnimatedAlign(
                                                    duration: const Duration(
                                                        milliseconds: 200),
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
                                                                        TapState
                                                                            .pressed
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
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: secondColor.withOpacity(0.5),
                                    borderRadius:
                                        BorderRadiusDirectional.circular(10)),
                                child: Container(
                                  width: size.width * 0.35,
                                  padding: EdgeInsets.all(30),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Description",
                                        style: googleTextStyle(23.sp,
                                            FontWeight.w700, Colors.white),
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      Container(
                                        width: size.width * 0.35,
                                        child: Text(
                                          city.description,
                                          style: googleTextStyle(17.sp,
                                              FontWeight.w500, Colors.cyan),
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.justify,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                "Places -",
                                style: googleTextStyle(
                                    23.sp, FontWeight.w700, Colors.white),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Container(
                                height: size.height * 0.5,
                                width: size.width * 0.35,
                                child: CarouselSlider(
                                    items: carouselCards,
                                    options: CarouselOptions(
                                      enlargeCenterPage: true,
                                      height: 700,
                                      initialPage: 0,
                                      scrollDirection: Axis.horizontal,
                                      autoPlayInterval:
                                          const Duration(milliseconds: 5000),
                                      autoPlay: false,
                                    )),
                              )
                            ],
                          )
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
              Stack(children: [
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
                Positioned(
                  bottom: 30.h,
                  left: 20.h,
                  child: GestureDetector(
                      onTap: () async {
                        for (int i = 0; i < city.places.length; i++) {
                          double bearing = 0;
                          int orbit = 0;
                          textToVoice(city.places[i].description);
                          while (orbit <= 36) {
                            if (bearing >= 360) bearing -= 360;
                            moveCameraToNewPosition(
                                LatLng(city.places[i].coordinates.latitude,
                                    city.places[i].coordinates.longitude),
                                17,
                                bearing);
                            bearing += 10;
                            orbit += 1;
                            await Future.delayed(Duration(milliseconds: 500));
                          }

                          await Future.delayed(Duration(seconds: 2));
                        }
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            "InApp Orbit",
                            style: googleTextStyle(
                                17.sp, FontWeight.w600, backgroundColor),
                          ))),
                ),
              ]),
            ],
          ),
        ));
  }
}
