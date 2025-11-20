import 'package:currency_converter/domain/entities/user.dart';
import 'package:currency_converter/infrastructure/presentation/auth/auth_state.dart';
import 'package:currency_converter/infrastructure/presentation/auth/login_screen.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/app.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/divider_widget.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/elevated_button_widget.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/logo_widget.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/outlined_button_widget.dart';
import 'package:currency_converter/infrastructure/presentation/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _controllerName = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();

  void _clearFields() {
    setState(() {
      _controllerName.clear();
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

  Future<void> _registerUser() async {
    final provider = context.read<AuthProvider>();

    final isValid = provider.validateRegisterFields(_controllerName.text, _controllerEmail.text, _controllerPassword.text);

    if(!isValid) return;

    final user = User(name: _controllerName.text, email: _controllerEmail.text, password: _controllerPassword.text);

    try {
      final index = await provider.registerUser(user);

      if(index > 0) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
        _clearFields();

        _showSnackBar("Register Successful", false);
      }
    } catch(error) {
      _showSnackBar("Unexpected Error.", true);
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                        "Welcome!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
          
                      const Text("Sign Up to see all currencies."),
          
                      const SizedBox(height: 20),
          
                      // Email
                      TextFieldWidget(
                        controller: _controllerEmail, 
                        label: "Name", 
                        hint: "name",
                        error: provider.errorEmail,
                      ),
          
                      const SizedBox(height: 10),
          
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
                        function: () => _registerUser(), 
                        text: "Sign Up",
                      ),
          
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
          
                const SizedBox(height: 20),
          
                DividerWidget(),
          
                const SizedBox(height: 20),
          
                OutlinedButtonWidget(
                  function: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    _clearFields();
                    provider.clearValidationErrors();
                  }, 
                  message1: "Already have an account? ", 
                  message2: "Go to Login",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}