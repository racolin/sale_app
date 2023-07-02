import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/presentation/pages/body/cart_body.dart';

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
            title: Text(state.type.label),
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
