import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/mock_credentials.dart';
import 'main_navigation_wrapper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Design System Colors
  static const neonGreen = Color(0xFFB4FF39);
  static const deepDark = Color(0xFF0F0B1B);
  static const darkPurple = Color(0xFF1A0F2E);
  static const purple = Color(0xFF7C3AED);

  void _login() {
    if (_usernameController.text == MockCredentials.username &&
        _passwordController.text == MockCredentials.password) {
      // Navigate to home or show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful!'),
          backgroundColor: neonGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      // Navigate to MainNavigationWrapper
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainNavigationWrapper()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Credentials'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/login_bg.png', fit: BoxFit.cover),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    deepDark.withOpacity(0.8),
                    deepDark,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Logo / Title
                  // Logo
                  Image.asset('assets/logo_bgrem.png', height: 120),
                  const SizedBox(height: 16),
                  Text(
                    'Experience the perfect venue',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: Colors.white70,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Fields
                  _buildTextField(
                    controller: _usernameController,
                    hint: 'Username',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  const SizedBox(height: 40),

                  // Buttons
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: _login,
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: neonGreen.withOpacity(0.1),
                  //       foregroundColor: neonGreen,
                  //       padding: const EdgeInsets.symmetric(vertical: 16),
                  //       side: const BorderSide(color: neonGreen),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //       elevation: 0,
                  //     ),
                  //     child: Text(
                  //       'SIGN UP',
                  //       style: GoogleFonts.dmSans(
                  //         fontWeight: FontWeight.bold,
                  //         letterSpacing: 1.0,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: neonGreen,
                        foregroundColor: deepDark,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: neonGreen.withOpacity(0.4),
                        elevation: 8,
                      ),
                      child: Text(
                        'LOGIN',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.dmSans(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          prefixIcon: Icon(icon, color: const Color(0xFF7C3AED)), // Purple icon
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.white54,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
