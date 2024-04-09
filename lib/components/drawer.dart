import 'package:ai_app/constants.dart';
import 'package:ai_app/screens/about_screen.dart';
import 'package:ai_app/screens/home_screen.dart';
import 'package:ai_app/screens/settings.dart';
import 'package:ai_app/screens/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: size.width * .35,
      backgroundColor: secondColor,
      child: ListView(
        children: [
          SizedBox(
            height: 60.h,
          ),
          Column(
            children: [
              Image.asset(
                "assets/images/logoplain.png",
                scale: 4,
              ),
              SizedBox(
                height: 15.h,
              ),
              Image.asset(
                "assets/images/logo2.png",
                scale: 4,
              ),
            ],
          ),
          SizedBox(
            height: 80.h,
          ),
          ListTile(
            title: Container(
              padding: EdgeInsets.only(left: 80),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/home.png",
                    // color: Colors.white,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                    'Home',
                    style:
                        googleTextStyle(20.sp, FontWeight.w500, Colors.white),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));
            },
          ),
          Divider(
            color: Colors.white.withOpacity(0.5),
            indent: 50,
            thickness: 0.5,
            endIndent: 50,
          ),
          ListTile(
            title: Container(
              padding: EdgeInsets.only(left: 80),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/tasks.png",
                    // color: Colors.white,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                    'Liquid Galaxy Tasks',
                    style:
                        googleTextStyle(20.sp, FontWeight.w500, Colors.white),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TaskScreen(),
              ));
            },
          ),
          Divider(
            color: Colors.white.withOpacity(0.5),
            indent: 50,
            thickness: 0.5,
            endIndent: 50,
          ),
          ListTile(
            title: Container(
              padding: EdgeInsets.only(left: 80),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/connection.png",
                    // color: Colors.white,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                    'Connection Manager',
                    style:
                        googleTextStyle(20.sp, FontWeight.w500, Colors.white),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingsPage(),
              ));
            },
          ),
          Divider(
            color: Colors.white.withOpacity(0.5),
            indent: 50,
            thickness: 0.5,
            endIndent: 50,
          ),
          ListTile(
            title: Container(
              padding: EdgeInsets.only(left: 80),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/about.png",
                    // color: Colors.white,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                    'About',
                    style:
                        googleTextStyle(20.sp, FontWeight.w500, Colors.white),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AboutScreen(),
              ));
            },
          ),
          Divider(
            color: Colors.white.withOpacity(0.5),
            indent: 50,
            thickness: 0.5,
            endIndent: 50,
          ),
        ],
      ),
    );
  }
}
