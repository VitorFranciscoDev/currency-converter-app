//import 'package:currency_converter/core/intl/intl_state.dart';
import 'package:currency_converter/core/constants/theme.dart';
import 'package:currency_converter/infrastructure/presentation/preferences/theme_state.dart';
//import 'package:currency_converter/infrastructure/presentation/auth/auth_state.dart';
import 'package:currency_converter/infrastructure/presentation/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //final intlProvider = context.watch<IntlProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    //final authProvider = context.watch<AuthProvider>();
    
    return MaterialApp(
      /*
      locale: intlProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
        Locale('es', 'ES'),
      ],
      */
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.currentThemeMode,
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}