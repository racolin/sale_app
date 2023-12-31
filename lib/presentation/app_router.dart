import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/business_logic/cubits/member_cubit.dart';
import 'package:sale_app/business_logic/cubits/pos_cubit.dart';
import 'package:sale_app/business_logic/repositories/member_repository.dart';
import 'package:sale_app/data/models/member_model.dart';
import 'package:sale_app/data/repositories/api/cart_api_repository.dart';
import 'package:sale_app/data/repositories/api/member_api_repository.dart';
import 'package:sale_app/presentation/screens/cart_screen.dart';
import 'package:sale_app/presentation/screens/feature_screen.dart';
import 'package:sale_app/presentation/screens/member_search_screen.dart';
import 'package:sale_app/presentation/screens/qr_code_page.dart';

import '../business_logic/blocs/interval/interval_bloc.dart';
import '../business_logic/cubits/product_cubit.dart';
import '../business_logic/repositories/pos_repository.dart';
import '../business_logic/repositories/product_repository.dart';
import '../data/repositories/api/pos_api_repository.dart';
import '../data/repositories/api/product_api_repository.dart';
import 'screens/splash_screen.dart';
import '../business_logic/cubits/cart_cubit.dart';
import '../business_logic/repositories/cart_repository.dart';
import 'screens/login_screen.dart';
import 'screens/sale_screen.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String feature = '/feature';
  static const String sale = '/sale';
  static const String cart = '/cart';
  static const String qrCode = '/qr_code';

  static const String memberSearch = '/member_search';

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
      case auth:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        );
      case feature:
        return MaterialPageRoute(
          builder: (context) {
            return const FeatureScreen();
          },
        );
      case sale:
        return MaterialPageRoute(
          builder: (context) {
            return MultiRepositoryProvider(
              providers: [
                RepositoryProvider<ProductRepository>(
                  create: (context) => ProductApiRepository(),
                ),
                RepositoryProvider<PosRepository>(
                  create: (context) => PosApiRepository(),
                ),
              ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<ProductCubit>(
                    create: (context) => ProductCubit(
                      repository: RepositoryProvider.of<ProductRepository>(
                        context,
                      ),
                    ),
                  ),
                  BlocProvider<PosCubit>(
                    create: (context) => PosCubit(
                      repository: RepositoryProvider.of<PosRepository>(
                        context,
                      ),
                    ),
                  ),
                ],
                child: const SaleScreen(),
              ),
            );
          },
        );
      case cart:
        return MaterialPageRoute(
          builder: (context) {
            return RepositoryProvider<CartRepository>(
              create: (context) => CartApiRepository(),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<CartCubit>(
                    create: (context) => CartCubit(
                      repository: RepositoryProvider.of<CartRepository>(
                        context,
                      ),
                    ),
                  ),
                ],
                child: const CartScreen(),
              ),
            );
          },
        );
      case qrCode:
        return MaterialPageRoute(
          builder: (context) => const QRCodePage(),
        );
      case memberSearch:
        return MaterialPageRoute(
          builder: (ctx) => RepositoryProvider<MemberRepository>(
            create: (ctx2) => MemberApiRepository(),
            child: MultiBlocProvider(
              providers: [
                BlocProvider<MemberCubit>(
                  create: (ctx) => MemberCubit(
                    repository: RepositoryProvider.of<MemberRepository>(ctx),
                  ),
                ),
                BlocProvider<IntervalBloc<MemberModel>>(
                  create: (ctx) => IntervalBloc<MemberModel>(
                    submit: BlocProvider.of<MemberCubit>(ctx),
                  ),
                ),
              ],
              child: Builder(
                builder: (context) {
                  return const MemberSearchScreen();
                },
              ),
            ),
          ),
        );
    }
    return null;
  }
}
