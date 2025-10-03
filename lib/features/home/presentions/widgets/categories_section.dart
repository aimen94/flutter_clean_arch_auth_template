import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/constants/widgets/horizontal_space.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/categories/categories_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/categories/categories_state.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/products_list/products_list_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedCategory = context.select(
      (ProductsListCubit cubit) => cubit.state.selectedCategory,
    );

    return SizedBox(
      height: 48.h, // ارتفاع مناسب للـ Chip
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state.status == CategoriesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == CategoriesStatus.failure) {
            return Row(
              children: [
                Center(child: Text(state.errorMessage ?? 'Error')),
                AddHorizontalSpace(8),
                ElevatedButton(
                  onPressed: () =>
                      context.read<CategoriesCubit>().fetchCategories(),
                  child: const Text('Retry'),
                ),
              ],
            );
          }
          if (state.status == CategoriesStatus.failure &&
              state.categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? 'An error occurred'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<CategoriesCubit>().fetchCategories(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // ✨ إضافة "All" إلى بداية قائمة التصنيفات
          final displayCategories = ['All', ...state.categories];

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: displayCategories.length,
            itemBuilder: (context, index) {
              final category = displayCategories[index];

              // ✨ التحقق الديناميكي من الفئة المختارة
              // "All" تكون مختارة إذا كان selectedCategory هو null
              final isSelected =
                  (category == 'All' && selectedCategory == null) ||
                  (category == selectedCategory);

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    final productsCubit = context.read<ProductsListCubit>();
                    if (category == 'All') {
                      productsCubit.fetchInitialProducts();
                    } else {
                      productsCubit.fetchInitialProductsByCategory(category);
                    }
                  },
                  backgroundColor: Colors.grey.shade200,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
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

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_application_2/features/products/presentions/cubit/categories/categories_cubit.dart';
// import 'package:flutter_application_2/features/products/presentions/cubit/categories/categories_state.dart';
// import 'package:flutter_application_2/features/products/presentions/cubit/products_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CategoriesSection extends StatelessWidget {
//   CategoriesSection({super.key});
//   final bool isSelected = false;
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 68,
//       child: BlocBuilder<CategoriesCubit, CategoriesState>(
//         buildWhen: (previous, current) =>
//             previous.categories != current.categories,
//         builder: (context, state) {
//           // ✨ تصحيح: استخدم CategoriesStatus
//           if (state.status == CategoriesStatus.loading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (state.status == CategoriesStatus.failure) {
//             return Center(child: Text(state.errorMessage ?? 'Error'));
//           }

//           return ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: state.categories.length,
//             itemBuilder: (context, index) {
//               final categories = state.categories[index];
//               return Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 4.w),
//                 child: Chip(
//                   label: Text(categories),
//                   backgroundColor: isSelected
//                       ? Colors.cyan
//                       : Colors.grey.shade50,
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
