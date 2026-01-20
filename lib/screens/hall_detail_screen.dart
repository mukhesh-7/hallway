import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../models/hall.dart';
import '../data/mock_data.dart';
import 'booking_flow_screen.dart';

class HallDetailScreen extends StatefulWidget {
  final Hall hall;
  final DateTime selectedDate;

  const HallDetailScreen({
    super.key,
    required this.hall,
    required this.selectedDate,
  });

  @override
  State<HallDetailScreen> createState() => _HallDetailScreenState();
}

class _HallDetailScreenState extends State<HallDetailScreen>
    with TickerProviderStateMixin {
  late List<TimeSlot> _timeSlots;
  TimeSlot? _selectedSlot;
  late AnimationController _fadeController;
  late AnimationController _contentController;
  late AnimationController _buttonController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _timeSlots = MockData.getTimeSlotsForDate(widget.selectedDate);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: Curves.easeOutCubic,
          ),
        );

    _buttonScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _contentController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _contentController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _onSlotSelected(TimeSlot slot) {
    if (!slot.isAvailable) return;

    setState(() {
      _selectedSlot = slot;
    });

    if (!_buttonController.isCompleted) {
      _buttonController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A0F2E), Color(0xFF0F0B1B), Color(0xFF1A1230)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeroSection(),
                _buildDetailsSection(),
                _buildTimeSlotsSection(),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
            _buildBackButton(),
            if (_selectedSlot != null) _buildBookButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SizedBox(
          height: 400,
          child: Stack(
            children: [
              // Background Image/Gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFF2D1B4E), const Color(0xFF1A1230)],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.meeting_room_rounded,
                    size: 120,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF0F0B1B).withOpacity(0.8),
                      const Color(0xFF0F0B1B),
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
              ),
              // Content
              Positioned(
                left: 24,
                right: 24,
                bottom: 32,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFB4FF39), Color(0xFF8FE526)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.hall.block,
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F0B1B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.hall.name,
                          style: GoogleFonts.dmSans(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '4517 Washington Ave. Campus',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Favorite Button
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return SliverToBoxAdapter(
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Cards Row
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.access_time,
                        label: 'Time',
                        value:
                            'Jun 24, 2024 at 3:00 PM - Jun 30, 2024 at 10:00 PM',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.door_front_door_outlined,
                        label: 'Doors Open',
                        value: '2:30 PM',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.door_back_door_outlined,
                        label: 'Doors Close',
                        value: '10:00 PM',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Description
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1625).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${widget.hall.name} is a comprehensive hall providing a platform for the needs of every facet of the campus community. From formulation application technology finishing quality assurance recycling and disposal. Coatings Dhaka will offer an opportunity to learn about...',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              'Show More',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                color: const Color(0xFFB4FF39),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: const Color(0xFFB4FF39),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlotsSection() {
    return SliverToBoxAdapter(
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Time Slots',
                  style: GoogleFonts.dmSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ...(_timeSlots.asMap().entries.map((entry) {
                  final index = entry.key;
                  final slot = entry.value;
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(30 * (1 - value), 0),
                        child: Opacity(opacity: value, child: child),
                      );
                    },
                    child: _TimeSlotPill(
                      slot: slot,
                      isSelected: _selectedSlot?.id == slot.id,
                      onTap: () => _onSlotSelected(slot),
                    ),
                  );
                })),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookButton() {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 24,
      child: ScaleTransition(
        scale: _buttonScaleAnimation,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    BookingFlowScreen(
                      hall: widget.hall,
                      timeSlot: _selectedSlot!,
                      selectedDate: widget.selectedDate,
                    ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(0, 0.1),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                          child: child,
                        ),
                      );
                    },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFB4FF39), Color(0xFF8FE526)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB4FF39).withOpacity(0.5),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Starting from',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: const Color(0xFF0F0B1B).withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '\$300.00',
                  style: GoogleFonts.dmSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F0B1B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Info Card Widget
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1625).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF2D1B4E).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: Colors.white.withOpacity(0.8)),
          ),
          const SizedBox(width: 12),
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
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Time Slot Pill Widget
class _TimeSlotPill extends StatefulWidget {
  final TimeSlot slot;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeSlotPill({
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_TimeSlotPill> createState() => _TimeSlotPillState();
}

class _TimeSlotPillState extends State<_TimeSlotPill>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_TimeSlotPill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.slot.isAvailable ? widget.onTap : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: widget.isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFFB4FF39), Color(0xFF8FE526)],
                      )
                    : null,
                color: widget.isSelected
                    ? null
                    : widget.slot.isAvailable
                    ? const Color(0xFF1A1625).withOpacity(0.6)
                    : const Color(0xFF1A1625).withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isSelected
                      ? const Color(0xFFB4FF39)
                      : widget.slot.isAvailable
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white.withOpacity(0.05),
                  width: 1,
                ),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: const Color(
                            0xFFB4FF39,
                          ).withOpacity(_glowAnimation.value),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: widget.isSelected
                        ? const Color(0xFF0F0B1B)
                        : widget.slot.isAvailable
                        ? Colors.white.withOpacity(0.8)
                        : Colors.white.withOpacity(0.3),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.slot.timeRange,
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: widget.isSelected
                            ? const Color(0xFF0F0B1B)
                            : widget.slot.isAvailable
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ),
                  if (widget.isSelected)
                    Icon(
                      Icons.check_circle,
                      color: const Color(0xFF0F0B1B),
                      size: 24,
                    )
                  else if (!widget.slot.isAvailable)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Booked',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
