import 'package:currency_converter/infrastructure/presentation/currency/home_screen.dart';
import 'package:currency_converter/infrastructure/presentation/currency/trade_screen.dart';
import 'package:currency_converter/infrastructure/presentation/preferences/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigatorProvider with ChangeNotifier {
  int _index = 0;

  int get index => _index;

  set index(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }
}

class BottomNavigatorWidget extends StatelessWidget {
  BottomNavigatorWidget({super.key});

  final List<Widget> _pages = [
    HomeScreen(),
    TradeScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final index = context.watch<BottomNavigatorProvider>().index;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: _pages[index],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.colorScheme.primary,
          selectedItemColor: theme.colorScheme.background,
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 12,
          unselectedFontSize: 11,
          onTap: (newIndex) => context.read<BottomNavigatorProvider>().index = newIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 26),
              activeIcon: Icon(Icons.home, size: 26),
              label: "Home Screen",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on_outlined, size: 26),
              activeIcon: Icon(Icons.monetization_on, size: 26),
              label: "Trade Screen",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined, size: 26),
              activeIcon: Icon(Icons.settings, size: 26),
              label: "Configurações",
            ),
          ],
        ),
      ),
    );
  }
}