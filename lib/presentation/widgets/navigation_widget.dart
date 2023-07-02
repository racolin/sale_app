import 'package:flutter/material.dart';

import '../../business_logic/states/home_state.dart';
import '../res/dimen/dimens.dart';
import '../res/strings/values.dart';

class NavigationWidget extends StatefulWidget {
  final Function(HomeBodyType) onClick;
  final HomeBodyType type;

  const NavigationWidget({
    Key? key,
    required this.type,
    required this.onClick,
  }) : super(key: key);

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        widget.onClick(HomeBodyType.values[index]);
      },
      currentIndex: widget.type.index,
      unselectedItemColor: Colors.grey,
      selectedFontSize: fontXS,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      unselectedFontSize: fontXS,
      selectedItemColor: primaryColor,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_rounded),
          tooltip: txtOrder,
          label: txtOrder,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_food_beverage_outlined),
          tooltip: txtProduct,
          label: txtProduct,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          tooltip: txtCart,
          label: txtCart,
        ),
      ],
    );
  }
}
