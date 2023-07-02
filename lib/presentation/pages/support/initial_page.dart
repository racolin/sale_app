import 'package:flutter/material.dart';

import 'loading_page.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: LoadingWidget(),
    );
  }
}
