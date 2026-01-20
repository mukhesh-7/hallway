import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/hall.dart';
import 'booking_confirmation_screen.dart';

class BookingFlowScreen extends StatefulWidget {
  final Hall hall;
  final TimeSlot timeSlot;
  final DateTime selectedDate;

  const BookingFlowScreen({
    super.key,
    required this.hall,
    required this.timeSlot,
    required this.selectedDate,
  });

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen>
    with TickerProviderStateMixin {
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _attendeesController = TextEditingController();
  late AnimationController _sheetController;
  late AnimationController _inputController;
  late AnimationController _buttonController;
  late Animation<double> _sheetAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _sheetController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _inputController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _sheetAnimation = CurvedAnimation(
      parent: _sheetController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(_sheetAnimation);

    _sheetController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _inputController.forward();
    });
  }

  @override
  void dispose() {
    _purposeController.dispose();
    _attendeesController.dispose();
    _sheetController.dispose();
    _inputController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Color _getBlockColor() {
    switch (widget.hall.block) {
      case 'A Block':
        return const Color(0xFF6366F1);
      case 'B Block':
        return const Color(0xFFEC4899);
      case 'C Block':
        return const Color(0xFF10B981);
      case 'D Block':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6366F1);
    }
  }

  Future<void> _handleBooking() async {
    if (_purposeController.text.isEmpty || _attendeesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all fields',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final booking = Booking(
        id: 'BK${DateTime.now().millisecondsSinceEpoch}',
        hall: widget.hall,
        timeSlot: widget.timeSlot,
        date: widget.selectedDate,
        purpose: _purposeController.text,
        status: BookingStatus.pending,
      );

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              BookingConfirmationScreen(booking: booking),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {}, // Prevent dismissal when tapping the sheet
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHandle(),
                      Flexible(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeader(),
                              const SizedBox(height: 24),
                              _buildBookingSummary(),
                              const SizedBox(height: 24),
                              _buildInputFields(),
                              const SizedBox(height: 24),
                              _buildConfirmButton(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Booking',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Fill in the details to complete your booking',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getBlockColor().withOpacity(0.1),
            _getBlockColor().withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getBlockColor().withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _SummaryRow(
            icon: Icons.meeting_room,
            label: 'Hall',
            value: widget.hall.name,
            color: _getBlockColor(),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            icon: Icons.calendar_today,
            label: 'Date',
            value: DateFormat('MMM d, y').format(widget.selectedDate),
            color: _getBlockColor(),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            icon: Icons.access_time,
            label: 'Time',
            value: widget.timeSlot.timeRange,
            color: _getBlockColor(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFields() {
    return AnimatedBuilder(
      animation: _inputController,
      builder: (context, child) {
        return Column(
          children: [
            Transform.translate(
              offset: Offset(0, 20 * (1 - _inputController.value)),
              child: Opacity(
                opacity: _inputController.value,
                child: _buildTextField(
                  controller: _purposeController,
                  label: 'Purpose',
                  hint: 'e.g., Team Meeting, Workshop',
                  icon: Icons.description_outlined,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Transform.translate(
              offset: Offset(0, 20 * (1 - _inputController.value)),
              child: Opacity(
                opacity: _inputController.value,
                child: _buildTextField(
                  controller: _attendeesController,
                  label: 'Expected Attendees',
                  hint: 'Number of people',
                  icon: Icons.people_outline,
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: const Color(0xFF0F172A),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
              prefixIcon: Icon(icon, color: _getBlockColor(), size: 22),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return GestureDetector(
      onTapDown: (_) => _buttonController.forward(),
      onTapUp: (_) {
        _buttonController.reverse();
        _handleBooking();
      },
      onTapCancel: () => _buttonController.reverse(),
      child: AnimatedBuilder(
        animation: _buttonController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_buttonController.value * 0.05),
            child: child,
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_getBlockColor(), _getBlockColor().withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _getBlockColor().withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: _isLoading
              ? const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Confirm Booking',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
