import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/exception/app_message.dart';
import 'package:sale_app/presentation/dialogs/app_dialog.dart';
import 'package:sale_app/presentation/pages/support/alert_page.dart';
import 'package:sale_app/presentation/widgets/tabbar/tab_bar_widget.dart';

import '../../../business_logic/cubits/pos_cubit.dart';
import '../../../business_logic/states/pos_state.dart';
import '../../app_router.dart';
import '../../res/dimen/dimens.dart';
import '../../widgets/pos_widget.dart';

class OrderBody extends StatefulWidget {
  const OrderBody({Key? key}) : super(key: key);

  @override
  State<OrderBody> createState() => _OrderBodyState();
}

class _OrderBodyState extends State<OrderBody> {
  String _title = '';
  String _error = '';
  final _controller = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        print(state.index);
        print(state.listPos.length);
        if (state.index != null) {
          print(state.listPos[state.index!]);
        }
        print(state.listPos.map((e) => e.toMap()));
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: spaceSM),
                Expanded(
                  child: Material(
                    color: Colors.white10,
                    child: Stack(
                      children: [
                        Container(
                          height: 48,
                          width: double.maxFinite,
                          margin: const EdgeInsets.symmetric(vertical: spaceSM),
                          padding: const EdgeInsets.all(spaceSM),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(spaceXS),
                            border: Border.all(
                              color: Colors.black54,
                              width: 0.5,
                            ),
                          ),
                          child: TextField(
                            controller: _controller,
                            keyboardType: TextInputType.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                            decoration: const InputDecoration(
                              hintText: 'Member code',
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: spaceSM),
                GestureDetector(
                  onTap: () {
                    if (_controller.text.isEmpty) {
                      Navigator.pushNamed(
                        context,
                        AppRouter.qrCode,
                      ).then(
                        (value) async {
                          if (value != null) {
                            context.read<PosCubit>().addNewTab(
                                  value as String,
                                  true,
                                );
                          }
                        },
                      );
                    } else {
                      context.read<PosCubit>().addNewTab(
                            _controller.text,
                            true,
                          );
                      _controller.clear();
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: const Icon(Icons.qr_code),
                ),
                const SizedBox(width: spaceSM),
              ],
            ),
            Expanded(
              child: TabBarWidget(
                list: state.names,
                page: state.index != null
                    ? SizedBox(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        child: PosWidget(
                          model: state.currentPos!,
                          create: () async {
                            var r = await context.read<PosCubit>().createCart();

                            if (mounted) {
                              if (r) {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AppDialog(
                                      message: AppMessage(
                                        type: AppMessageType.success,
                                        title: 'Đặt hàng thành công!',
                                        content:
                                            'Bạn có muốn xoá đơn hàng vừa mới đặt không?',
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                            child: const Text('Giữ'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                        CupertinoDialogAction(
                                          child: const Text('Xoá'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            context
                                                .read<PosCubit>()
                                                .removeCurrentTab();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Tạo đơn hàng không thành công!'),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      )
                    : const AlertPage(
                        icon: Icon(
                          Icons.add_circle,
                          size: 48,
                          color: Colors.orange,
                        ),
                        type: AlertType.empty,
                        description: 'Chưa có đơn nào',
                      ),
                index: state.index ?? 0,
                onDelete: (i) {
                  context.read<PosCubit>().removeTab(i);
                },
                onClick: (i) {
                  context.read<PosCubit>().setIndex(i);
                },
                onAdd: () {
                  _error = '';
                  showCupertinoDialog(
                    context: context,
                    builder: (ctx) {
                      return CupertinoAlertDialog(
                        title: const Text('Tạo thẻ mới'),
                        content: Column(
                          children: [
                            const Text(
                              '* Bạn phải nhập nhập tên của khách để phân biệt các thẻ.',
                            ),
                            Material(
                              color: Colors.white10,
                              child: Stack(
                                children: [
                                  Container(
                                    height: 48,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: spaceSM),
                                    padding: const EdgeInsets.all(spaceSM),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(spaceXS),
                                      border: Border.all(
                                          color: Colors.black54, width: 0.5),
                                    ),
                                    child: TextField(
                                      keyboardType: TextInputType.name,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                      onChanged: (value) {
                                        _title = value;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'Tên của khách',
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_error.isNotEmpty)
                              Text(
                                _error,
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('Huỷ'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text('Tạo'),
                            onPressed: () {
                              if (_title.isEmpty) {
                                // setState(() {
                                //   _error =
                                //       '';
                                // });
                              } else {
                                context
                                    .read<PosCubit>()
                                    .addNewTab(_title, false);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
