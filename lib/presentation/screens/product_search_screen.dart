import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/blocs/interval/interval_bloc.dart';
import '../../data/models/product_model.dart';
import '../res/dimen/dimens.dart';
import '../res/strings/values.dart';
import '../widgets/product/product_widget.dart';

class ProductSearchScreen extends StatefulWidget {

  const ProductSearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  bool expanded = false;

  double oldPixel = 0;
  double gap = 2;
  double direction = -1;

  @override
  void initState() {
    context.read<IntervalBloc<ProductModel>>().add(IntervalSearch(key: ''));
    super.initState();
  }

  void onScroll() {
    setState(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: spaceXL,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        title: Text(
          'Tìm kiếm sản phẩm',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<IntervalBloc<ProductModel>, IntervalState>(
        builder: (context, state) {
          var list = <ProductModel>[];
          if (state is IntervalLoaded<ProductModel>) {
            list = state.list;
          }
          return Column(
            children: [
              _getSearchBar(context),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (!notification.metrics.outOfRange) {
                      if ((notification.metrics.pixels - oldPixel).abs() >
                              gap &&
                          notification.metrics.axis == Axis.vertical) {
                        double sub = notification.metrics.pixels - oldPixel;
                        if (direction * sub > 0) {
                          direction = -direction;
                          onScroll();
                        }
                      }
                      oldPixel = notification.metrics.pixels;
                    }
                    return true;
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                              top: spaceXXS, bottom: dimMD),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(spaceXS),
                              child: ProductWidget(
                                model: list[index], onClick: () {  },
                              ),
                            );
                          },
                          itemCount: list.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _getSearchBar(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: dimMD),
      padding: const EdgeInsets.all(spaceXS),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(spaceXS),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              onChanged: (value) {
                context
                    .read<IntervalBloc<ProductModel>>()
                    .add(IntervalSearch(key: value));
              },
            ),
          ),
          const SizedBox(
            width: spaceXXS,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(spaceXS),
            child: Container(
              padding: const EdgeInsets.all(spaceXXS),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(spaceXS),
              ),
              child: const Text(
                txtCancel,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
