// // import 'package:flutter/material.dart';
// // import 'package:flutter_application_2/features/products/presentions/cubit/product_detail/product_detail_cubit%20.dart';
// // import 'package:flutter_application_2/features/products/presentions/cubit/product_detail/products_detail_state.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';

// // class ProductDetailScreen extends StatefulWidget {
// //   const ProductDetailScreen({super.key});

// //   @override
// //   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// // }

// // class _ProductDetailScreenState extends State<ProductDetailScreen>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;
// //   late Animation<double> _opacityAnimation;
// //   bool _showOverlay = true;
// //   int _currentImageIndex = 0;
// //   final PageController _pageController = PageController();

// //   @override
// //   void initState() {
// //     super.initState();

// //     _controller = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 300),
// //     );

// //     _opacityAnimation = Tween<double>(
// //       begin: 1.0,
// //       end: 0.0,
// //     ).animate(_controller);

// //     // إخفاء العناصر بعد 5 ثواني
// //     Future.delayed(const Duration(seconds: 5), () {
// //       if (mounted) {
// //         _hideOverlay();
// //       }
// //     });
// //   }

// //   void _hideOverlay() {
// //     _controller.forward();
// //     setState(() {
// //       _showOverlay = false;
// //     });
// //   }

// //   void _showOverlayTemporarily() {
// //     setState(() {
// //       _showOverlay = true;
// //     });
// //     _controller.reverse();

// //     // إخفاء العناصر مرة أخرى بعد 5 ثواني
// //     Future.delayed(const Duration(seconds: 5), () {
// //       if (mounted && _showOverlay) {
// //         _hideOverlay();
// //       }
// //     });
// //   }

// //   void _changeImage(int index) {
// //     setState(() {
// //       _currentImageIndex = index;
// //     });
// //     _pageController.animateToPage(
// //       index,
// //       duration: const Duration(milliseconds: 300),
// //       curve: Curves.easeInOut,
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     _pageController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: _showOverlay
// //           ? AppBar(
// //               title: const Text('Product Details'),
// //               backgroundColor: Colors.white,
// //               foregroundColor: Colors.black,
// //               elevation: 0,
// //             )
// //           : null,
// //       body: BlocBuilder<ProductDetailCubit, ProductsDetailState>(
// //         builder: (context, state) {
// //           if (state.isLoading) {
// //             return const Center(child: CircularProgressIndicator());
// //           }

// //           if (state.errorMessage != null) {
// //             return Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Text(state.errorMessage!),
// //                   const SizedBox(height: 8),
// //                   ElevatedButton(
// //                     onPressed: () {
// //                       final productId =
// //                           ModalRoute.of(context)!.settings.arguments as int;
// //                       context.read<ProductDetailCubit>().fetchProductByID(
// //                         productId,
// //                       );
// //                     },
// //                     child: const Text('Retry'),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           }

// //           // التحقق من وجود المنتج والصور
// //           if (state.product == null) {
// //             return const Center(child: Text('Product not found.'));
// //           }

// //           // if (state.product!.images.isEmpty) {
// //           //   return const Center(child: Text('No images available.'));
// //           // }

// //           return Stack(
// //             children: [
// //               // معرض الصور الرئيسي
// //               GestureDetector(
// //                 onTap: _showOverlayTemporarily,
// //                 child: PageView.builder(
// //                   controller: _pageController,
// //                   itemCount: state.product!.images.length,
// //                   onPageChanged: (index) {
// //                     setState(() {
// //                       _currentImageIndex = index;
// //                     });
// //                   },
// //                   itemBuilder: (context, index) {
// //                     return Container(
// //                       color: Colors.black, // خلفية سوداء للصور
// //                       child: InteractiveViewer(
// //                         panEnabled: true,
// //                         scaleEnabled: true,
// //                         child: Image.network(
// //                           state.product!.images[index],
// //                           fit: BoxFit.contain,
// //                           width: double.infinity,
// //                           height: double.infinity,
// //                           loadingBuilder:
// //                               (
// //                                 BuildContext context,
// //                                 Widget child,
// //                                 ImageChunkEvent? loadingProgress,
// //                               ) {
// //                                 if (loadingProgress == null) return child;
// //                                 return Center(
// //                                   child: CircularProgressIndicator(
// //                                     value:
// //                                         loadingProgress.expectedTotalBytes !=
// //                                             null
// //                                         ? loadingProgress
// //                                                   .cumulativeBytesLoaded /
// //                                               loadingProgress
// //                                                   .expectedTotalBytes!
// //                                         : null,
// //                                   ),
// //                                 );
// //                               },
// //                           errorBuilder: (context, error, stackTrace) => Center(
// //                             child: Column(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: [
// //                                 Icon(
// //                                   Icons.error_outline,
// //                                   size: 50.sp,
// //                                   color: Colors.grey,
// //                                 ),
// //                                 SizedBox(height: 10.h),
// //                                 Text(
// //                                   'Failed to load image',
// //                                   style: TextStyle(fontSize: 16.sp),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //               // عناصر التحكم (تظهر وتختفي)
// //               AnimatedBuilder(
// //                 animation: _opacityAnimation,
// //                 builder: (context, child) {
// //                   return Opacity(
// //                     opacity: _opacityAnimation.value,
// //                     child: child,
// //                   );
// //                 },
// //                 child: Visibility(
// //                   visible: _showOverlay,
// //                   child: Column(
// //                     children: [
// //                       // أسهم التنقل
// //                       Expanded(
// //                         child: Row(
// //                           children: [
// //                             // سهم يسار
// //                             if (_currentImageIndex > 0)
// //                               IconButton(
// //                                 icon: Icon(
// //                                   Icons.arrow_back_ios,
// //                                   size: 30.sp,
// //                                   color: Colors.white,
// //                                 ),
// //                                 onPressed: () =>
// //                                     _changeImage(_currentImageIndex - 1),
// //                               ),
// //                             const Spacer(),
// //                             // سهم يمين
// //                             if (_currentImageIndex <
// //                                 state.product!.images.length - 1)
// //                               IconButton(
// //                                 icon: Icon(
// //                                   Icons.arrow_forward_ios,
// //                                   size: 30.sp,
// //                                   color: Colors.white,
// //                                 ),
// //                                 onPressed: () =>
// //                                     _changeImage(_currentImageIndex + 1),
// //                               ),
// //                           ],
// //                         ),
// //                       ),

