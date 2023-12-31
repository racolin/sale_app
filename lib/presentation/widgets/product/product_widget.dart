import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/cubits/product_cubit.dart';
import '../../../data/models/product_model.dart';
import '../../../supports/convert.dart';
import '../../res/dimen/dimens.dart';
import '../app_image_widget.dart';

class ProductWidget extends StatelessWidget {
  final ProductModel model;
  final bool isTemplate;
  final VoidCallback onClick;

  const ProductWidget({
    Key? key,
    required this.model,
    required this.onClick,
    this.isTemplate = false,
  }) : super(key: key);

  final double height = 100;
  final double width = 120;

  @override
  Widget build(BuildContext context) {
    int costOptions = context.read<ProductCubit>().getCostDefaultOptions(
              model.optionIds,
            ) ??
        0;
    return InkWell(
      borderRadius: BorderRadius.circular(spaceXS),
      overlayColor: MaterialStateProperty.all(
        Theme.of(context).primaryColor.withOpacity(
              opaXS,
            ),
      ),
      onTap: onClick,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(spaceXS),
            child: AppImageWidget(
              image: model.image,
              height: height,
              width: width,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: spaceXXS,
              horizontal: spaceXS,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: fontMD,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: spaceXXS,
                    ),
                    Text(
                      numberToCurrency(model.cost + costOptions, 'đ'),
                      style: const TextStyle(fontSize: fontMD),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
