import 'package:ai_app/components/connection_flag.dart';
import 'package:ai_app/connections/lg.dart';
import 'package:ai_app/constants.dart';
import 'package:ai_app/connections/lg.dart' as Lg;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool connectionStatus = false;
  late LGConnection lg;
  final apiKey = dotenv.env['MAP_API_KEY'];
  TextEditingController _textEditingController = TextEditingController();
  // bool isCity = false;
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
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(),
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(125.0),
          child: Container(
            child: AppBar(
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
                      icon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 38, 25),
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: Column(
              children: [
                SizedBox(
                  height: 110.h,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                  // width: 250.0,
                  child: DefaultTextStyle(
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: <Color>[
                              const Color.fromARGB(255, 66, 160, 237),
                              const Color.fromARGB(255, 106, 225, 110)
                            ],
                          ).createShader(Rect.fromLTWH(0.0, 0.0, 800.0, 70.0)),
                        // color: Colors.white,
                        // letterSpacing: .5,
                        fontSize: 55.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: AnimatedTextKit(
                      pause: Duration(milliseconds: 2000),
                      repeatForever: true,
                      animatedTexts: [
                        TypewriterAnimatedText('Enter the name of the city',
                            speed: Duration(milliseconds: 60)),
                      ],
                      onTap: () {
                        print("Tap Event");
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Container(
                  // padding: EdgeInsets.only(left: 30, right: 30),
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  child: GooglePlaceAutoCompleteTextField(
                    textStyle: TextStyle(),
                    textEditingController: _textEditingController,
                    googleAPIKey: apiKey!,
                    boxDecoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(25)),
                    inputDecoration: InputDecoration(
                      // hintStyle: theme.textTheme.bodyLarge,
                      // hintText: widget.addressType == AddressType.PickUp
                      //     ? "Pick Up"
                      //     : "Drop",
                      prefixIcon: Container(
                          margin: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 14.h),
                          child: Icon(Icons.search)
                          // CustomImageView(
                          //     svgPath: ImageConstant.imgIconBlueGray60024x24)
                          ),
                      prefixIconConstraints: BoxConstraints(maxHeight: 50.h),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.only(top: 15.h, right: 30.w, bottom: 15.h),
                      // fillColor: appTheme.gray100,
                      filled: true,
                      border: InputBorder.none,
                    ),
                    debounceTime: 800,

                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (Prediction prediction) {
                      // this method will return latlng with place detail
                      // print("placeDetails 1st ${prediction.lng}");
                    }, // this callback is called when isLatLngRequired is true
                    itemClick: (Prediction prediction) {
                      print(prediction.types);
                      for (var type in prediction.types!) {
                        if (type == "locaility" ||
                            type == "administrative_area_level_3") {
                          print("It is a city ");
                          break;
                        }
                      }
                      // print(
                      //     "placeDetails 2nd ${prediction.description}");
                      // print(
                      //     "placeDetails 3rd ${prediction.description}");
                      // getPlaceAddressCoords(
                      //     prediction.placeId!, context);

                      // _textEditingController.text =
                      //     prediction.description ?? '';
                      // _textEditingController.selection =
                      //     TextSelection.fromPosition(
                      //   TextPosition(
                      //     offset: prediction.description != null
                      //         ? prediction.description!.length
                      //         : 0,
                      //   ),
                      // );

                      // if (widget.addressType == AddressType.PickUp) {
                      //   Provider.of<CourierViewModel>(context,
                      //           listen: false)
                      //       .updatePickUpLocationAddress(Address(
                      //           placeName: prediction.description!,
                      //           placeId: prediction.placeId,
                      //           latitude: latitude,
                      //           longitude: longitude));
                      // } else {
                      //   Provider.of<CourierViewModel>(context,
                      //           listen: false)
                      //       .updateDropLocationAddress(Address(
                      //           placeName: prediction.description!,
                      //           placeId: prediction.placeId,
                      //           latitude: latitude,
                      //           longitude: longitude));
                      // }
                    },
                    // if we want to make custom list item builder
                    itemBuilder: (context, index, Prediction prediction) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(
                              width: 7,
                            ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    prediction.structuredFormatting!.mainText ??
                                        ""),
                                SizedBox(height: 2.h),
                                Text(prediction
                                        .structuredFormatting!.secondaryText ??
                                    ""),
                              ],
                            ))
                          ],
                        ),
                      );
                    },
                    // if you want to add seperator between list items
                    seperatedBuilder: const Divider(),
                    // want to show close icon
                    isCrossBtnShown: true,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  padding: EdgeInsets.only(left: 30),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "List of some cities:",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          width: 250.w,
                          height: 250.h,
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Container(
                          width: 250.w,
                          height: 250.h,
                          color: Colors.white,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 25.w,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 250.w,
                          height: 250.h,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Container(
                          width: 250.w,
                          height: 250.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 25.w,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 250.w,
                          height: 250.h,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          width: 250.w,
                          height: 250.h,
                          color: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