// //                       // معرض الصور المصغرة
// //                       Container(
// //                         height: 80.h,
// //                         color: Colors.black.withOpacity(0.5),
// //                         child: ListView.builder(
// //                           scrollDirection: Axis.horizontal,
// //                           itemCount: state.product!.images.length,
// //                           itemBuilder: (context, index) {
// //                             return GestureDetector(
// //                               onTap: () => _changeImage(index),
// //                               child: Container(
// //                                 width: 70.w,
// //                                 margin: EdgeInsets.all(4.w),
// //                                 decoration: BoxDecoration(
// //                                   border: Border.all(
// //                                     color: _currentImageIndex == index
// //                                         ? Colors.blue
// //                                         : Colors.transparent,
// //                                     width: 2,
// //                                   ),
// //                                   borderRadius: BorderRadius.circular(8.r),
// //                                 ),
// //                                 child: ClipRRect(
// //                                   borderRadius: BorderRadius.circular(6.r),
// //                                   child: Image.network(
// //                                     state.product!.images[index],
// //                                     fit: BoxFit.cover,
// //                                     loadingBuilder:
// //                                         (
// //                                           BuildContext context,
// //                                           Widget child,
// //                                           ImageChunkEvent? loadingProgress,
// //                                         ) {
// //                                           if (loadingProgress == null)
// //                                             return child;
// //                                           return Center(
// //                                             child: CircularProgressIndicator(
// //                                               value:
// //                                                   loadingProgress
// //                                                           .expectedTotalBytes !=
// //                                                       null
// //                                                   ? loadingProgress
// //                                                             .cumulativeBytesLoaded /
// //                                                         loadingProgress
// //                                                             .expectedTotalBytes!
// //                                                   : null,
// //                                               strokeWidth: 2,
// //                                             ),
// //                                           );
// //                                         },
// //                                     errorBuilder:
// //                                         (context, error, stackTrace) => Center(
// //                                           child: Icon(
// //                                             Icons.error_outline,
// //                                             size: 20.sp,
// //                                             color: Colors.grey,
// //                                           ),
// //                                         ),
// //                                   ),
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       ),

// //                       // معلومات المنتج
// //                       Container(
// //                         color: Colors.white,
// //                         padding: EdgeInsets.all(16.w),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               state.product!.title,
// //                               style: TextStyle(
// //                                 fontSize: 18.sp,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                             SizedBox(height: 8.h),
// //                             Row(
// //                               children: [
// //                                 Icon(
// //                                   Icons.star,
// //                                   color: Colors.amber,
// //                                   size: 20.sp,
// //                                 ),
// //                                 SizedBox(width: 4.w),
// //                                 Text(
// //                                   state.product!.rating.toString(),
// //                                   style: TextStyle(fontSize: 16.sp),
// //                                 ),
// //                                 const Spacer(),
// //                                 Text(
// //                                   "\$${state.product!.price}",
// //                                   style: TextStyle(
// //                                     fontSize: 20.sp,
// //                                     fontWeight: FontWeight.bold,
// //                                     color: Colors.green,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/features/products/presentions/cubit/product_detail/products_detail_state.dart';
// import 'package:flutter_application_2/features/products/presentions/widget/product_card_trapezoid.dart';
// import 'package:flutter_application_2/features/products/presentions/widget/product_details_card_trapezoid.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../cubit/product_detail/product_detail_cubit.dart';

// class ProductDetailScreen extends StatelessWidget {
//   const ProductDetailScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Product Details')),
//       body: BlocBuilder<ProductDetailCubit, ProductsDetailState>(
//         builder: (context, state) {
//           if (state.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state.errorMessage != null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(state.errorMessage!),
//                   const SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       // الحصول على productId من المعلمات في المسار
//                       final productId =
//                           ModalRoute.of(context)!.settings.arguments as int;
//                       context.read<ProductDetailCubit>().fetchProductByID(
//                         productId,
//                       );
//                     },
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (state.product != null) {
//             return Center(
//               child: ProductDetailsCardTrapezoid(
//                 productId: state.product!.id,
//                 title: state.product!.title,
//                 price: state.product!.price.toString(),
//                 imageUrl: state.product!.thumbnail,
//                 rating: state.product!.rating,
//                 images: state.product!.images,
//               ),
//             );
//           }

//           return const Center(child: Text('Product not found.'));
//         },
//       ),
//     );
//   }
// }
