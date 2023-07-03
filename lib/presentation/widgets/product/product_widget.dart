import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/business_logic/cubits/cart_cubit.dart';
import 'package:sale_app/data/models/pos_model.dart';
import 'package:sale_app/presentation/bottom_sheet/product_bottom_sheet.dart';
import 'package:sale_app/presentation/dialogs/app_dialog.dart';
import 'package:sale_app/presentation/res/strings/values.dart';

import '../../../business_logic/cubits/pos_cubit.dart';
import '../../../business_logic/cubits/product_cubit.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/models/product_model.dart';
import '../../../supports/convert.dart';
import '../../res/dimen/dimens.dart';
import '../app_image_widget.dart';

class ProductWidget extends StatelessWidget {
  final ProductModel model;
  final bool isTemplate;

  const ProductWidget({
    Key? key,
    required this.model,
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
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) {
            return BlocProvider<PosCubit>.value(
              value: BlocProvider.of<PosCubit>(context),
              child: BlocProvider<ProductCubit>.value(
                value: BlocProvider.of<ProductCubit>(context),
                child: ProductBottomSheet(
                  product: model,
                  isTemplate: isTemplate,
                ),
              ),
            );
          },
        );
      },
      child: SizedBox(
        height: height,
        child: Row(
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
            Expanded(
              child: Padding(
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
                          maxLines: 1,
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
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            var options = <String>[];

                            for (var o in model.optionIds) {
                              var item = context
                                  .read<ProductCubit>()
                                  .getProductOptionById(o);
                              if (item != null) {
                                options.addAll(item.defaultSelect);
                              }
                            }
                            var r = context.read<PosCubit>().addProduct(
                                  PosProductModel(
                                    id: model.id,
                                    name: model.name,
                                    options: options,
                                    amount: 1,
                                    note: '',
                                  ),
                                );
                            ScaffoldMessenger.of(context).clearSnackBars();
                            if (r) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Thêm sản phẩm vào đơn hàng thành công',
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Bạn chưa tạo đơn',
                                  ),
                                ),
                              );
                            }
                          },
                          splashRadius: spaceXL,
                          icon: const Icon(
                            Icons.add_circle_sharp,
                            color: Colors.deepOrangeAccent,
                            size: fontXXL,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
