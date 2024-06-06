import 'package:ai_app/constants.dart';
import 'package:ai_app/screens/home_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitality/vitality.dart';
Future<void> main() async {
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
            debugShowCheckedModeBanner: false,
            home: AnimatedSplashScreen(
              backgroundColor: backgroundColor,
              nextScreen: HomeScreen(),
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
