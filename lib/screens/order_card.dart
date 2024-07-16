import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String orderStatus;
  final String orderDate;

  const OrderCard({
    Key? key,
    required this.orderId,
    required this.orderStatus,
    required this.orderDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: $orderId',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.h),
            Text('Status: $orderStatus', style: TextStyle(fontSize: 16.sp)),
            SizedBox(height: 5.h),
            Text('Date: $orderDate', style: TextStyle(fontSize: 16.sp)),
          ],
        ),
      ),
    );
  }
}
