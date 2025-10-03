import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/constants/widgets/horizontal_space.dart';
import 'package:flutter_application_2/core/constants/widgets/vertical_space.dart';
import 'package:flutter_application_2/features/auth/presentions/cubit/auth_cubit.dart';
import 'package:flutter_application_2/features/auth/presentions/cubit/auth_state.dart';
import 'package:flutter_application_2/features/home/presentions/widgets/categories_section.dart';
import 'package:flutter_application_2/features/home/presentions/widgets/featured_products_section.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/featured_products/featured_products_state.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/products_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final List<Color> _colors = [
    Color(0xffffe2f7),
    Color(0xfffffbeb),
    Color(0xffe0f7fa),
    Color(0xfff3e5f5),
    Color(0xfffbe9e7),
  ];

  @override
  Widget build(BuildContext context) {
    // 2. تغليف الـ Scaffold بـ BlocListener
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      context.push('/search-products');
                    },
                    icon: Icon(Icons.search, size: 32.sp),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8.0.sp),
                    child: SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: Image.asset(
                        'assets/icons/Notification.png',
                        height: 24.h,
                        width: 24.w,
                        color: Colors.black,
                      ),

                      //  CircleAvatar(
                      //   radius: 24.r,
                      //   backgroundColor: Colors.grey.shade200,
                      //   backgroundImage: Image.asset(
                      //     'assets/icons/Notification.png',
                      //     height: 24.h,
                      //     width: 24.w,
                      //   ).image,
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 393.w,
                height: 196.h,
                child: PageView.builder(
                  //itemExtent: 500.w,
                  //shrinkWrap: true,
                  controller: PageController(
                    viewportFraction: 0.8, // يخلي العنصر في النص
                  ),
                  scrollDirection: Axis.horizontal,
                  reverse: false,
                  itemBuilder: (context, index) {
                    return SvgPicture.asset(
                      'assets/images/discount1.svg',
                      fit: BoxFit.contain,
                    );
                  },
                  itemCount: 5,
                ),
              ),

              CategoriesSection(),

              SizedBox(
                height: 38.h,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h, right: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Exclusive Offers',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FeaturedProductsSection(),
              Text(
                'Recantly Viewed',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              AddVerticalSpace(16.h),
              SizedBox(
                height: 177.h,
                child: GridView.builder(
                  itemCount: 8,
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                  ),
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.only(right: 12.w),
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: _colors[index % _colors.length].withValues(
                        alpha: 0.4,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/MacBook.png',
                              height: 100.h,
                              width: 100.w,
                            ),
                          ),
                          AddVerticalSpace(12.h),
                          Text(
                            'Product Title',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          AddVerticalSpace(2),
                          Text(
                            '\$99.99',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
