import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/blocs/interval/interval_bloc.dart';
import '../../data/models/member_model.dart';
import '../res/dimen/dimens.dart';
import '../widgets/member_widget.dart';

class MemberSearchScreen extends StatefulWidget {
  const MemberSearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MemberSearchScreen> createState() => _MemberSearchScreenState();
}

class _MemberSearchScreenState extends State<MemberSearchScreen> {
  bool expanded = false;

  double oldPixel = 0;
  double gap = 2;
  double direction = -1;

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
          'Tìm kiếm thành viên',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<IntervalBloc<MemberModel>, IntervalState>(
        builder: (context, state) {
          var list = <MemberModel>[];
          if (state is IntervalLoaded<MemberModel>) {
            list = state.list;
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                        child: GridView.builder(
                          padding: const EdgeInsets.only(
                              top: spaceXXS, bottom: dimMD),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(spaceXS),
                              child: MemberWidget(
                                model: list[index],
                                onClick: () {
                                  Navigator.pop(context, list[index]);
                                },
                              ),
                            );
                          },
                          itemCount: list.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 4,
                          ),
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
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: dimXXS),
            padding: const EdgeInsets.all(spaceXS),
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
                    .read<IntervalBloc<MemberModel>>()
                    .add(IntervalSearch(key: value));
              },
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
