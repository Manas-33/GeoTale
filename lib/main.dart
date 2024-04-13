import 'package:ai_app/connections/gemini.dart';
import 'package:ai_app/constants.dart';
import 'package:ai_app/screens/about_screen.dart';
import 'package:ai_app/screens/home_screen.dart';
import 'package:ai_app/screens/info_screen.dart';
import 'package:ai_app/screens/settings.dart';
import 'package:ai_app/screens/voice_demo.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:vitality/models/WhenOutOfScreenMode.dart';
import 'package:vitality/vitality.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(ScreenUtilInit(
        designSize: const Size(1100, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
            home: AnimatedSplashScreen(
          backgroundColor: backgroundColor,
          nextScreen: HomeScreen()
          // CityInformation(cityName: "Mumbai",cityLat: 12.32,cityLong: 19.067,)
          ,
          splash: Stack(children: [
            Vitality.randomly(
              background: backgroundColor,
              maxOpacity: 0.6,
              minOpacity: 0.3,
              itemsCount: 45,
              enableXMovements: false,
              whenOutOfScreenMode: WhenOutOfScreenMode.Reflect,
              maxSpeed: 1.5,
              maxSize: 25,
              minSpeed: 0.5,
              randomItemsColors: [Colors.green],
              randomItemsBehaviours: [
                ItemBehaviour(shape: ShapeType.FilledCircle),
                ItemBehaviour(shape: ShapeType.DoubleStrokeCircle)
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    scale: 3,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Discover the world through AI",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.white,
                        letterSpacing: .5,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]),
          duration: 2000,
          splashTransition: SplashTransition.scaleTransition,
        ))));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var data = '';
  final apiKey = dotenv.env['API_KEY'];
  bool completed = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Demo"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          // height: double.infinity,
          child: Column(
            children: [
              Text("Output is:"),
              ElevatedButton(
                onPressed: () async {
                  var response = await Gemini().getStory("pune", "historic");
                  setState(() {
                    data = response;
                    completed = true;
                  });
                },
                child: Text("Generate"),
              ),
              if (completed)
                Builder(
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(data),
                    );
                  },
                ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => VoiceDemo()));
                  },
                  child: Text("click"))
            ],
          ),
        ),
      ),
    );
  }
}
