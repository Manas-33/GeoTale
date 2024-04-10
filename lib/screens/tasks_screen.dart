import 'package:ai_app/components/connection_flag.dart';
import 'package:ai_app/components/drawer.dart';
import 'package:ai_app/connections/lg.dart';
import 'package:ai_app/constants.dart';
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width*0.85,
                      child: Text("""This application leverages the capabilities of Gemini, a large language model, in conjunction with Google Earth to create an immersive interactive storytelling experience. By seamlessly integrating the power of natural language generation with the vast geographical knowledge of Google Earth, this application unlocks a world of possibilities for creative exploration and education.
                    
                    Here's an elaboration of the process:
                    Location Selection:
                    Users interact with the Liquid Galaxy globe, selecting a specific location that piques their interest.
                    Story Generation:
                    Once a location is chosen, Gemini's language model springs into action. Drawing on its vast knowledge and understanding of the world's diverse regions, cultures, and histories, Gemini crafts a unique short story tailored to the selected location.
                    Story Presentation:
                    The generated story is not merely displayed as text. Instead, it is skillfully interwoven with the location on the Liquid Galaxy screen, creating a captivating visual and narrative experience. The story unfolds as users explore the selected region, with text and visuals harmoniously complementing each other.
                    Interactive Exploration:
                    The application encourages users to actively explore the globe, discovering new stories and perspectives from various corners of the world. As they navigate from one location to another, Gemini continues to generate fresh narratives, ensuring a continuous and engaging storytelling journey.
                    Educational Value:
                    Beyond entertainment, this application holds educational potential. It presents a unique way to learn about different cultures, historical events, and geographical landmarks. By weaving stories around real-world locations, it fosters a deeper understanding and appreciation of the world's diverse heritage.
                    This interactive storytelling experience aims to ignite curiosity, inspire creativity, and provide a novel way to engage with the wonders of our planet. We invite you to embark on this enchanting adventure and discover the limitless possibilities that lie within the fusion of language and geography.
                    
                    """,style: googleTextStyle(20.sp, FontWeight.w500, Colors.cyan),),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
