import 'package:ai_app/components/connection_flag.dart';
import 'package:ai_app/components/drawer.dart';
import 'package:ai_app/connections/lg.dart';
import 'package:ai_app/constants.dart';
import 'package:ai_app/screens/home_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutScreen extends StatefulWidget {
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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
                      padding: const EdgeInsets.fromLTRB(0, 0, 45, 0),
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
                  children: [
                    Text(
                      "Explore and Discover with GeoTale",
                      style:
                          googleTextStyle(30.sp, FontWeight.w500, Colors.white),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: Text(
                        "GeoTale is your personal guide to discovering the world's cities and their fascinating tales. With just a simple search, you can explore a city and uncover its hidden gems. ",
                        style: googleTextStyle(
                            22.sp, FontWeight.w500, Colors.cyan),
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Container(
                      height: size.height * 0.45,
                      width: size.width * 0.4,
                      child: CarouselSlider(
                          items: [
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
                                      "Technology Used",
                                      style: googleTextStyle(
                                          23.sp, FontWeight.w700, Colors.white),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                      width: size.width * 0.35,
                                      child: Text(
                                        "This app utilizes state-of-the-art AI technology to bring each destination to life. Gemini AI generates detailed information about the city and its points of interest, while Deepgram AI provides captivating narration for your journey. ",
                                        style: googleTextStyle(17.sp,
                                            FontWeight.w500, Colors.cyan),
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    )
                                  ],
                                ),
                              ),
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
                                      "Orbiting Funtions",
                                      style: googleTextStyle(
                                          23.sp, FontWeight.w700, Colors.white),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                      width: size.width * 0.35,
                                      child: Text(
                                        "One of the key features of GeoTale is the ability to create your own orbit. This immersive experience takes you on a tour of the city's POIs, with informative flashcards and narration to guide you. It's like having your own personal rig to explore the world.",
                                        style: googleTextStyle(17.sp,
                                            FontWeight.w500, Colors.cyan),
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    )
                                  ],
                                ),
                              ),
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
                                      "Awesome Storytelling",
                                      style: googleTextStyle(
                                          23.sp, FontWeight.w700, Colors.white),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                      width: size.width * 0.35,
                                      child: Text(
                                        "But that's not all. GeoTale also offers a unique storytelling feature. Choose from suggested themes and let Gemini AI weave a captivating story about your chosen city. It's a whole new way to learn about a place and its culture. ",
                                        style: googleTextStyle(17.sp,
                                            FontWeight.w500, Colors.cyan),
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    )
                                  ],
                                ),
                              ),
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
                                      "Educative Experience",
                                      style: googleTextStyle(
                                          23.sp, FontWeight.w700, Colors.white),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                      width: size.width * 0.35,
                                      child: Text(
                                        "GeoTale, aims to inspire curiosity and provide a unique way to explore the world. It's perfect for those who want to discover new places, learn about different cultures, or simply enjoy a captivating story.",
                                        style: googleTextStyle(17.sp,
                                            FontWeight.w500, Colors.cyan),
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    )
                                  ],
                                ),
                              ),
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
                                      "In App Exploration",
                                      style: googleTextStyle(
                                          23.sp, FontWeight.w700, Colors.white),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                      width: size.width * 0.35,
                                      child: Text(
                                        "Don't have access to a Liquid Galaxy rig? No problem! GeoTale offers a built-in demonstration, allowing you to explore cities and their stories even without an external connection",
                                        style: googleTextStyle(17.sp,
                                            FontWeight.w500, Colors.cyan),
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                          options: CarouselOptions(
                            enlargeCenterPage: true,
                            height: 700,
                            initialPage: 0,
                            scrollDirection: Axis.horizontal,
                            autoPlayInterval:
                                const Duration(milliseconds: 5000),
                            autoPlay: false,
                          )),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: Text(
                        "So, whether you're a traveler at heart or just looking for a fun way to pass the time, let GeoTale take you on an unforgettable journey.",
                        style: googleTextStyle(
                            22.sp, FontWeight.w500, Colors.cyan),
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.justify,
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
