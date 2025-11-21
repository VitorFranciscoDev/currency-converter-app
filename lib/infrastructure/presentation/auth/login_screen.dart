import 'package:currency_converter/infrastructure/presentation/auth/auth_state.dart';
import 'package:currency_converter/infrastructure/presentation/auth/register_screen.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/alert_dialog_widget.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/bottom_navigator_widget.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/divider_widget.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/elevated_button_widget.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/logo_widget.dart';
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

  Future<void> _login() async {
    final provider = context.read<AuthProvider>();

    final isValid = provider.validateLoginFields(_controllerEmail.text, _controllerPassword.text);

    if(!isValid) return;

    try {
      final user = await provider.login(_controllerEmail.text, _controllerPassword.text);

      if(user != null) {
        showDialog(
          context: context, 
          builder: (context) => AlertDialogWidget(
            title: "Login Successful!", 
            action2: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigatorWidget()));
              _clearFields();
            }, 
            action2message: "Enter",
          ),
        );
      } else {
        showDialog(
          context: context, 
          builder: (context) => AlertDialogWidget(
            title: "Email or Password Invalid.", 
            action2: () => Navigator.pop(context), 
            action2message: "Ok",
          ),
        );
      }
    } catch(error) {
      showDialog(
        context: context, 
        builder: (context) => AlertDialogWidget(
          title: "Unexpected Error.", 
          action2: () => Navigator.pop(context), 
          action2message: "Ok",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsGeometry.symmetric(horizontal: 30),
            child: Column(
              children: [
                // Logo
                LogoWidget(isHorizontal: true, size: 40),
          
                const SizedBox(height: 30),
          
                // Form
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.background,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
          
                      const Text("Log In to trade currencies."),
          
                      const SizedBox(height: 20),
          
                      // Email
                      TextFieldWidget(
                        controller: _controllerEmail, 
                        label: "Email", 
                        hint: "your@email.com",
                        error: provider.errorEmail,
                      ),
          
                      const SizedBox(height: 10),
          
                      // Password
                      TextFieldWidget(
                        controller: _controllerPassword, 
                        label: "Password", 
                        hint: "password",
                        error: provider.errorPassword,
                        isPassword: true,
                      ),
          
                      const SizedBox(height: 10),
          
                      // Button
                      ElevatedButtonWidget(
                        function: () => _login(), 
                        text: "Sign In",
                      ),
          
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
          
                // Divider
                DividerWidget(),
          
                const SizedBox(height: 20),
          
                // Navigation to Register Button
                OutlinedButtonWidget(
                  function: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                    _clearFields();
                    provider.clearValidationErrors();
                  }, 
                  message1: "Doesn't have an account? ", 
                  message2: "Create one!",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}