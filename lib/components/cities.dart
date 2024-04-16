import 'package:ai_app/constants.dart';
import 'package:ai_app/screens/info_screen.dart';
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
              cityName: "London",
              countryName: "England",
              imageName: "london.jpg",
              cityLat: 51.5072,
              cityLong: 0.1276,
            ),
            SizedBox(
              height: 25.h,
            ),
            CityCard(
              cityName: "Tokyo",
              countryName: "Japan",
              imageName: "tokyo.jpeg",
              cityLat: 35.6764,
              cityLong: 139.6500,
            ),
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
              imageName: "newyork.jpg",
              cityLat: 40.7128,
              cityLong: -74.0060,
            ),
            SizedBox(
              height: 25.h,
            ),
            CityCard(
              cityName: "San Francisco",
              countryName: "America",
              imageName: "san.jpg",
              cityLat: 37.75281403597314, 
              cityLong: -122.44892964987395,
            ),
          ],
        ),
        SizedBox(
          width: 25.w,
        ),
        Column(
          children: [
            CityCard(
              cityName: "Paris",
              countryName: "France",
              imageName: "paris.jpg",
              cityLat: 48.8566,
              cityLong: 2.3522,
            ),
            SizedBox(
              height: 25.h,
            ),
            CityCard(
              cityName: "Delhi",
              countryName: "India",
              imageName: "delhi.jpeg",
              cityLat: 28.7041,
              cityLong: 77.1025,
            ),
          ],
        )
      ],
    );
  }
}

class CityCard extends StatelessWidget {
  final String cityName;
  final double cityLat;
  final double cityLong;
  final String imageName;
  final String countryName;

  const CityCard({
    super.key,
    required this.cityName,
    required this.countryName,
    required this.imageName,
    required this.cityLat,
    required this.cityLong,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CityInformation(
            cityName: cityName,
            sName: countryName,
            cityLat: cityLat,
            cityLong: cityLong,
          ),
        ));
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
