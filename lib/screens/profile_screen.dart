import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Mock user data - replace with actual user data from backend/auth
  final Map<String, String> _userData = {
    'name': 'Dr. Jayapriya',
    'department': 'Artificial Intelligence and Data Science',
    'designation': 'Assistant Professor',
    'email': 'jayapriya@drngpit.ac.in',
    'phone': '+91 98765 43210',
    'employeeId': 'EMP2024001',
  };

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _handleLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A0F2E), Color(0xFF0F0B1B), Color(0xFF1A1230)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildProfileAvatar(),
                        const SizedBox(height: 32),
                        _buildUserInfo(),
                        const SizedBox(height: 24),
                        _buildInfoCards(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1625).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Profile',
                style: GoogleFonts.dmSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: _handleLogout,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFF4444).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF4444).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.logout, size: 18, color: Color(0xFFFF4444)),
                  const SizedBox(width: 6),
                  Text(
                    'Logout',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFF4444),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFB4FF39), Color(0xFF8FE526)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB4FF39).withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          _userData['name']!.split(' ').map((e) => e[0]).take(2).join(),
          style: GoogleFonts.dmSans(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F0B1B),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          _userData['name']!,
          style: GoogleFonts.dmSans(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _userData['designation']!,
          style: GoogleFonts.dmSans(
            fontSize: 16,
            color: const Color(0xFFB4FF39),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          _userData['department']!,
          style: GoogleFonts.dmSans(
            fontSize: 15,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoCards() {
    return Column(
      children: [
        _InfoCard(
          icon: Icons.email_outlined,
          label: 'Email',
          value: _userData['email']!,
        ),
        const SizedBox(height: 12),
        _InfoCard(
          icon: Icons.phone_outlined,
          label: 'Phone',
          value: _userData['phone']!,
        ),
        const SizedBox(height: 12),
        _InfoCard(
          icon: Icons.badge_outlined,
          label: 'Employee ID',
          value: _userData['employeeId']!,
        ),
        const SizedBox(height: 12),
        _InfoCard(
          icon: Icons.business_outlined,
          label: 'Department',
          value: _userData['department']!,
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1625).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2D1B4E).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: const Color(0xFFB4FF39)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
