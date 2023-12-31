import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubits/cart_cubit.dart';
import '../../business_logic/states/carts_state.dart';
import '../../data/models/cart_model.dart';
import '../pages/support/alert_page.dart';
import '../res/dimen/dimens.dart';
import '../widgets/cart/cart_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var selected = 0;
  final ScrollController _controller = ScrollController();
  final listPosition = <double>[0, 0, 0];

  @override
  void initState() {
    _controller.addListener(() {
      listPosition[selected] = _controller.position.pixels;
      if (_controller.position.atEdge) {
        if (_controller.position.pixels == 0) {
          // atTop
        } else {
          var state = context.read<CartCubit>().state;
          if (state is CartsLoaded) {
            String id = state.statuses[selected].id;
            if (context.read<CartCubit>().hasNext(id)) {
              context.read<CartCubit>().loadMore(id);
            }
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hệ thống nhận đơn online'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'Màn hình nhận đơn',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: fontXXL,
                ),
              ),
            ),
          ),
          Container(width: 1,
          height: double.maxFinite,color: Colors.grey,),
          Expanded(
            child: BlocBuilder<CartCubit, CartsState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case CartsLoaded:
                    state as CartsLoaded;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          alignment: WrapAlignment.start,
                          children: [
                            for (var index = 0;
                                index < state.statuses.length;
                                index++)
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 4,
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    context.read<CartCubit>().tap(
                                          state.statuses[index].id,
                                        );
                                    setState(() {
                                      selected = index;
                                    });
                                    // _controller.jumpTo(listPosition[selected]);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withAlpha(
                                        selected == index ? 80 : 20,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      state.statuses[index].name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: fontLG,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                        Expanded(
                          child: _getCarts(
                            state.listCarts[state.statuses[selected].id]
                                    ?.list ??
                                [],
                            state.statuses[selected].id == 'done',
                          ),
                        ),
                      ],
                    );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCarts(List<CartModel> carts, bool isSuccess) {
    if (carts.isEmpty) {
      return AlertPage(
        icon: ClipRRect(
          borderRadius: BorderRadius.circular(dimXL / 2),
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.orange,
              BlendMode.color,
            ),
            child: Image.asset(
              'assets/images/icon_default.png',
              width: dimXL,
              height: dimXL,
            ),
          ),
        ),
        type: AlertType.warning,
        description: 'Chưa có dữ liệu',
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<CartCubit>().refresh(selected);
      },
      child: ListView.separated(
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Divider(
            height: 1,
          ),
        ),
        // controller: _controller,
        itemBuilder: (context, index) => CartWidget(
          statusId: context.read<CartCubit>().getStatus(selected),
          model: carts[index],
          onClick: () {},
          isSuccess: isSuccess,
        ),
        itemCount: carts.length,
      ),
    );
  }
}
