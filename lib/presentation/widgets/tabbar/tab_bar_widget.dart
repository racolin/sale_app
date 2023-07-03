import 'package:flutter/material.dart';
import 'package:sale_app/presentation/res/dimen/dimens.dart';
import 'package:sale_app/presentation/widgets/tabbar/tab_widget.dart';

class TabBarWidget extends StatefulWidget {
  final List<String> list;
  final int index;
  final Widget page;
  final Function(int) onDelete;
  final Function(int) onClick;
  final VoidCallback onAdd;

  const TabBarWidget({
    Key? key,
    required this.list,
    required this.page,
    required this.index,
    required this.onDelete,
    required this.onClick,
    required this.onAdd,
  })  : assert((list.length > index && index >= 0) || (list.length == 0), "Index is out of list"),
        super(key: key);

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  var list = <String>[];
  Widget? page;

  @override
  void didUpdateWidget(covariant TabBarWidget oldWidget) {
    update();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    update();
    super.initState();
  }

  void update() {
    list = widget.list;
    page = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: spaceXS),
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < widget.list.length; i++)
                      TabWidget(
                        name: widget.list[i],
                        onClick: widget.index == i
                            ? null
                            : () {
                                widget.onClick(i);
                              },
                        onDelete: () {
                          widget.onDelete(i);
                        },
                      ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(8),
                ),
              ),
              height: 40,
              child: IconButton(
                onPressed: widget.onAdd,
                splashColor: null,
                splashRadius: 1,
                icon: const Icon(
                  Icons.add,
                  size: 22,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        Expanded(child: page ?? const SizedBox()),
      ],
    );
  }
}
