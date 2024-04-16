import 'package:ai_app/components/cities.dart';
import 'package:ai_app/components/connection_flag.dart';
import 'package:ai_app/components/drawer.dart';
import 'package:ai_app/connections/lg.dart';
import 'package:ai_app/constants.dart';
import 'package:ai_app/connections/lg.dart' as Lg;
import 'package:ai_app/screens/info_screen.dart';
import 'package:ai_app/screens/settings.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

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
  bool isCity = false;
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: AppDrawer(size: size),
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(135.0),
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
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: secondColor),
                        child: Image.asset(
                          "assets/images/connection.png",
                          color: Colors.white,
                        )),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingsPage(),
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 70.h,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(27, 0, 0, 0),
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
                        fontSize: 55.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: AnimatedTextKit(
                      pause: Duration(milliseconds: 2000),
                      repeatForever: true,
                      animatedTexts: [
                        TypewriterAnimatedText('Discover the city through AI',
                            speed: Duration(milliseconds: 60)),
                      ],
                      onTap: () {
                        print("Tap Event");
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 60.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: size.width * .8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: GooglePlaceAutoCompleteTextField(
                        textStyle: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              foreground: Paint()
                                ..shader = LinearGradient(
                                  colors: <Color>[
                                    const Color.fromARGB(255, 66, 160, 237),
                                    const Color.fromARGB(255, 106, 225, 110)
                                  ],
                                ).createShader(
                                    Rect.fromLTWH(0.0, 0.0, 400.0, 70.0)),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        textEditingController: _textEditingController,
                        googleAPIKey: apiKey!,
                        boxDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25)),
                        inputDecoration: InputDecoration(
                            hintStyle: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                foreground: Paint()
                                  ..shader = LinearGradient(
                                    colors: <Color>[
                                      const Color.fromARGB(255, 66, 160, 237),
                                      const Color.fromARGB(255, 106, 225, 110)
                                    ],
                                  ).createShader(
                                      Rect.fromLTWH(0.0, 0.0, 800.0, 70.0)),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            hintText: "Enter name of the city",
                            prefixIcon: Container(
                                margin:
                                    EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 14.h),
                                child: Icon(
                                  Icons.search,
                                  size: 22,
                                )),
                            prefixIconConstraints:
                                BoxConstraints(maxHeight: 50.h),
                            isDense: true,
                            contentPadding: EdgeInsets.only(
                                top: 15.h, right: 30.w, bottom: 15.h),
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ))),
                        debounceTime: 800,
                        isLatLngRequired: true,
                        getPlaceDetailWithLatLng: (Prediction prediction) {},
                        itemClick: (Prediction prediction) async {
                          print(prediction.types);
                          for (var type in prediction.types!) {
                            if (type == "locality" ||
                                type == "administrative_area_level_3") {
                              isCity = true;
                              break;
                            }
                          }
                          if (isCity) {
                            await Future.delayed(Duration(seconds: 1));
                            print("It is a city");
                            print("placeDetails 2nd ${prediction.description}");
                            List<String> components =
                                prediction.description!.split(',');
                            String cityName = components[0].trim();
                            String secondName = components.length > 1
                                ? components[1].trim()
                                : "";

                            print("City Name: $cityName");
                            print("Country Name: $secondName");
                            print("City Name: $cityName");
                            double cityLat = double.parse(prediction.lat!);
                            double cityLong = double.parse(prediction.lng!);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CityInformation(
                                cityName: cityName,
                                sName:secondName,
                                cityLat: cityLat,
                                cityLong: cityLong,
                              ),
                            ));
                          } else {
                            ToastService.showErrorToast(
                              context,
                              length: ToastLength.medium,
                              expandedHeight: 100,
                              message: "It is not a city, try again!",
                            );
                            print("It is not a city, try again later");
                          }
                          setState(() {
                            isCity = false;
                          });
                        },
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
                                    Text(prediction
                                            .structuredFormatting!.mainText ??
                                        ""),
                                    SizedBox(height: 2.h),
                                    Text(prediction.structuredFormatting!
                                            .secondaryText ??
                                        ""),
                                  ],
                                ))
                              ],
                            ),
                          );
                        },
                        seperatedBuilder: const Divider(),
                        isCrossBtnShown: true,
                      ),
                    ),
                    // ElevatedButton(
                    //     style: ButtonStyle(
                    //       backgroundColor:
                    //           MaterialStateProperty.all<Color>(secondColor),
                    //     ),
                    //     onPressed: () {
                    //       Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (context) => CityInformation(),
                    //       ));
                    //     },
                    //     child: Container(
                    //       // color: Colors.blue,
                    //       alignment: Alignment.center,
                    //       width: size.width * .1,
                    //       height: size.height * 0.07,
                    //       child: Text(
                    //         "Generate",
                    //         style: GoogleFonts.openSans(
                    //           textStyle: TextStyle(
                    //             color: Colors.white,
                    //             fontSize: 18.sp,
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //         ),
                    //       ),
                    //     )),
                  ],
                ),
                SizedBox(
                  height: 50.h,
                ),
                Container(
                  padding: EdgeInsets.only(left: 30),
                  alignment: Alignment.centerLeft,
                  child: Text("List of some cities -",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ),
                SizedBox(
                  height: 50.h,
                ),
                RecomendCities(),
              ],
            ),
          ),
        ));
  }
}
