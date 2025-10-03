// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/features/products/presentions/cubit/products_list/products_list_cubit.dart';
// import 'package:flutter_application_2/features/products/presentions/cubit/products_list/products_list_state.dart';
// import 'package:flutter_application_2/features/products/presentions/widget/product_card_trapezoid.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

// class PaginatedProductGrid extends StatefulWidget {
//   const PaginatedProductGrid({super.key});

//   @override
//   State<PaginatedProductGrid> createState() => _PaginatedProductGridState();
// }

// class _PaginatedProductGridState extends State<PaginatedProductGrid> {
//   final _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//     context.read<ProductsListCubit>().fetchInitialProducts();
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent * 0.9) {
//       context.read<ProductsListCubit>().fetchMoreProducts();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProductsListCubit, ProductsListState>(
//       buildWhen: (previous, current) =>
//           previous.products != current.products ||
//           previous.status != current.status,
//       builder: (context, state) {
//         if (state.status == ProductListStatus.initial ||
//             (state.status == ProductListStatus.loading &&
//                 state.products.isEmpty)) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (state.status == ProductListStatus.failure &&
//             state.products.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(state.errorMessage ?? 'An error occurred'),
//                 const SizedBox(height: 8),
//                 ElevatedButton(
//                   onPressed: () =>
//                       context.read<ProductsListCubit>().fetchInitialProducts(),
//                   child: const Text('Retry'),
//                 ),
//               ],
//             ),
//           );
//         }

//         if (state.status == ProductListStatus.success &&
//             state.products.isEmpty) {
//           return const Center(child: Text('No products found.'));
//         }

//         return AnimationLimiter(
//           child: GridView.builder(
//             controller: _scrollController,
//             padding: const EdgeInsets.all(12),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               mainAxisSpacing: 20,
//               crossAxisSpacing: 20,
//               childAspectRatio: 0.8,
//             ),
//             itemCount: state.hasReachedMax
//                 ? state.products.length
//                 : state.products.length + 1,
//             itemBuilder: (context, index) {
//               if (index >= state.products.length) {
//                 return Center(
//                   child: LoadingAnimationWidget.dotsTriangle(
//                     color: Colors.cyan,
//                     size: 32.sp,
//                   ),
//                 );
//               }

//               final product = state.products[index];

//               return AnimationConfiguration.staggeredGrid(
//                 position: index,
//                 columnCount: 2,
//                 duration: const Duration(milliseconds: 600), // زيادة المدة
//                 child: SlideAnimation(
//                   //  انزلاق
//                   horizontalOffset: 50.0,
//                   child: FadeInAnimation(
//                     //  تدرج  الظهور
//                     child: ScaleAnimation(
//                       //  تكبير
//                       scale: 0.9,
//                       child: ProductCardTrapezoid(
//                         title: product.title,
//                         price: product.price.toString(),
//                         imageUrl: product.thumbnail,
//                         productId: product.id,
//                         rating: product.rating,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
