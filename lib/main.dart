import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/business_logic/cubits/auth_cubit.dart';
import 'package:sale_app/business_logic/states/auth_state.dart';
import 'package:sale_app/presentation/app_router.dart';
import 'package:sale_app/presentation/pages/support/alert_page.dart';
import 'package:sale_app/presentation/screens/feature_screen.dart';
import 'package:sale_app/presentation/screens/login_screen.dart';
import 'package:sale_app/presentation/screens/splash_screen.dart';

import '../business_logic/cubits/internet_cubit.dart';
import 'business_logic/repositories/auth_repository.dart';
import 'data/repositories/api/auth_api_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (context) => AuthApiRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<InternetCubit>(
            create: (context) => InternetCubit(),
          ),
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              repository: RepositoryProvider.of<AuthRepository>(
                context,
              ),
            ),
          ),
        ],
        child: Builder(
          builder: (context) {
            return BlocBuilder<InternetCubit, InternetState>(
              builder: (context, state) {
                return MaterialApp(
                  key: ValueKey(state.type),
                  // localizationsDelegates: [LocalizationsDelegate],
                  title: 'Sale App',
                  theme: ThemeData(
                    useMaterial3: false,
                    scaffoldBackgroundColor:
                        const Color.fromRGBO(244, 244, 244, 1),
                    textTheme: const TextTheme(
                      titleLarge: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.1,
                      ),
                      titleMedium: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1.25,
                      ),
                      titleSmall: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                        height: 1.25,
                      ),
                      bodyLarge: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                      bodyMedium: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w300,
                        height: 1.25,
                      ),
                      bodySmall: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w300,
                        height: 1.25,
                      ),
                    ),
                    primarySwatch: const MaterialColor(
                      0xFFFFC375,
                      {
                        50: Color(0xFFFFF4E2),
                        100: Color(0xFFFFE2B6),
                        200: Color(0xFFFFCF87),
                        300: Color(0xFFFFBC58),
                        400: Color(0xFFFFAD37),
                        500: Color(0xFFFF9E22),
                        600: Color(0xFFFB931F),
                        700: Color(0xFFF4841C),
                        800: Color(0xFFEE571A),
                        900: Color(0xFFE45C16),
                      },
                    ),
                  ),
                  home: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      switch (state.runtimeType) {
                        case AuthInitial:
                          return const SplashScreen();
                        case AuthNoLogin:
                          return const LoginScreen();
                        case AuthLogin:
                          return const FeatureScreen();
                      }
                      return const AlertPage(
                        icon: Icon(Icons.ac_unit),
                        type: AlertType.warning,
                        description: 'Undefined',
                      );
                    },
                  ),
                  onGenerateRoute: AppRouter.onGenerateAppRoute,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
