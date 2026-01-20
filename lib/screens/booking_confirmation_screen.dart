import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import '../models/hall.dart';
import '../screens/block_selection_screen.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Booking booking;

  const BookingConfirmationScreen({super.key, required this.booking});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _badgeController;
  late AnimationController _checkController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _badgeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _checkController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.easeOutCubic),
    );

    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _checkController.forward();
        if (widget.booking.status == BookingStatus.pending) {
          _shimmerController.repeat();
        }
        _badgeController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _badgeController.dispose();
    _checkController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Color _getStatusColor() {
    switch (widget.booking.status) {
      case BookingStatus.pending:
        return const Color(0xFFFFA500); // Orange
      case BookingStatus.approved:
        return const Color(0xFFB4FF39); // Neon green
      case BookingStatus.rejected:
        return const Color(0xFFFF4444); // Red
    }
  }

  String _getStatusText() {
    switch (widget.booking.status) {
      case BookingStatus.pending:
        return 'Pending Approval';
      case BookingStatus.approved:
        return 'Approved';
      case BookingStatus.rejected:
        return 'Rejected';
    }
  }

  IconData _getStatusIcon() {
    switch (widget.booking.status) {
      case BookingStatus.pending:
        return Icons.schedule;
      case BookingStatus.approved:
        return Icons.check_circle;
      case BookingStatus.rejected:
        return Icons.cancel;
    }
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        _buildSuccessIcon(),
                        const SizedBox(height: 32),
                        _buildTitle(),
                        const SizedBox(height: 32),
                        _buildStatusBadge(),
                        const SizedBox(height: 32),
                        _buildBookingCard(),
                        const SizedBox(height: 24),
                        _buildInfoMessage(),
                      ],
                    ),
                  ),
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedBuilder(
        animation: _checkController,
        builder: (context, child) {
          return Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_getStatusColor(), _getStatusColor().withOpacity(0.7)],
              ),
              boxShadow: [
                BoxShadow(
                  color: _getStatusColor().withOpacity(0.5),
                  blurRadius: 40,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Center(
              child: widget.booking.status == BookingStatus.approved
                  ? CustomPaint(
                      size: const Size(70, 70),
                      painter: _CheckmarkPainter(
                        progress: _checkAnimation.value,
                        color: const Color(0xFF0F0B1B),
                      ),
                    )
                  : Icon(
                      _getStatusIcon(),
                      size: 70,
                      color: widget.booking.status == BookingStatus.pending
                          ? const Color(0xFF0F0B1B)
                          : Colors.white,
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          widget.booking.status == BookingStatus.approved
              ? 'Booking Confirmed!'
              : widget.booking.status == BookingStatus.pending
              ? 'Booking Submitted!'
              : 'Booking Rejected',
          style: GoogleFonts.dmSans(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          widget.booking.status == BookingStatus.approved
              ? 'Your hall has been successfully booked'
              : widget.booking.status == BookingStatus.pending
              ? 'Your booking request is being reviewed'
              : 'Unfortunately, your booking was not approved',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return AnimatedBuilder(
      animation: _badgeController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: _getStatusColor().withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getStatusColor().withOpacity(
                widget.booking.status == BookingStatus.pending
                    ? 0.4 + (_badgeController.value * 0.3)
                    : 0.6,
              ),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _getStatusColor().withOpacity(
                  widget.booking.status == BookingStatus.pending
                      ? 0.2 + (_badgeController.value * 0.2)
                      : 0.3,
                ),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.booking.status == BookingStatus.pending)
                AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: [
                            _getStatusColor().withOpacity(0.5),
                            _getStatusColor(),
                            _getStatusColor().withOpacity(0.5),
                          ],
                          stops: [
                            _shimmerController.value - 0.3,
                            _shimmerController.value,
                            _shimmerController.value + 0.3,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds);
                      },
                      child: Icon(
                        _getStatusIcon(),
                        color: Colors.white,
                        size: 24,
                      ),
                    );
                  },
                )
              else
                Icon(_getStatusIcon(), color: _getStatusColor(), size: 24),
              const SizedBox(width: 12),
              Text(
                _getStatusText(),
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1625).withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFB4FF39),
                          const Color(0xFF8FE526),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.confirmation_number,
                      color: Color(0xFF0F0B1B),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking ID',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.booking.id,
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.white.withOpacity(0.1)),
              const SizedBox(height: 20),
              _BookingDetailRow(
                icon: Icons.meeting_room_rounded,
                label: 'Hall',
                value: widget.booking.hall.name,
              ),
              const SizedBox(height: 16),
              _BookingDetailRow(
                icon: Icons.location_on_outlined,
                label: 'Block',
                value: widget.booking.hall.block,
              ),
              const SizedBox(height: 16),
              _BookingDetailRow(
                icon: Icons.calendar_today,
                label: 'Date',
                value: DateFormat(
                  'EEEE, MMMM d, y',
                ).format(widget.booking.date),
              ),
              const SizedBox(height: 16),
              _BookingDetailRow(
                icon: Icons.access_time,
                label: 'Time',
                value: widget.booking.timeSlot.timeRange,
              ),
              const SizedBox(height: 16),
              _BookingDetailRow(
                icon: Icons.description_outlined,
                label: 'Purpose',
                value: widget.booking.purpose,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoMessage() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1B4E).withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: const Color(0xFFB4FF39), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.booking.status == BookingStatus.pending
                  ? 'You will receive a notification once your booking is approved by the administrator.'
                  : widget.booking.status == BookingStatus.approved
                  ? 'Please arrive 15 minutes before your scheduled time.'
                  : 'Please contact the administrator for more information.',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1625).withOpacity(0.95),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionButton(
            label: 'Back to Home',
            icon: Icons.home_outlined,
            isPrimary: true,
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const BlockSelectionScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 12),
          _ActionButton(
            label: 'View My Bookings',
            icon: Icons.list_alt,
            isPrimary: false,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Bookings list feature coming soon!',
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: const Color(0xFFB4FF39),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BookingDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _BookingDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.white.withOpacity(0.6)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
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
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: widget.isPrimary
                ? const LinearGradient(
                    colors: [Color(0xFFB4FF39), Color(0xFF8FE526)],
                  )
                : null,
            color: widget.isPrimary
                ? null
                : const Color(0xFF2D1B4E).withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isPrimary
                  ? const Color(0xFFB4FF39)
                  : Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: widget.isPrimary
                ? [
                    BoxShadow(
                      color: const Color(0xFFB4FF39).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: widget.isPrimary
                    ? const Color(0xFF0F0B1B)
                    : Colors.white.withOpacity(0.8),
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.isPrimary
                      ? const Color(0xFF0F0B1B)
                      : Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CheckmarkPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Define checkmark path
    final p1 = Offset(size.width * 0.2, size.height * 0.5);
    final p2 = Offset(size.width * 0.4, size.height * 0.7);
    final p3 = Offset(size.width * 0.8, size.height * 0.3);

    if (progress < 0.5) {
      // Draw first part of checkmark
      final t = progress * 2;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p1.dx + (p2.dx - p1.dx) * t, p1.dy + (p2.dy - p1.dy) * t);
    } else {
      // Draw complete first part and second part
      final t = (progress - 0.5) * 2;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      path.lineTo(p2.dx + (p3.dx - p2.dx) * t, p2.dy + (p3.dy - p2.dy) * t);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
