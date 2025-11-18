import 'package:currency_converter/core/intl/intl_state.dart';
import 'package:currency_converter/core/theme/theme_state.dart';
import 'package:currency_converter/domain/usecases/auth_usecases.dart';
import 'package:currency_converter/infrastructure/presentation/auth/auth_state.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/app.dart';
import 'package:currency_converter/infrastructure/repositories/auth_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final authRepository = AuthRepositoryImpl();
  final authUseCases = AuthUseCases(repository: authRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => IntlProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider(authUseCases: authUseCases)),
      ],
      child: const MyApp(),
    ),
  );
}