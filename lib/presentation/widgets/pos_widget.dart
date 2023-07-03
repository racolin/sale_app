import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sale_app/business_logic/cubits/home_cubit.dart';
import 'package:sale_app/business_logic/states/home_state.dart';

import '../../business_logic/cubits/pos_cubit.dart';
import '../../business_logic/cubits/product_cubit.dart';
import '../../data/models/pos_model.dart';
import '../../supports/convert.dart';
import '../bottom_sheet/pay_method_bottom_sheet.dart';
import '../res/dimen/dimens.dart';
import '../res/strings/values.dart';

class PosWidget extends StatefulWidget {
  final VoidCallback create;
  final PosModel model;

  const PosWidget({
    Key? key,
    required this.create,
    required this.model,
  }) : super(key: key);

  @override
  State<PosWidget> createState() => _PosWidgetState();
}

class _PosWidgetState extends State<PosWidget> {
  final _controller = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _getProducts(context, widget.model.products),
                  const SizedBox(height: 8),
                  _getTotal(
                    costs.fold(0, (p, e) => p + e),
                    0,
                    0,
                    widget.model.voucherId ?? '',
                  ),
                  const SizedBox(height: 8),
                  _getMethod(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          _getOrderField(
            'Tại quầy',
            widget.model.products.fold(0, (pre, e) => pre + e.amount),
            costs.fold(0, (p, e) => p + e),
            // state.calculateCost,
          ),
        ],
      ),
    );
  }

  Widget _getInfoItem(String name, String content,
      [VoidCallback? onClick, Icon? icon]) {
    Widget item = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: fontSM,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: spaceXXS),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon,
              const SizedBox(width: spaceXXS),
            ],
            Text(
              content,
              style: const TextStyle(
                fontSize: fontMD,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
    if (onClick != null) {
      item = InkWell(
        onTap: onClick,
        child: Ink(
          child: item,
        ),
      );
    }
    return item;
  }

  Widget _getTitle(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 55,
              width: double.maxFinite,
              alignment: Alignment.center,
              child: const Text(
                'Xác nhận đơn hàng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close_sharp,
                  size: 22,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              top: 19,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  // context.read<PosCubit>().clear();
                  // Navigator.pop(context);
                },
                child: const Text(
                  'Xoá',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _getProducts(
    BuildContext context,
    List<PosProductModel> products,
  ) {
    setup(products);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: const Text(
              'Sản phẩm đã chọn',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.orange.withAlpha(30),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                // padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              onPressed: () {
                context.read<HomeCubit>().setBody(HomeBodyType.product);
              },
              child: const Text(
                '+ Thêm',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          for (int i = 0; i < products.length; i++) ...[
            GestureDetector(
              onTap: () {},
              child: Slidable(
                key: ValueKey(i),
                endActionPane: ActionPane(
                  extentRatio: 0.4,
                  motion: const ScrollMotion(),
                  children: [
                    CustomSlidableAction(
                      padding: EdgeInsets.zero,
                      onPressed: null,
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 12,
                          right: 6,
                          top: 2,
                          bottom: 2,
                        ),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.edit_note_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            Text(
                              'SỬA',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomSlidableAction(
                      padding: EdgeInsets.zero,
                      onPressed: (context) {
                        var r = context.read<PosCubit>().removeProduct(i);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        if (r) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                              Text('Xoá sản phẩm thành công!'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                              Text('Xoá sản phẩm không thành công!'),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        width: double.maxFinite,
                        child: Container(
                          margin: const EdgeInsets.only(left: 6, right: 12),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                                size: 20,
                              ),
                              Text(
                                'XOÁ',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Expanded(child: _getProduct(products[i], costs[i])),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_double_arrow_left,
                        size: 16,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: spaceSM),
            const Divider(height: 1),
          ],
        ],
      ),
    );
  }

  List<int> costs = [];

  void setup(List<PosProductModel> products) {
    costs = [];
    for (var e in products) {
      var product = context.read<ProductCubit>().getProductById(e.id);
      if (product != null) {
        costs.add(
          (product.cost +
                  getCostOptions(
                    context,
                    e.options,
                  )) *
              e.amount,
        );
      }
    }
  }

  int getCostOptions(BuildContext context, List<String> options) {
    return context.read<ProductCubit>().getCostOptionsItem(
              options,
            ) ??
        0;
  }

  Widget _getProduct(PosProductModel model, int cost) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Text(
        model.amount.toString(),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: fontMD,
            ),
      ),
      title: Text(
        model.name,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: fontMD,
            ),
      ),
      subtitle: Text(model.options
          .map((e) =>
              context.read<ProductCubit>().getProductOptionItemById(e)?.name)
          .join(', ')),
      trailing: Text(
        numberToCurrency(cost, 'đ'),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 14,
            ),
      ),
    );
  }

  Widget _getTotal(
    int total,
    int fee,
    int voucherDiscount,
    String voucherName,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Text(
              'Tổng cộng',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Thành tiền'),
              Text(numberToCurrency(total, 'đ'))
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.only(bottom: spaceXS, top: spaceXS),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Material(
                    color: Colors.white10,
                    child: Stack(
                      children: [
                        Container(
                          height: 48,
                          width: double.maxFinite,
                          margin: const EdgeInsets.symmetric(vertical: spaceSM),
                          padding: const EdgeInsets.all(spaceSM),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(spaceXS),
                            border: Border.all(
                              color: Colors.black54,
                              width: 0.5,
                            ),
                          ),
                          child: TextField(
                            controller: _controller,
                            keyboardType: TextInputType.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                            decoration: const InputDecoration(
                              hintText: 'Voucher code',
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: spaceSM),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    if (_controller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Bạn phải nhập hoặc quét mã khuyến mãi!'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Thêm khuyến mãi thành công!'),
                        ),
                      );
                      context.read<PosCubit>().addNewTab(_controller.text,true);
                      // _controller.clear();
                      // FocusScope.of(context).unfocus();
                    }
                  },
                  child: const Icon(Icons.qr_code),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.only(bottom: spaceXS, top: spaceXS),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Số tiền thanh toán',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  numberToCurrency(total + fee - voucherDiscount, 'đ'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _getMethod() {
    return InkWell(
      onTap: () async {
        var pay = await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => const PayMethodBottomSheet(
            payMethod: null,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'Thanh toán',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/cash.png',
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 8),
                const Text('Tiền mặt'),
                const Spacer(),
                const Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _getOrderField(
    String type,
    int amount,
    int cost,
  ) {
    return Container(
      height: 72,
      color: Colors.orange,
      child: ListTile(
        title: Text(
          '$type | $amount $txtProduct',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        subtitle: Text(
          numberToCurrency(cost, 'đ'),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        trailing: ElevatedButton(
          onPressed: widget.create,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          child: Text(
            txtOrderNow.toUpperCase(),
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
