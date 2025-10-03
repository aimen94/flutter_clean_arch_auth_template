import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ويدجت للفاصل العمودي
class AddVerticalSpace extends StatelessWidget {
  final double height;

  const AddVerticalSpace(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height.h);
  }
}
