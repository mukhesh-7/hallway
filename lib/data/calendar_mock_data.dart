import '../models/hall.dart';
import '../data/mock_data.dart';

class CalendarMockData {
  static List<Booking> getBookingsForDate(DateTime date) {
    final halls = MockData.getAllHalls();

    // Generate mock bookings for demonstration
    final bookings = <Booking>[];

    // Add some sample bookings for different dates
    if (date.day % 3 == 0) {
      bookings.add(
        Booking(
          id: 'BK${date.day}001',
          hall: halls[0],
          timeSlot: TimeSlot(
            id: 'slot1',
            startTime: DateTime(date.year, date.month, date.day, 9, 0),
            endTime: DateTime(date.year, date.month, date.day, 11, 0),
            isAvailable: false,
          ),
          date: date,
          purpose: 'Technical Symposium',
          status: BookingStatus.approved,
          department: 'Computer Science & Engineering',
          eventDetails:
              'Annual tech fest with coding competitions and workshops',
        ),
      );
    }

    if (date.day % 5 == 0) {
      bookings.add(
        Booking(
          id: 'BK${date.day}002',
          hall: halls[3],
          timeSlot: TimeSlot(
            id: 'slot2',
            startTime: DateTime(date.year, date.month, date.day, 14, 0),
            endTime: DateTime(date.year, date.month, date.day, 16, 0),
            isAvailable: false,
          ),
          date: date,
          purpose: 'Guest Lecture',
          status: BookingStatus.approved,
          department: 'Artificial Intelligence and Data Science',
          eventDetails: 'Industry expert talk on Machine Learning trends',
        ),
      );
    }

    if (date.day % 7 == 0) {
      bookings.add(
        Booking(
          id: 'BK${date.day}003',
          hall: halls[6],
          timeSlot: TimeSlot(
            id: 'slot3',
            startTime: DateTime(date.year, date.month, date.day, 10, 0),
            endTime: DateTime(date.year, date.month, date.day, 13, 0),
            isAvailable: false,
          ),
          date: date,
          purpose: 'Workshop',
          status: BookingStatus.approved,
          department: 'Mechanical Engineering',
          eventDetails: 'Hands-on workshop on CAD/CAM software',
        ),
      );
    }

    if (date.day % 2 == 0 && date.day > 15) {
      bookings.add(
        Booking(
          id: 'BK${date.day}004',
          hall: halls[8],
          timeSlot: TimeSlot(
            id: 'slot4',
            startTime: DateTime(date.year, date.month, date.day, 15, 0),
            endTime: DateTime(date.year, date.month, date.day, 17, 0),
            isAvailable: false,
          ),
          date: date,
          purpose: 'Seminar',
          status: BookingStatus.approved,
          department: 'Electronics and Communication Engineering',
          eventDetails: 'Seminar on IoT and embedded systems',
        ),
      );
    }

    return bookings;
  }

  static bool hasBookingsOnDate(DateTime date) {
    return getBookingsForDate(date).isNotEmpty;
  }
}
