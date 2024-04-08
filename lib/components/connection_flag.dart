import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConnectionFlag extends StatelessWidget {
  ConnectionFlag({required this.status});
  final bool status;

  @override
  Widget build(BuildContext context) {
    Color color = status ? Colors.green : Colors.red;
    String label = status ? 'CONNECTED' : 'DISCONNECTED';
    return Container(
      padding: EdgeInsets.only(left: 77),
      height: 50,
      width: 200,
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: color,
            size: 15,
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            label,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w700, fontSize: 12.sp),
          )
        ],
      ),
    );
  }
}
