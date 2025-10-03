import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/constants/widgets/vertical_space.dart';
import 'package:flutter_application_2/features/home/presentions/widgets/categories_section.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/products_list/products_list_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/products_list/products_list_state.dart';
import 'package:flutter_application_2/features/products/presentions/widget/paginated_product_grid.dart';
import 'package:flutter_application_2/features/products/presentions/widget/paginated_searche_product_grid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ProductsScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffaf4f0),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AddVerticalSpace(16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 18.sp,

                    backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D&w=100&q=50",
                    ),
                  ),
                  Icon(
                    Icons.list,
                    size: 32.sp,
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
              AddVerticalSpace(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      context.push('/search-products');
                    },
                    icon: Icon(Icons.search, size: 32.sp),
                  ),

                  // Expanded(
                  //   child: InkWell(
                  //     onTap: () => context.go('/products/search'),
                  //     child: TextField(
                  //       controller: searchController,
                  //       readOnly: true,
                  //       decoration: InputDecoration(
                  //         fillColor: Colors.grey.shade200,
                  //         filled: true,
                  //         hintText: 'Search Products',
                  //         prefixIcon: const Icon(Icons.search),
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(16.0.sp),
                  //           borderSide: BorderSide.none,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "assets/icons/filtter_icon.svg",
                      height: 32.h,
                    ),
                  ),
                ],
              ),
              AddVerticalSpace(8),
              CategoriesSection(),
              AddVerticalSpace(8),
              Expanded(
                child: BlocBuilder<ProductsListCubit, ProductsListState>(
                  builder: (context, state) {
                    return PaginatedProductGrid(
                      products: state.products,
                      hasReachedMax: state.hasReachedMax,
                      status: state.status,
                      onFetchMore: () {
                        context.read<ProductsListCubit>().fetchMoreProducts();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

































// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/core/constants/widgets/vertical_space.dart';
// import 'package:flutter_application_2/features/home/presentions/widgets/categories_section.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';

// class ProductsScreen extends StatelessWidget {
  
//   final TextEditingController searchController = TextEditingController();
//    ProductsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       backgroundColor: Color(0xfffaf4f0),
//       body: Center(
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundImage: NetworkImage(
//                     "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80",
//                   ),
//                 ),
//                 Icon(Icons.sort, size: 50, textDirection: TextDirection.ltr),
//               ],
//             ),
//             AddVerticalSpace(8),
//             Row(
//               children: [
//                 TextField(
//                   controller: searchController,
//                   decoration: InputDecoration(
//                     fillColor: Colors.grey,
//                     hintText: 'Search Products',
//                     prefixIcon: Icon(Icons.search),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(16.0.sp),
//                       borderSide: BorderSide.none,
//                     ),
//                     hoverColor: Colors.grey,
//                   ),
//                 ),
//                 IconButton(onPressed: (){}, icon: 
//                 SvgPicture.asset(
//                   "assets/icons/filtter_icon.svg",)
//                 )
//               ],
//             ),
//             AddVerticalSpace(8),
//           CategoriesSection(),
//           AddVerticalSpace(8),
//           GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, 
          
          
//           ),
//           itemBuilder: (context, index) => ,
//           )
          

//           ],
//         ),
//       ),
//     );
//   }
// }
