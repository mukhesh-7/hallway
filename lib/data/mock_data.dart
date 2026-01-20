import '../models/hall.dart';

class MockData {
  static List<Hall> getAllHalls() {
    return [
      // A Block Halls
      Hall(
        id: 'a1',
        name: 'Auditorium A1',
        block: 'A Block',
        capacity: 500,
        status: HallStatus.available,
        imageUrl: 'assets/halls/auditorium.jpg',
        amenities: ['Projector', 'Sound System', 'AC', 'Stage'],
        description:
            'Large auditorium perfect for conferences and cultural events',
      ),
      Hall(
        id: 'a2',
        name: 'Seminar Hall A2',
        block: 'A Block',
        capacity: 150,
        status: HallStatus.partiallyBooked,
        imageUrl: 'assets/halls/seminar.jpg',
        amenities: ['Projector', 'Whiteboard', 'AC'],
        description:
            'Ideal for seminars, workshops, and academic presentations',
      ),
      Hall(
        id: 'a3',
        name: 'Conference Room A3',
        block: 'A Block',
        capacity: 50,
        status: HallStatus.available,
        imageUrl: 'assets/halls/conference.jpg',
        amenities: ['Smart Board', 'Video Conferencing', 'AC'],
        description:
            'Modern conference room with video conferencing facilities',
      ),

      // B Block Halls
      Hall(
        id: 'b1',
        name: 'Lecture Hall B1',
        block: 'B Block',
        capacity: 200,
        status: HallStatus.available,
        imageUrl: 'assets/halls/lecture.jpg',
        amenities: ['Projector', 'Microphone', 'AC'],
        description: 'Spacious lecture hall for large classroom sessions',
      ),
      Hall(
        id: 'b2',
        name: 'Workshop Hall B2',
        block: 'B Block',
        capacity: 100,
        status: HallStatus.fullyBooked,
        imageUrl: 'assets/halls/workshop.jpg',
        amenities: ['Workbenches', 'Tools', 'Ventilation'],
        description: 'Hands-on workshop space with technical equipment',
      ),
      Hall(
        id: 'b3',
        name: 'Meeting Room B3',
        block: 'B Block',
        capacity: 30,
        status: HallStatus.available,
        imageUrl: 'assets/halls/meeting.jpg',
        amenities: ['Whiteboard', 'AC', 'Coffee Machine'],
        description: 'Cozy meeting room for small group discussions',
      ),

      // C Block Halls
      Hall(
        id: 'c1',
        name: 'Multi-Purpose Hall C1',
        block: 'C Block',
        capacity: 300,
        status: HallStatus.partiallyBooked,
        imageUrl: 'assets/halls/multipurpose.jpg',
        amenities: ['Stage', 'Sound System', 'Lighting', 'AC'],
        description: 'Versatile hall for events, performances, and gatherings',
      ),
      Hall(
        id: 'c2',
        name: 'Study Hall C2',
        block: 'C Block',
        capacity: 80,
        status: HallStatus.available,
        imageUrl: 'assets/halls/study.jpg',
        amenities: ['Silent Zone', 'AC', 'WiFi'],
        description: 'Quiet study space for focused learning sessions',
      ),
      Hall(
        id: 'c3',
        name: 'Exhibition Hall C3',
        block: 'C Block',
        capacity: 250,
        status: HallStatus.available,
        imageUrl: 'assets/halls/exhibition.jpg',
        amenities: ['Display Boards', 'Lighting', 'AC'],
        description:
            'Open exhibition space for showcasing projects and displays',
      ),

      // D Block Halls
      Hall(
        id: 'd1',
        name: 'Innovation Lab D1',
        block: 'D Block',
        capacity: 60,
        status: HallStatus.available,
        imageUrl: 'assets/halls/lab.jpg',
        amenities: ['Computers', 'Projector', 'AC', 'WiFi'],
        description:
            'Tech-enabled lab for innovation and development activities',
      ),
      Hall(
        id: 'd2',
        name: 'Presentation Hall D2',
        block: 'D Block',
        capacity: 120,
        status: HallStatus.partiallyBooked,
        imageUrl: 'assets/halls/presentation.jpg',
        amenities: ['Projector', 'Sound System', 'AC'],
        description: 'Professional presentation hall with AV equipment',
      ),
      Hall(
        id: 'd3',
        name: 'Collaboration Space D3',
        block: 'D Block',
        capacity: 40,
        status: HallStatus.available,
        imageUrl: 'assets/halls/collaboration.jpg',
        amenities: ['Whiteboard', 'Flexible Seating', 'AC'],
        description: 'Flexible collaboration space for team projects',
      ),
    ];
  }

  static List<Hall> getHallsForBlock(String block) {
    return getAllHalls().where((hall) => hall.block == block).toList();
  }

  static List<TimeSlot> getTimeSlotsForDate(DateTime date) {
    final now = DateTime.now();
    return [
      TimeSlot(
        id: 'slot1',
        startTime: DateTime(date.year, date.month, date.day, 8, 0),
        endTime: DateTime(date.year, date.month, date.day, 10, 0),
        isAvailable: true,
      ),
      TimeSlot(
        id: 'slot2',
        startTime: DateTime(date.year, date.month, date.day, 10, 0),
        endTime: DateTime(date.year, date.month, date.day, 12, 0),
        isAvailable: date.isAfter(now) || date.day != now.day,
      ),
      TimeSlot(
        id: 'slot3',
        startTime: DateTime(date.year, date.month, date.day, 12, 0),
        endTime: DateTime(date.year, date.month, date.day, 14, 0),
        isAvailable: false,
      ),
      TimeSlot(
        id: 'slot4',
        startTime: DateTime(date.year, date.month, date.day, 14, 0),
        endTime: DateTime(date.year, date.month, date.day, 16, 0),
        isAvailable: true,
      ),
      TimeSlot(
        id: 'slot5',
        startTime: DateTime(date.year, date.month, date.day, 16, 0),
        endTime: DateTime(date.year, date.month, date.day, 18, 0),
        isAvailable: true,
      ),
      TimeSlot(
        id: 'slot6',
        startTime: DateTime(date.year, date.month, date.day, 18, 0),
        endTime: DateTime(date.year, date.month, date.day, 20, 0),
        isAvailable: date.isAfter(now),
      ),
    ];
  }
}
