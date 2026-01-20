class Hall {
  final String id;
  final String name;
  final String block;
  final int capacity;
  final HallStatus status;
  final String imageUrl;
  final List<String> amenities;
  final String description;

  const Hall({
    required this.id,
    required this.name,
    required this.block,
    required this.capacity,
    required this.status,
    required this.imageUrl,
    required this.amenities,
    required this.description,
  });
}

enum HallStatus { available, partiallyBooked, fullyBooked }

class TimeSlot {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;

  const TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  String get timeRange {
    final start =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final end =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }
}

class Booking {
  final String id;
  final Hall hall;
  final TimeSlot timeSlot;
  final DateTime date;
  final String purpose;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.hall,
    required this.timeSlot,
    required this.date,
    required this.purpose,
    required this.status,
  });
}

enum BookingStatus { pending, approved, rejected }
