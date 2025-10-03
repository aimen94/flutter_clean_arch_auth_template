import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/constants/widgets/vertical_space.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TrapezoidClipper extends CustomClipper<Path> {
  final double topInsetRatio;

  TrapezoidClipper({required this.topInsetRatio});

  @override
  Path getClip(Size size) {
    final inset = size.width * topInsetRatio;
    return Path()
      ..moveTo(inset, 5)
      ..lineTo(size.width - inset, 6)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant TrapezoidClipper oldClipper) {
    return oldClipper.topInsetRatio != topInsetRatio;
  }
}

class ProductDetailsCardTrapezoid extends StatefulWidget {
  final int productId;
  final String title;
  final String price;
  final String imageUrl;
  final double rating;
  final List<String> images;

  const ProductDetailsCardTrapezoid({
    super.key,
    required this.productId,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.images,
  });

  @override
  State<ProductDetailsCardTrapezoid> createState() =>
      _ProductDetailsCardTrapezoidState();
}

class _ProductDetailsCardTrapezoidState
    extends State<ProductDetailsCardTrapezoid> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                clipper: TrapezoidClipper(topInsetRatio: 0.15),
                child: Container(
                  width: 120.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),
              ),

              // معرض الصور الأفقية مع مؤشر
              Positioned(
                top: -(120 * 0.2).h,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    SizedBox(
                      height: 150.h,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                widget.images[index],
                                fit: BoxFit.contain,
                                loadingBuilder:
                                    (
                                      BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.error_outline,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // مؤشر الصور
                    if (widget.images.length > 1)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(widget.images.length, (
                            index,
                          ) {
                            return Container(
                              width: 8.w,
                              height: 8.h,
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == index
                                    ? Colors.blue
                                    : Colors.grey.withOpacity(0.5),
                              ),
                            );
                          }),
                        ),
                      ),
                  ],
                ),
              ),

              // زر المفضلة
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.redAccent,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // العنوان
          SizedBox(
            width: 250.w,
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),

          AddVerticalSpace(12),

          // التقييم والسعر
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // التقييم
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 18.sp),
                  SizedBox(width: 4.w),
                  Text(
                    widget.rating.toString(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(width: 20.w),

              // السعر
              Text(
                "\$${widget.price}",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),

          AddVerticalSpace(16),

          // أزرار التحكم
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // زر مشاركة
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.share, size: 24.sp),
                style: IconButton.styleFrom(backgroundColor: Colors.grey[200]),
              ),

              SizedBox(width: 16.w),

              // زر إضافة إلى السلة
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.shopping_cart, size: 18.sp),
                label: Text("Add to Cart", style: TextStyle(fontSize: 14.sp)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
