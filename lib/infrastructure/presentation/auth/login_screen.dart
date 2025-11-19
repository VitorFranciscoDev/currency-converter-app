import 'package:currency_converter/infrastructure/presentation/auth/auth_state.dart';
import 'package:currency_converter/infrastructure/presentation/auth/register_screen.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/app.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/divider_widget.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/elevated_button_widget.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/outlined_button_widget.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();

  void _clearFields() {
    setState(() {
      _controllerEmail.clear();
      _controllerPassword.clear();
    });
  }

  void _showSnackBar(String message, bool error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(error ? Icons.error : Icons.check, color: error ? Colors.red : Colors.green),
            SizedBox(width: 8),
            Text(message, style: TextStyle(color: Colors.black)),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _login() async {
    final provider = context.read<AuthProvider>();

    final isValid = provider.validateLoginFields(_controllerEmail.text, _controllerPassword.text);

    if(!isValid) return;

    try {
      final user = await provider.login(_controllerEmail.text, _controllerPassword.text);

      if(user != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
        _clearFields();

        _showSnackBar("Login Successful", false);
      } else {
        _showSnackBar("Email or Password invalids.", true);
      }
    } catch(error) {
      _showSnackBar("Unexpected Error.", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email
            TextFieldWidget(
              controller: _controllerEmail, 
              label: "Email", 
              hint: "your@email.com",
            ),

            const SizedBox(height: 10),

            TextFieldWidget(
              controller: _controllerPassword, 
              label: "Password", 
              hint: "password",
            ),

            const SizedBox(height: 10),

            ElevatedButtonWidget(
              function: () => _login(), 
              text: "Sign In",
            ),

            const SizedBox(height: 20),

            DividerWidget(),

            const SizedBox(height: 20),

            OutlinedButtonWidget(
              function: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                _clearFields();
              }, 
              message1: "Doesn't have an account? ", 
              message2: "Create one!",
            ),
          ],
        ),
      ),
    );
  }
}