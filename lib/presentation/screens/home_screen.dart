import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/business_logic/cubits/auth_cubit.dart';
import 'package:sale_app/presentation/app_router.dart';
import 'package:sale_app/presentation/dialogs/app_dialog.dart';
import 'package:sale_app/presentation/pages/body/cart_body.dart';
import 'package:sale_app/presentation/res/dimen/dimens.dart';

import '../pages/body/order_body.dart';
import '../pages/body/product_body.dart';
import '../../business_logic/cubits/home_cubit.dart';
import '../../business_logic/states/home_state.dart';
import '../pages/support/loading_page.dart';
import '../widgets/navigation_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget _getBody(HomeBodyType type) {
    Widget body;
    switch (type) {
      case HomeBodyType.order:
        body = const OrderBody();
        break;
      case HomeBodyType.product:
        body = const ProductBody();
        break;
      case HomeBodyType.promotion:
        body = const CartBody();
        break;
      case HomeBodyType.cart:
        body = const CartBody();
        break;
      default:
        body = const LoadingPage();
        break;
    }
    return body;
  }

  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              state.type.label,
              style: const TextStyle(
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
          body: Builder(
            builder: (context) {
              return _getBody(
                state.type,
              );
            },
          ),
          bottomNavigationBar: NavigationWidget(
            type: state.type,
            onClick: (type) {
              context.read<HomeCubit>().setBody(type);
            },
          ),
        );
      },
    );
  }
}
