import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/products/domain/entity/products.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/products_list/products_list_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/products_list/products_list_state.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/searche/searche_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/searche/searche_state.dart';
import 'package:flutter_application_2/features/products/presentions/widget/product_card_trapezoid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PaginatedProductGrid extends StatefulWidget {
  final List<ProductsEntity> products;
  final bool hasReachedMax;
  final dynamic
  status; // dynamic لأنه سيستقبل ProductListStatus أو SearchStatus
  final VoidCallback onFetchMore; // دالة لجلب المزيد

  const PaginatedProductGrid({
    super.key,
    required this.products,
    required this.hasReachedMax,
    required this.status,
    required this.onFetchMore,
  });
  @override
  State<PaginatedProductGrid> createState() => _PaginatedProductGridState();
}

class _PaginatedProductGridState extends State<PaginatedProductGrid> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // استدعاء الدالة التي تم تمريرها
      widget.onFetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    // الواجهة الآن تعتمد فقط على البيانات الممررة، وليس على Cubit معين
    if (widget.products.isEmpty) {
      if (widget.status == ProductListStatus.loading ||
          widget.status == SearchStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (widget.status == ProductListStatus.failure ||
          widget.status == SearchStatus.failure) {
        return const Center(child: Text('An error occurred')); // يمكن تحسينها
      }
      return const Center(child: Text('No products found.'));
    }

    return AnimationLimiter(
      child: GridView.builder(
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.8,
        ),
        itemCount: widget.hasReachedMax
            ? widget.products.length
            : widget.products.length + 1,
        itemBuilder: (context, index) {
          if (index >= widget.products.length) {
            return Center(/* ... مؤشر التحميل ... */);
          }
          final product = widget.products[index];

          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: 2,
            duration: const Duration(milliseconds: 600), // زيادة المدة
            child: SlideAnimation(
              //  انزلاق
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                //  تدرج  الظهور
                child: ScaleAnimation(
                  //  تكبير
                  scale: 0.9,
                  child: ProductCardTrapezoid(
                    title: product.title,
                    price: product.price.toString(),
                    imageUrl: product.thumbnail,
                    productId: product.id,
                    rating: product.rating,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
