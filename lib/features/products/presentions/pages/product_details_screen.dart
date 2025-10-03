import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/constants/widgets/horizontal_space.dart';
import 'package:flutter_application_2/core/constants/widgets/vertical_space.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/product_detail/product_detail_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/product_detail/products_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isFavorite = false;
  int currentImageIndex = 0;
  int quantity = 1;

  @override
  void dispose() {
    quantity = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffaf4f0),
        title: const Text(
          'Product Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.black),
              onPressed: () {},
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xfffaf4f0),
      body: BlocBuilder<ProductDetailCubit, ProductsDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage!),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      final productId =
                          ModalRoute.of(context)!.settings.arguments as int;
                      context.read<ProductDetailCubit>().fetchProductByID(
                        productId,
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.product == null) {
            return const Center(child: Text('Product not found.'));
          }

          // إذا تم تجاوز كل الشروط السابقة، فهذا يعني أن لدينا منتج وصور
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // لمحاذاة عنوان المراجعات
              children: [
                const AddVerticalSpace(8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.h),
                  child: Container(
                    width: 320.w,
                    height: 300.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: const Color(0xfffaf4f0),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            state.product!.images[currentImageIndex],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, color: Colors.red);
                            },
                          ),
                        ),
                        Positioned(
                          top: 5.r,
                          right: 5.r,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xfffaf4f0),
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 5,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                isFavorite
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                color: isFavorite ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16.h,
                          left: 16.w,
                          right: 16.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (currentImageIndex > 0) {
                                      currentImageIndex--;
                                    } else {
                                      currentImageIndex =
                                          state.product!.images.length - 1;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 20.r,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                width: 180.w,
                                height: 60.h,
                                padding: EdgeInsets.symmetric(vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xfffaf4f0),
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 8,
                                      spreadRadius: 5,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.product!.images.length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            currentImageIndex = index;
                                          });
                                        },
                                        child: Container(
                                          width: 50.w,
                                          height: 50.h,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 4.w,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            border: Border.all(
                                              color: currentImageIndex == index
                                                  ? Colors.blue
                                                  : Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              6.r,
                                            ),
                                            child: Image.network(
                                              state.product!.images[index],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (currentImageIndex <
                                        state.product!.images.length - 1) {
                                      currentImageIndex++;
                                    } else {
                                      currentImageIndex = 0;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.r,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const AddVerticalSpace(16),
                Row(
                  children: [
                    Text(
                      state.product!.title,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "\$${state.product!.price}",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const AddVerticalSpace(8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20.sp),
                    const AddHorizontalSpace(4),
                    Text(
                      state.product!.rating.toString(),
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ],
                ),
                const AddVerticalSpace(16),
                Text(
                  state.product!.description,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) {
                            quantity--;
                          }
                        });
                      },
                    ),
                    const AddHorizontalSpace(4),
                    Text(
                      quantity.toString(),
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    const AddHorizontalSpace(4),
                    IconButton(
                      icon: Icon(Icons.add, size: 24.sp),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                        color: const Color(0xffff650e),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.badge_outlined, color: Colors.white),
                          AddHorizontalSpace(4),
                          Text(
                            "Buy Now",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  "Reviews",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const AddVerticalSpace(8),

                if (state.product!.reviews.isEmpty)
                  const Expanded(child: Center(child: Text("No reviews yet.")))
                else
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemCount: state.product!.reviews.length,
                      itemBuilder: (context, index) {
                        final review = state.product!.reviews[index];
                        return ListTile(
                          title: Text(
                            review.reviewerName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            review.comment,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        indent: 16.w,
                        endIndent: 16.w,
                        color: Colors.deepOrange.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}


































// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/core/constants/widgets/horizontal_space.dart';
// import 'package:flutter_application_2/core/constants/widgets/vertical_space.dart';
// import 'package:flutter_application_2/features/products/presentions/cubit/product_detail/product_detail_cubit%20.dart';
// import 'package:flutter_application_2/features/products/presentions/cubit/product_detail/products_detail_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ProductDetailsScreen extends StatefulWidget {
//   const ProductDetailsScreen({super.key});

//   @override
//   State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
// }

// class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
//   bool isFavorite = false;
//   int currentImageIndex = 0;
//   int quantity = 1;

//   @override
//   void dispose() {
//     quantity = 0;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xfffaf4f0),
//         title: const Text(
//           'Product Details',
//           style: TextStyle(color: Colors.black),
//         ),
//         centerTitle: true,
//         actions: [
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 16.h),
//             child: IconButton(
//               icon: const Icon(Icons.share_outlined, color: Colors.black),
//               onPressed: () {},
//             ),
//           ),
//         ],
//       ),
//       //backgroundColor: Colors.white,
//       backgroundColor: const Color(0xfffaf4f0),

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

//           if (state.product == null) {
//             return const Center(child: Text('Product not found.'));
//           }

//           // // ✨ تعديل 3 (الحل الرئيسي): إضافة شرط للتحقق من وجود صور قبل محاولة عرضها
//           // if (state.product!.images.isEmpty) {
//           //   return const Center(
//           //     child: Text('No images available for this product.'),
//           //   );
//           // }

//           // إذا تم تجاوز كل الشروط السابقة، فهذا يعني أن لدينا منتج وصور
//           return Padding(
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             child: Column(
//               children: [
//                 const AddVerticalSpace(8),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 32.h),
//                   child: Container(
//                     width: 320.w,
//                     height: 300.h,
//                     clipBehavior: Clip.antiAlias,
//                     decoration: BoxDecoration(
//                       color: const Color(0xfffaf4f0),
//                       borderRadius: BorderRadius.circular(16.r),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           blurRadius: 15,
//                           spreadRadius: 2,
//                           offset: const Offset(3, 3),
//                         ),
//                       ],
//                     ),
//                     child: Stack(
//                       children: [
//                         Positioned.fill(
//                           child: Image.network(
//                             state.product!.images[currentImageIndex],
//                             fit: BoxFit.cover,
//                             loadingBuilder: (context, child, loadingProgress) {
//                               if (loadingProgress == null) return child;
//                               return const Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             },
//                             errorBuilder: (context, error, stackTrace) {
//                               return const Icon(Icons.error, color: Colors.red);
//                             },
//                           ),
//                         ),
//                         Positioned(
//                           top: 5.r,
//                           right: 5.r,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: const Color(0xfffaf4f0),
//                               //shape: BoxShape.circle,
//                               borderRadius: BorderRadius.circular(16.r),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.5),
//                                   blurRadius: 8,
//                                   spreadRadius: 5,
//                                   offset: const Offset(2, 2),
//                                 ),
//                               ],
//                             ),
//                             child: IconButton(
//                               icon: Icon(
//                                 isFavorite
//                                     ? CupertinoIcons.heart_fill
//                                     : CupertinoIcons.heart,
//                                 color: isFavorite ? Colors.red : Colors.grey,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   isFavorite = !isFavorite;
//                                 });
//                               },
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 16.h,
//                           left: 16.w,
//                           right: 16.w,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     if (currentImageIndex > 0) {
//                                       currentImageIndex--;
//                                     } else {
//                                       currentImageIndex =
//                                           state.product!.images.length - 1;
//                                     }
//                                   });
//                                 },
//                                 icon: Icon(
//                                   Icons.arrow_back_ios_new,
//                                   size: 20.r,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               Container(
//                                 width: 180.w,
//                                 height: 60.h,
//                                 padding: EdgeInsets.symmetric(vertical: 4.h),
//                                 decoration: BoxDecoration(
//                                   //color: Color(0xfff7f7f7),
//                                   color: Color(0xfffaf4f0),
//                                   borderRadius: BorderRadius.circular(12.r),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.5),
//                                       blurRadius: 8,
//                                       spreadRadius: 5,
//                                       offset: const Offset(2, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: ListView.builder(
//                                   scrollDirection: Axis.horizontal,
//                                   itemCount: state.product!.images.length,
//                                   itemBuilder: (context, index) =>
//                                       GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             currentImageIndex = index;
//                                           });
//                                         },
//                                         child: Container(
//                                           width: 50.w,
//                                           height: 50.h,
//                                           margin: EdgeInsets.symmetric(
//                                             horizontal: 4.w,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius: BorderRadius.circular(
//                                               8.r,
//                                             ),
//                                             border: Border.all(
//                                               // تمييز الصورة المحددة حاليًا
//                                               color: currentImageIndex == index
//                                                   ? Colors.blue
//                                                   : Colors.white,
//                                               width: 2,
//                                             ),
//                                           ),
//                                           child: ClipRRect(
//                                             borderRadius: BorderRadius.circular(
//                                               6.r,
//                                             ),
//                                             child: Image.network(
//                                               state.product!.images[index],
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     if (currentImageIndex <
//                                         state.product!.images.length - 1) {
//                                       currentImageIndex++;
//                                     } else {
//                                       currentImageIndex = 0;
//                                     }
//                                   });
//                                 },
//                                 icon: Icon(
//                                   Icons.arrow_forward_ios,
//                                   size: 20.r,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 AddVerticalSpace(16),
//                 Row(
//                   children: [
//                     Text(
//                       state.product!.title,
//                       style: TextStyle(
//                         fontSize: 20.sp,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Spacer(),
//                     Text(
//                       "\$${state.product!.price}",
//                       style: TextStyle(
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//                 AddVerticalSpace(8),
//                 Row(
//                   children: [
//                     Icon(Icons.star, color: Colors.amber, size: 20.sp),
//                     AddHorizontalSpace(4),
//                     Text(
//                       state.product!.rating.toString(),
//                       style: TextStyle(fontSize: 16.sp),
//                     ),
//                   ],
//                 ),
//                 AddVerticalSpace(16),
//                 Text(
//                   state.product!.description,
//                   style: TextStyle(fontSize: 14.sp, color: Colors.grey),
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.remove),
//                       onPressed: () {
//                         setState(() {
//                           if (quantity > 1) {
//                             quantity--;
//                           }
//                         });
//                       },
//                     ),
//                     AddHorizontalSpace(4),
//                     Text(
//                       quantity.toString(),
//                       style: TextStyle(fontSize: 14.sp),
//                     ),
//                     AddHorizontalSpace(4),

//                     IconButton(
//                       icon: Icon(Icons.add, size: 24.sp),
//                       onPressed: () {
//                         setState(() {
//                           quantity++;
//                         });
//                       },
//                     ),
//                     Spacer(),
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Color(0xffff650e),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(Icons.badge_outlined, color: Colors.white),
//                           AddHorizontalSpace(4),
//                           Text(
//                             "Buy Now",
//                             style: TextStyle(
//                               fontSize: 16.sp,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Text(
//                   "Reviews",
//                   style: TextStyle(
//                     fontSize: 20.sp,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),



                
//                 // Expanded(
//                 //   child: ListView.builder(
//                 //     itemCount: state.product!.reviews.length,
//                 //     itemBuilder: state.product!.reviews.isEmpty
//                 //         ? (context, index) => Text("No reviews yet")
//                 //         : (context, index) => ListTile(
//                 //             title: Row(
//                 //               children: [
//                 //                 Text(
//                 //                   state.product!.reviews[index].reviewerName,
//                 //                   style: TextStyle(
//                 //                     fontSize: 16.sp,
//                 //                     color: Colors.black,
//                 //                     fontWeight: FontWeight.bold,
//                 //                   ),
//                 //                 ),
//                 //               ],
//                 //             ),
//                 //             subtitle: Text(
//                 //               state.product!.reviews[index].comment,
//                 //               style: TextStyle(
//                 //                 fontSize: 14.sp,
//                 //                 color: Colors.grey,
//                 //               ),
//                 //             ),
//                 //           ),
//                 //   ),
//                 // ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // // افترض وجود هذه الملفات، إذا لم تكن موجودة يمكنك حذف الأسطر التالية
// // import 'package:flutter_application_2/core/constants/widgets/vertical_space.dart';
// // import 'package:flutter_application_2/features/products/presentions/cubit/product_detail/product_detail_cubit%20.dart';
// // import 'package:flutter_application_2/features/products/presentions/cubit/product_detail/products_detail_state.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';

// // class ProductDetailsScreen extends StatelessWidget {
// //   ProductDetailsScreen({super.key});
// //   bool isFavorite = false;
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Product Details', style: TextStyle(color: Colors.black)),
// //         centerTitle: true,
// //         actions: [
// //           Padding(
// //             padding: EdgeInsets.symmetric(vertical: 16.h),
// //             child: IconButton(
// //               icon: Icon(Icons.share_outlined, color: Colors.black),
// //               onPressed: () {},
// //             ),
// //           ),
// //         ],
// //       ),
// //       backgroundColor: Colors.grey[200],
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
// //                       // الحصول على productId من المعلمات في المسار
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
// //           if (state.product == null) {
// //             return const Center(child: Text('Product not found.'));
// //           }
// //           if (state.product!.images.isEmpty) {
// //             return const Center(child: Text('No images available.'));
// //           }
// //           return Column(
// //             children: [
// //               const AddVerticalSpace(64),

// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 32.h),
// //                 child: Container(
// //                   width: 320.w,
// //                   height: 300.h,
// //                   clipBehavior: Clip.antiAlias,
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(16.r),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.grey.withOpacity(0.2),
// //                         blurRadius: 15,
// //                         spreadRadius: 2,
// //                         offset: const Offset(0, 5),
// //                       ),
// //                     ],
// //                   ),
// //                   // ✨ تعديل 2: استخدام Stack لوضع العناصر فوق بعضها البعض
// //                   child: Stack(
// //                     // fit: StackFit.expand, // يضمن أن العناصر غير المحددة تمتد لملء الـ Stack
// //                     children: [
// //                       // --- الطبقة الخلفية: الصورة ---
// //                       // ✨ تعديل 3: الصورة الآن تملأ الحاوية بالكامل
// //                       Positioned.fill(
// //                         child: Image.network(
// //                           // استخدمت صورة مختلفة للتوضيح بشكل أفضل
// //                           state.product!.images[0],
// //                           // BoxFit.cover يجعل الصورة تغطي المساحة مع الحفاظ على أبعادها
// //                           fit: BoxFit.cover,
// //                         ),
// //                       ),

// //                       // --- الطبقات العلوية: الأزرار ---

// //                       // زر المفضلة في الزاوية اليمنى العليا
// //                       // ✨ تعديل 4: استخدام Positioned لتثبيت الزر في الأعلى واليمين
// //                       Positioned(
// //                         top: 12.r,
// //                         right: 12.r,
// //                         child: Container(
// //                           decoration: BoxDecoration(
// //                             color: Colors.white.withOpacity(
// //                               0.8,
// //                             ), // شفافية بسيطة للجمالية
// //                             shape: BoxShape.circle,
// //                             boxShadow: [
// //                               BoxShadow(
// //                                 color: Colors.grey.withOpacity(0.3),
// //                                 blurRadius: 8,
// //                                 spreadRadius: 1,
// //                                 offset: const Offset(0, 3),
// //                               ),
// //                             ],
// //                           ),
// //                           child: IconButton(
// //                             icon: isFavorite
// //                                 ? Icon(
// //                                     CupertinoIcons.heart_fill,
// //                                     color: Colors.red,
// //                                   )
// //                                 : Icon(
// //                                     CupertinoIcons.heart,

// //                                     color: Colors.grey,
// //                                   ),
// //                             onPressed: () {
// //                               isFavorite = !isFavorite;
// //                             },
// //                           ),
// //                         ),
// //                       ),

// //                       // صف الأزرار في الأسفل
// //                       // ✨ تعديل 5: استخدام Positioned لتثبيت الصف في الأسفل
// //                       Positioned(
// //                         bottom: 16.h, // مسافة من الحافة السفلية
// //                         left: 16.w, // مسافة من الحافة اليسرى
// //                         right: 16.w, // مسافة من الحافة اليمنى
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             // زر السهم للخلف
// //                             Container(
// //                               decoration: BoxDecoration(
// //                                 color: Colors.white.withOpacity(0.7),
// //                                 shape: BoxShape.circle,
// //                               ),
// //                               child: IconButton(
// //                                 onPressed: () {},
// //                                 icon: Icon(
// //                                   Icons.arrow_back_ios_new,
// //                                   size: 20.r,
// //                                   color: Colors.black,
// //                                 ),
// //                               ),
// //                             ),
// //                             // قائمة الصور المصغرة
// //                             Container(
// //                               width: 180.w,
// //                               height: 60.h,
// //                               padding: EdgeInsets.symmetric(
// //                                 vertical: 4.h,
// //                               ), // حشوة داخلية
// //                               decoration: BoxDecoration(
// //                                 // لون شبه شفاف لدمج أفضل مع الصورة
// //                                 color: Colors.black.withOpacity(0.2),
// //                                 borderRadius: BorderRadius.circular(12.r),
// //                               ),
// //                               child: ListView.builder(
// //                                 scrollDirection: Axis.horizontal,
// //                                 itemCount: state
// //                                     .product!
// //                                     .images
// //                                     .length, // زدت العدد للتوضيح
// //                                 itemBuilder: (context, index) => Container(
// //                                   width: 50.w,
// //                                   height: 50.h,
// //                                   margin: EdgeInsets.symmetric(horizontal: 4.w),
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.white,
// //                                     borderRadius: BorderRadius.circular(8.r),
// //                                     border: Border.all(
// //                                       color: Colors.white,
// //                                       width: 2,
// //                                     ),
// //                                   ),
// //                                   child: ClipRRect(
// //                                     borderRadius: BorderRadius.circular(6.r),
// //                                     child: Image.network(
// //                                       state.product!.images[index],
// //                                       fit: BoxFit.cover,
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                             // زر السهم للأمام
// //                             Container(
// //                               decoration: BoxDecoration(
// //                                 color: Colors.white.withOpacity(0.7),
// //                                 shape: BoxShape.circle,
// //                               ),
// //                               child: IconButton(
// //                                 onPressed: () {},
// //                                 icon: Icon(
// //                                   Icons.arrow_forward_ios,
// //                                   size: 20.r,
// //                                   color: Colors.black,
// //                                 ),
// //                               ),
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

// // // import 'package:flutter/cupertino.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_application_2/core/constants/widgets/vertical_space.dart';
// // // import 'package:flutter_screenutil/flutter_screenutil.dart';

// // // class ProductDetailsScreen extends StatelessWidget {
// // //   const ProductDetailsScreen({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Product Details', style: TextStyle(color: Colors.black)),
// // //         centerTitle: true,
// // //         actions: [
// // //           Padding(
// // //             padding: EdgeInsets.symmetric(vertical: 16.h),
// // //             child: IconButton(
// // //               icon: Icon(Icons.share_outlined, color: Colors.black),
// // //               onPressed: () {},
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //       body: Column(
// // //         children: [
// // //           AddVerticalSpace(8),
// // //           Center(
// // //             child: Container(
// // //               height: 300.h,
// // //               width: 300.w,
// // //               decoration: BoxDecoration(
// // //                 color: Colors.white,
// // //                 borderRadius: BorderRadius.circular(16),
// // //                 boxShadow: [
// // //                   BoxShadow(
// // //                     color: Colors.grey.withOpacity(0.1),
// // //                     blurRadius: 50,
// // //                     spreadRadius: 2,
// // //                     offset: const Offset(5, 10),
// // //                   ),
// // //                 ],
// // //               ),
// // //               child: Column(
// // //                 children: [
// // //                   IconButton(
// // //                     onPressed: () {},
// // //                     icon: Container(
// // //                       height: 20.h,
// // //                       width: 20.w,

// // //                       margin: EdgeInsets.all(8.sp),
// // //                       decoration: BoxDecoration(
// // //                         color: Colors.white,
// // //                         boxShadow: [
// // //                           BoxShadow(
// // //                             color: Colors.grey.withOpacity(0.1),
// // //                             blurRadius: 20,
// // //                             spreadRadius: 2,
// // //                             offset: const Offset(0, 10),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                       child: IconButton(
// // //                         icon: Icon(CupertinoIcons.heart, color: Colors.black),
// // //                         onPressed: () {},
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   Image.network(
// // //                     'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D&w=100&q=50',
// // //                     height: 200.h,
// // //                     width: 200.w,
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //           Align(
// // //             alignment: Alignment.bottomCenter,
// // //             child: Row(
// // //               mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //               children: [
// // //                 IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
// // //                 Container(
// // //                   width: 250.w,
// // //                   height: 80,
// // //                   color: Color(0xfff6f6f6),

// // //                   child: ListView.builder(
// // //                     scrollDirection: Axis.horizontal,
// // //                     //  shrinkWrap: true,
// // //                     itemCount: 3,
// // //                     itemBuilder: (context, index) => Container(
// // //                       height: 60.h,
// // //                       width: 60.w,
// // //                       margin: EdgeInsets.all(8.sp),

// // //                       decoration: BoxDecoration(
// // //                         color: Colors.white,
// // //                         borderRadius: BorderRadius.circular(16),
// // //                         boxShadow: [
// // //                           BoxShadow(
// // //                             color: Colors.grey.withOpacity(0.1),
// // //                             blurRadius: 10,
// // //                             spreadRadius: 2,
// // //                             offset: const Offset(0, 10),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 IconButton(
// // //                   onPressed: () {},
// // //                   icon: Icon(Icons.arrow_forward_ios),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
