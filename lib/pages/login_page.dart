import 'package:flutter/material.dart';
import 'package:food_order_app_flutter_firebase/components/auth_main_top_container.dart';
import 'package:food_order_app_flutter_firebase/components/main_button.dart';
import 'package:food_order_app_flutter_firebase/components/main_text_filed.dart';
import 'package:food_order_app_flutter_firebase/constants/style.dart';
import 'package:food_order_app_flutter_firebase/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            const Icon(Icons.error, size: 50, color: Colors.redAccent),
            const SizedBox(height: 10),
            Text(message, style: const TextStyle(fontSize: 18)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Try Again",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> login() async {
    final authService = AuthService();
    setState(() => _isLoading = true);

    try {
      await authService.signInWithEmailPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(e.toString());
    } finally {
      if (!mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await AuthService().signInWithGoogle();
    } catch (e) {
      if (!mounted) return; // <— Add this guard before using context
      showErrorDialog("Google Sign-In failed: $e");
    } finally {
      if (!mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SingleChildScrollView(
            child: Column(
              children: [
                AuthMainTopContainer(screenHeight: screenHeight),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      MainTextField(
                        icon: Icons.email,
                        controller: emailController,
                        hintText: "Email",
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MainTextField(
                        icon: Icons.lock_outline_rounded,
                        controller: passwordController,
                        hintText: "Password",
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      MainButton(
                        text: "Sign In",
                        onTap: _isLoading ? null : () => login(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Not a Member?", style: smBoldTextStyle),
                          TextButton(
                            onPressed: _isLoading ? null : widget.onTap,
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(
                                  context,
                                ).colorScheme.inversePrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // _buildSocialButton(
                      //   context,
                      //   iconPath: 'images/apple.png',
                      //   text: "Continue with Apple",
                      //   onTap: () {},
                      // ),
                      const SizedBox(height: 10),
                      _buildSocialButton(
                        context,
                        iconPath: 'images/google.png',
                        text: "Continue with Google",
                        onTap: _isLoading ? null : () => signInWithGoogle(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ✅ Fullscreen Loading Overlay
        if (_isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.4),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required String iconPath,
    required String text,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, height: 30),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
