import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/searche/searche_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/searche/searche_state.dart';
import 'package:flutter_application_2/features/products/presentions/widget/paginated_searche_product_grid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SearchProductsScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  SearchProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffaf4f0),
      appBar: AppBar(
        backgroundColor: const Color(0xfffaf4f0),
        title: const Text('Search Products'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 300.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0.sp),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {
                        context.read<SearchCubit>().searcheProducts(
                          searchController.text.trim(),
                        );
                      },
                      icon: Icon(CupertinoIcons.search),
                    ),
                    fillColor: const Color(0xfffaf4f0),
                    filled: true,
                    hintText: 'Search Products',
                    contentPadding: const EdgeInsets.only(left: 16.0),
                    enabled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0.sp),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Expanded(
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            return PaginatedProductGrid(
              products: state.searchResults,
              hasReachedMax: state.hasReachedMax,
              status: state.status,
              onFetchMore: () {
                context.read<SearchCubit>().featchMoreSearchProducts();
              },
            );
          },
        ),
      ),
    );
  }
}
