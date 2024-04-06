import 'package:ai_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * .1,
                      // padding: const EdgeInsets.only(bottom: 25),
                      child: Image.asset(
                        'assets/images/logo.png',
                        scale: 4.3.h,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Container(
                    //       child: Text(
                    //         "GeoTale",
                    //         style: GoogleFonts.openSans(
                    //           textStyle: TextStyle(
                    //             color: Colors.black,
                    //             letterSpacing: .5,
                    //             fontSize: 30.sp,
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                actions: []),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              SizedBox(
                height: 180.h,
              ),
              Container(
                child: Text(
                  "Text",
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      letterSpacing: .5,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
