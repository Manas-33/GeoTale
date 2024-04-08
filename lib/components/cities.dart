import 'package:ai_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecomendCities extends StatelessWidget {
  const RecomendCities({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CityCard(
                cityName: "Mumbai",
                countryName: "India",
                imageName: "mumbai.png"),
            SizedBox(
              height: 25.h,
            ),
            CityCard(
                cityName: "Tokyo",
                countryName: "Japan",
                imageName: "tokyo.jpeg"),
          ],
        ),
        SizedBox(
          width: 25.w,
        ),
        Column(
          children: [
            CityCard(
                cityName: "New York",
                countryName: "America",
                imageName: "newyork.jpg"),
            SizedBox(
              height: 25.h,
            ),
            CityCard(
                cityName: "London",
                countryName: "England",
                imageName: "london.jpg"),
          ],
        ),
        SizedBox(
          width: 25.w,
        ),
        Column(
          children: [
            CityCard(
                cityName: "Lleida",
                countryName: "Spain",
                imageName: "lleida.jpg"),
            SizedBox(
              height: 25.h,
            ),
            CityCard(
                cityName: "Paris",
                countryName: "France",
                imageName: "paris.jpg"),
          ],
        )
      ],
    );
  }
}

class CityCard extends StatelessWidget {
  final String cityName;
  final String imageName;
  final String countryName;

  const CityCard({
    super.key,
    required this.cityName,
    required this.countryName,
    required this.imageName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ///////////////
        print("hello");
      },
      child: Stack(children: [
        Container(
          clipBehavior: Clip.hardEdge,
          child: Image.asset("assets/images/$imageName", fit: BoxFit.cover),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 15,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          width: 300.w,
          height: 250.h,
        ),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black, Colors.transparent],
            ),
          ),
          width: 300.w,
          height: 250.h,
        ),
        Positioned(
          bottom: 25,
          right: 18,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              width: 50,
              height: 50,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
              )),
        ),
        Positioned(
          bottom: 25,
          left: 20,
          child: Column(
            children: [
              Text(
                cityName,
                style: googleTextStyle(17.sp, FontWeight.w600, Colors.white),
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_pin,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 5.h,
                  ),
                  Text(
                    countryName,
                    style:
                        googleTextStyle(13.sp, FontWeight.w400, Colors.white),
                  )
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}
