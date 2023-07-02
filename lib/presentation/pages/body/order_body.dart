import 'package:flutter/material.dart';

class OrderBody extends StatefulWidget {
  const OrderBody({Key? key}) : super(key: key);

  @override
  State<OrderBody> createState() => _OrderBodyState();
}

class _OrderBodyState extends State<OrderBody> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Order body'),
    );
  }
}
