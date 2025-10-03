import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/constants/widgets/horizontal_space.dart';
import 'package:flutter_application_2/core/constants/widgets/vertical_space.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/featured_products/featured_products_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/featured_products/featured_products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeaturedProductsSection extends StatelessWidget {
  const FeaturedProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 201.h,
      child: BlocBuilder<FeaturedProductsCubit, FeaturedProductsState>(
        buildWhen: (previous, current) =>
            previous.products != current.products ||
            previous.status != current.status,
        builder: (context, state) {
          if (state.status == FeaturedProductsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == FeaturedProductsStatus.failure) {
            return Row(
              children: [
                Center(child: Text(state.errorMessage ?? 'Error')),
                AddHorizontalSpace(8),
                ElevatedButton(
                  onPressed: () => context
                      .read<FeaturedProductsCubit>()
                      .fetchFeaturedProducts(),
                  child: const Text('Retry'),
                ),
              ],
            );
          }
          // if (state.status == ProductStatus.loading && state.products.isEmpty) {
          //   return Center(child: CircularProgressIndicator());
          // }
          // if (state.status == ProductStatus.failure && state.products.isEmpty) {
          //   return const Center(child: Text('Failed to load products'));
          // }
          // if (state.products.isEmpty) {
          //   return Text('No products found');
          // }
          return GridView.builder(
            itemCount: state.products.length,

            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
            ),
            itemBuilder: (context, index) {
              final product = state.products[index];
              return Container(
                height: 169.h,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.6),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(0, 5),
                    ),
                  ],

                  borderRadius: BorderRadius.circular(32.r),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(12.0),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.network(product.thumbnail, height: 72.h),
                      ),

                      AddVerticalSpace(12),

                      Container(
                        width: 120.w,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            product.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      AddVerticalSpace(2),
                      Text(
                        "\$ ${product.price.toString()} ",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AddVerticalSpace(8),

                      Row(
                        children: List.generate(5, (index) {
                          double rating = 4.5;
                          Color color = Colors.amber;
                          double size = 14.sp;
                          if (rating >= index + 1) {
                            return Icon(Icons.star, color: color, size: size);
                          } else if (rating >= index + 0.5) {
                            return Icon(
                              Icons.star_half,
                              color: color,
                              size: size,
                            );
                          } else {
                            return Icon(
                              Icons.star_border,
                              color: color,
                              size: size,
                            );
                          }
                        }),
                      ),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
