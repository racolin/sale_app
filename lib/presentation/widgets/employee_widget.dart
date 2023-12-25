import 'package:flutter/material.dart';
import 'package:sale_app/data/models/employee_model.dart';
import 'package:sale_app/presentation/res/dimen/dimens.dart';
import 'package:sale_app/presentation/widgets/app_image_widget.dart';

class EmployeeWidget extends StatelessWidget {
  final EmployeeModel model;
  final bool isSelected;
  final VoidCallback onClick;

  const EmployeeWidget({
    Key? key,
    required this.model,
    required this.onClick,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        margin: const EdgeInsets.only(right: spaceXS),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(spaceXS),
          color: isSelected ? Colors.yellow : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: spaceXS, vertical: spaceXS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImageWidget(
              image: model.avatar,
              height: 28,
              width: 28,
              borderRadius: BorderRadius.circular(16),
            ),
            const SizedBox(width: spaceXS),
            Text(
              model.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
