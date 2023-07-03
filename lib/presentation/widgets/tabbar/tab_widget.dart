import 'package:flutter/material.dart';

import '../../res/dimen/dimens.dart';

class TabWidget extends StatelessWidget {
  final String name;
  final VoidCallback? onClick;
  final VoidCallback onDelete;

  const TabWidget({
    Key? key,
    required this.name,
    this.onClick,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: spaceXXS,
        horizontal: spaceXS,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        color: null != onClick ? Colors.white54 : Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: onClick,
            child: Container(
              alignment: Alignment.centerLeft,
              height: 32,
              width: 128,
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.close_rounded,
              size: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
