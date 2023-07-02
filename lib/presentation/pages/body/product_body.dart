import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/presentation/pages/support/loading_page.dart';

import '../../../business_logic/cubits/product_cubit.dart';
import '../../../business_logic/states/product_state.dart';
import '../../res/dimen/dimens.dart';
import '../../../data/models/product_model.dart';
import '../../widgets/product/product_widget.dart';

class ProductBody extends StatefulWidget {

  const ProductBody({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends State<ProductBody> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case ProductInitial:
            return const SizedBox();
          case ProductLoading:
            return const LoadingPage();
          case ProductLoaded:
            state as ProductLoaded;
            var listType = state.listType;
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return _getListProduct(
                  listType[index].name,
                  state.getProductsByCategoryId(
                    listType[index].id,
                  ),
                );
              },
              itemCount: listType.length,
            );
        }
        return const SizedBox();
      },
    );
  }

  Widget _getListProduct(
    String title,
    List<ProductModel> shortProducts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: spaceSM),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: spaceXXS,
            horizontal: spaceXS,
          ),
          child: Text(
            title,
            style: const TextStyle(
              height: 1.25,
              fontSize: fontLG,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(spaceXS),
            child: ProductWidget(
              // height: 100
              model: shortProducts[index],
            ),
          ),
          itemCount: shortProducts.length,
        )
      ],
    );
  }
}
