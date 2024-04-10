import 'package:ai_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class InformationCard extends StatelessWidget {
  final String placeName;
  final String placeDescription;
  const InformationCard({
    super.key,
    required this.size, required this.placeName, required this.placeDescription,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: secondColor.withOpacity(0.5),
          borderRadius:
              BorderRadiusDirectional
                  .circular(10)),
      child: Container(
        width: size.width * 0.35,
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Text(
              placeName,
              style: googleTextStyle(
                  23.sp,
                  FontWeight.w700,
                  Colors.white),
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              width: size.width * 0.35,
              child: Text(
                placeDescription,
                style: googleTextStyle(
                    17.sp,
                    FontWeight.w500,
                    Colors.cyan),
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
    );
  }
}
