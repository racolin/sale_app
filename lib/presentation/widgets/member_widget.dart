import 'package:flutter/material.dart';

import '../../../data/models/member_model.dart';
import '../res/dimen/dimens.dart';

class MemberWidget extends StatelessWidget {
  final MemberModel model;
  final VoidCallback onClick;

  const MemberWidget({
    Key? key,
    required this.model,
    required this.onClick,
  }) : super(key: key);

  final double height = 100;
  final double width = 120;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(spaceXS),
      overlayColor: MaterialStateProperty.all(
        Theme.of(context).primaryColor.withOpacity(
              opaXS,
            ),
      ),
      onTap: onClick,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Container(
              height: 72,
              width: 72,
              color: Color(int.parse(model.rankColor.replaceFirst("#", "FF"),
                  radix: 16)),
              alignment: Alignment.center,
              child: Text(
                model.name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 56,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Code: ${model.code} (${model.rankName})',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: fontLG,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: spaceXXS,
                ),
                Text(
                  'Người dùng: ${model.name} (${model.phone})',
                  style: const TextStyle(
                    fontSize: fontLG,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
