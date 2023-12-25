import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/presentation/pages/support/loading_page.dart';

class PromotionBody extends StatefulWidget {

  const PromotionBody({
    Key? key,
  }) : super(key: key);

  @override
  State<PromotionBody> createState() => _PromotionBodyState();
}

class _PromotionBodyState extends State<PromotionBody> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromotionCubit, PromotionState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case PromotionInitial:
            return const SizedBox();
          case PromotionLoading:
            return const LoadingPage();
          case PromotionLoaded:
            state as PromotionLoaded;
            var listType = state.listType;
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return _getListPromotion(
                  listType[index].name,
                  state.getPromotionsByCategoryId(
                    listType[index].id,
                  ),
                );
              },
              itemCount: listType.length,
            );
        }
        return const SizedBox();
      },
    );
  }

  Widget _getListPromotion(
    String title,
    List<PromotionModel> shortPromotions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: spaceSM),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: spaceXXS,
            horizontal: spaceXS,
          ),
          child: Text(
            title,
            style: const TextStyle(
              height: 1.25,
              fontSize: fontLG,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(spaceXS),
            child: PromotionWidget(
              // height: 100
              model: shortPromotions[index],
            ),
          ),
          itemCount: shortPromotions.length,
        )
      ],
    );
  }
}
