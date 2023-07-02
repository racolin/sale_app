import 'package:flutter/material.dart';
import 'package:sale_app/data/models/cart_model.dart';
import 'package:sale_app/presentation/res/dimen/dimens.dart';

import '../../../supports/convert.dart';
import 'cart_product_widget.dart';

class CartWidget extends StatelessWidget {
  final CartModel model;
  final VoidCallback? onClick;
  final bool isSuccess;

  const CartWidget({
    Key? key,
    required this.model,
    this.isSuccess = false,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: spaceSM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      model.categoryId.image,
                      height: 20,
                      width: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    model.categoryId.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: spaceXS),
              Text(
                model.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              if (model.username != null) Padding(
                padding: const EdgeInsets.only(top: spaceXS),
                child: Row(
                  children: [
                    const Text(
                      'Người nhận',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Spacer(),
                    Text(
                      model.username!,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              if (model.phone != null) Padding(
                padding: const EdgeInsets.only(top: spaceXS),
                child: Row(
                  children: [
                    const Text(
                      'Số điện thoại',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Spacer(),
                    Text(
                      model.phone!,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: spaceXS),
              const Text(
                'Sản phẩm đã chọn',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (context, index) => CartProductWidget(
                  amount: model.products[index].amount,
                  name: model.products[index].name,
                  note: model.products[index].note,
                  cost: model.products[index].cost,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: model.products.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
              ),
              if (model.voucherName != null) Padding(
                padding: const EdgeInsets.only(top: spaceXS),
                child: Row(
                  children: [
                    const Text(
                      'Khuyến mãi',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Spacer(),
                    Text(
                    model.voucherName!,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              if (model.fee != null && model.fee! > 0) Padding(
                padding: const EdgeInsets.only(top: spaceXS),
                child: Row(
                  children: [
                    const Text(
                      'Vận chuyển',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Spacer(),
                    Text(
                    numberToCurrency(model.fee!, 'đ'),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: spaceXS),
              Row(
                children: [
                  const Text(
                    'Thành tiền',
                    style: TextStyle(fontSize: 14),
                  ),
                  const Spacer(),
                  Text(
                    numberToCurrency(model.cost, 'đ'),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: spaceXS),
              Row(
                children: [
                  Text(
                    dateToString(model.time, 'HH:MM - dd/MM/yyyy'),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                  if (isSuccess)
                    if (model.rate == null)
                      const Text(
                        'Chưa đánh giá',
                        style: TextStyle(fontSize: 14),
                      )
                    else ...[
                      Text(
                        model.rate.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.orange,
                        ),
                      ),
                      const Icon(
                        Icons.star_rate_outlined,
                        size: 16,
                        color: Colors.orange,
                      ),
                    ],
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
