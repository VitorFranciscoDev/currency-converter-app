import 'package:currency_converter/infrastructure/presentation/preferences/intl_state.dart';
import 'package:currency_converter/infrastructure/presentation/preferences/theme_state.dart';
import 'package:currency_converter/domain/usecases/user_usecases.dart';
import 'package:currency_converter/infrastructure/presentation/auth/auth_state.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/app.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/bottom_navigator_widget.dart';
import 'package:currency_converter/infrastructure/repositories/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final userRepository = UserRepositoryImpl();
  final userUseCases = UserUseCases(repository: userRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => IntlProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider(userUseCases: userUseCases)),
        ChangeNotifierProvider(create: (_) => BottomNavigatorProvider()),
      ],
      child: const MyApp(),
    ),
  );
}