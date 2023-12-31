import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/business_logic/cubits/auth_cubit.dart';
import 'package:sale_app/presentation/dialogs/app_dialog.dart';
import 'package:sale_app/presentation/res/dimen/dimens.dart';
import 'package:sale_app/presentation/res/strings/values.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(spaceMD),
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: spaceXL,
                    ),
                    Text(
                      txtWelcome,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(
                      height: spaceSM,
                    ),
                    Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      width: 280,
                    ),
                    const SizedBox(
                      height: spaceXXL,
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 48,
                          margin: const EdgeInsets.symmetric(vertical: spaceSM),
                          padding: const EdgeInsets.all(spaceSM),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(spaceXS),
                            border:
                                Border.all(color: Colors.black54, width: 0.5),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                            onChanged: (value) {
                              _username = value;
                            },
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          left: spaceSM,
                          child: Text(
                            'Username',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: spaceSM,
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 48,
                          margin: const EdgeInsets.symmetric(vertical: spaceSM),
                          padding: const EdgeInsets.all(spaceSM),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(spaceXS),
                            border:
                                Border.all(color: Colors.black54, width: 0.5),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.name,
                            obscureText: true,
                            style: Theme.of(context).textTheme.bodyLarge,
                            onChanged: (value) {
                              _password = value;
                            },
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          left: spaceSM,
                          child: Text(
                            'Password',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: spaceSM,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          var message = await context
                              .read<AuthCubit>()
                              .login(_username, _password);
                          if (mounted && message != null) {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return AppDialog(
                                  message: message,
                                  actions: [
                                    CupertinoDialogAction(
                                      child: const Text(txtConfirm),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text(
                          txtLogIn,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Image.asset(
                'assets/images/login_bg.jpeg',
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
