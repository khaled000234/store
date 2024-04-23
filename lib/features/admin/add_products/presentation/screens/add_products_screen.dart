
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/common/widgets/admin_app_bar.dart';
import 'package:store/core/di/injection_container.dart';
import 'package:store/core/style/colors/colors_dark.dart';
import 'package:store/features/admin/add_products/presentation/bloc/delete_product/delete_product_bloc.dart';
import 'package:store/features/admin/add_products/presentation/bloc/get_all_admin_product/get_all_admin_product_bloc.dart';
import 'package:store/features/admin/add_products/presentation/refactors/add_products_body.dart';

class AddProductsScreen extends StatelessWidget {
  const AddProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<GetAllAdminProductBloc>()
            ..add(
              const GetAllAdminProductEvent.getAllProducts(isNotLoading: true),
            ),
        ),
        BlocProvider(create: (context) => sl<DeleteProductBloc>()),
      ],
      child: const Scaffold(
        backgroundColor: ColorsDark.mainColor,
        appBar: AdminAppBar(
          title: 'Products',
          isMain: true,
          backgroundColor: ColorsDark.mainColor,
        ),
        body: AddProductsBody(),
      ),
    );
  }
}
