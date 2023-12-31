import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/business_logic/cubits/auth_cubit.dart';
import 'package:sale_app/data/models/product_model.dart';
import 'package:sale_app/presentation/dialogs/app_dialog.dart';
import 'package:sale_app/presentation/pages/body/pos_body.dart';
import 'package:sale_app/presentation/pages/body/topping_page.dart';
import 'package:sale_app/presentation/pages/support/alert_page.dart';
import 'package:sale_app/presentation/res/dimen/dimens.dart';

import '../pages/body/product_body.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({Key? key}) : super(key: key);

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  ProductModel? product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hệ thống bán hàng',
          style: TextStyle(
            fontSize: fontLG,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var res = await context.read<AuthCubit>().logout();
              if (mounted) {
                if (res != null) {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return AppDialog(
                        message: res,
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('Đồng ý'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    },
                  );
                }
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      endDrawer: Drawer(
        width: 450,
        child: product == null
            ? const AlertPage(
                icon: Icon(
                  Icons.check_box_outline_blank_rounded,
                  size: dimMD,
                  color: Colors.blue,
                ),
                type: AlertType.empty,
                description: 'Chưa chọn sản phẩm',
              )
            : ToppingPage(product: product!),
      ),
      body: Row(
        children: [
          const Expanded(
            flex: 2,
            child: PosBody(),
          ),
          Container(
            width: 1,
            height: double.maxFinite,
            color: Colors.grey,
          ),
          Expanded(
            flex: 3,
            child: Builder(
              builder: (context) {
                return ProductBody(onClick: (ProductModel e) {
                  setState(() {
                    product = e;
                  });
                  Scaffold.of(context).openEndDrawer();
                },);
              }
            ),
          ),
        ],
      ),
    );
  }
}
