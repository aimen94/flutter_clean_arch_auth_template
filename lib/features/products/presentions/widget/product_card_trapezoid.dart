import 'package:flutter/cupertino.dart';
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

class ProductCardTrapezoid extends StatefulWidget {
  final int productId;
  final String title;
  final String price;
  final String imageUrl;
  final double rating;

  const ProductCardTrapezoid({
    super.key,
    required this.productId,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });

  @override
  State<ProductCardTrapezoid> createState() => _ProductCardTrapezoidState();
}

class _ProductCardTrapezoidState extends State<ProductCardTrapezoid> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160.w,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // الشكل المائل (شبه منحرف)
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
              // الصورة
              InkWell(
                onTap: () {
                  context.push('/productDetail/${widget.productId}');
                },
                child: Positioned(
                  top: -(120 * 0.2).h,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 120.h,
                    child: Image.network(widget.imageUrl, fit: BoxFit.contain),
                  ),
                ),
              ),
              // ✨ 5. إضافة أيقونة "المفضلة" (قلب)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: IconButton(
                  icon: Icon(
                    isFavorite
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  // ✨ تعديل 5: استخدام setState لتحديث الواجهة عند تغيير isFavorite
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: 150.w,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                widget.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          AddVerticalSpace(4),

          // السعر
          Text(
            "\$ ${widget.price}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
