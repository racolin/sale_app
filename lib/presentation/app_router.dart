import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/business_logic/cubits/pos_cubit.dart';
import 'package:sale_app/presentation/pages/support/loading_page.dart';
import 'package:sale_app/presentation/screens/qr_code_page.dart';

import '../business_logic/cubits/product_cubit.dart';
import '../business_logic/repositories/pos_repository.dart';
import '../business_logic/repositories/product_repository.dart';
import '../data/repositories/mock/cart_mock_repository.dart';
import '../data/repositories/mock/pos_mock_repository.dart';
import '../data/repositories/mock/product_mock_repository.dart';
import 'screens/splash_screen.dart';
import '../business_logic/cubits/cart_cubit.dart';
import '../business_logic/repositories/cart_repository.dart';
import '../business_logic/cubits/home_cubit.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

class AppRouter {
  static const String home = '/home';
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String qrCode = '/qr_code';

  static Route<dynamic>? onGenerateAppRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (context) {
            return const SplashScreen();
          },
        );
      case home:
        return MaterialPageRoute(
          builder: (context) {
            return MultiRepositoryProvider(
              providers: [
                RepositoryProvider<ProductRepository>(
                  create: (context) => ProductMockRepository(),
                ),
                RepositoryProvider<CartRepository>(
                  create: (context) => CartMockRepository(),
                ),
                RepositoryProvider<PosRepository>(
                  create: (context) => PosMockRepository(),
                ),
              ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<HomeCubit>(
                    create: (context) => HomeCubit(),
                  ),
                  BlocProvider<ProductCubit>(
                    create: (context) => ProductCubit(
                      repository: RepositoryProvider.of<ProductRepository>(
                        context,
                      ),
                    ),
                  ),
                  BlocProvider<CartCubit>(
                    lazy: false,
                    create: (context) => CartCubit(
                      repository: RepositoryProvider.of<CartRepository>(
                        context,
                      ),
                    ),
                  ),
                  BlocProvider<PosCubit>(
                    lazy: false,
                    create: (context) => PosCubit(
                      repository: RepositoryProvider.of<PosRepository>(
                        context,
                      ),
                    ),
                  ),
                ],
                child: const HomeScreen(),
              ),
            );
          },
        );
      case auth:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        );
      case qrCode:
        return MaterialPageRoute(
          builder: (context) => const QRCodePage(),
        );
    }
    return null;
  }
}
