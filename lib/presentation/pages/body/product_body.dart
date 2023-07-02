import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/cubits/product_cubit.dart';
import '../../../business_logic/states/product_state.dart';
import '../../res/dimen/dimens.dart';
import '../../../data/models/product_model.dart';
import '../../widgets/product/product_widget.dart';

class ProductBody extends StatefulWidget {
  final int perRow = 4;
  final int row = 2;

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
            return const SizedBox();
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
      // height: 22.5 + 4 * 2 + 12 = 42.5
      children: [
        const SizedBox(height: spaceSM),
        Padding(
          // height: 22.5 + 4 * 2 = 30.5
          padding: const EdgeInsets.symmetric(
            vertical: spaceXXS,
            horizontal: spaceXS,
          ),
          child: Text(
            // height: 18 * 1.25 = 22.5
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
            // height: 116
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
