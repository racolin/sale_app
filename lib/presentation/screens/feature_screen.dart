import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/presentation/app_router.dart';
import 'package:sale_app/presentation/res/dimen/dimens.dart';

import '../../business_logic/cubits/auth_cubit.dart';
import '../dialogs/app_dialog.dart';

class FeatureScreen extends StatelessWidget {
  const FeatureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Màn hình chức năng'),
        actions: [
          IconButton(
              onPressed: () async {
                var res = await context.read<AuthCubit>().logout();
                if (context.mounted) {
                  if (res != null) {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return AppDialog(
                          message: res!,
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
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRouter.sale);
              },
              child: Container(
                margin: const EdgeInsets.all(dimXXS),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(dimXXS),
                  color: Colors.orange,
                ),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.store_rounded,
                      color: Colors.white,
                      size: dimXXL,
                    ),
                    Text(
                      'Bán hàng tại quầy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: dimMD,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRouter.cart);
              },
              child: Container(
                margin: const EdgeInsets.all(dimXXS),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(dimXXS),
                  color: Colors.blue,
                ),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.online_prediction_rounded,
                      color: Colors.white,
                      size: dimXXL,
                    ),
                    Text(
                      'Nhận đơn online',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: dimMD,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
