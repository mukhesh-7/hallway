# 🏛️ HallWay - Campus Hall Booking System

A premium, dark-themed Flutter mobile application for booking campus halls at Dr. N.G.P. Institute of Technology.

![Flutter](https://img.shields.io/badge/Flutter-3.10.7-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📱 Overview

HallWay is a modern, production-ready mobile application designed to streamline the process of booking campus halls. Built with Flutter, it features a premium dark theme with neon green accents, smooth animations, and an intuitive user interface inspired by contemporary ticket booking apps.

### ✨ Key Features

- 🎨 **Premium Dark Theme** - Deep purple-to-black gradient with neon green accents
- 🏢 **Multi-Block Support** - Manage halls across A, B, C, and D blocks
- 📊 **Real-time Availability** - Color-coded status indicators (Available/Limited/Booked)
- 🎭 **Smooth Animations** - Production-grade animations and transitions
- 📅 **Time Slot Management** - Easy booking with visual time slot selection
- 🔍 **Smart Filtering** - Filter halls by block or view all at once
- 📱 **Mobile-First Design** - Optimized for Android and iOS

---

## 🎯 Features

### Hall Management
- Browse all available halls across campus
- Filter by building blocks (A, B, C, D)
- View detailed hall information including:
  - Capacity
  - Amenities
  - Availability status
  - Descriptions

### Booking System
- Select date and time slots
- Real-time availability checking
- Booking confirmation with status tracking
- Animated status badges (Pending/Approved/Rejected)

### User Interface
- Glassmorphic cards with backdrop blur
- Floating bottom navigation
- Pulsing status indicators
- Staggered entrance animations
- Smooth page transitions

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.10.7 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code
- Android device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/hallway.git
   cd hallway
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## 📂 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   └── hall.dart            # Hall, TimeSlot, Booking models
├── data/                     # Mock data
│   └── mock_data.dart       # Sample hall data
└── screens/                  # UI screens
    ├── block_selection_screen.dart      # Home screen
    ├── hall_availability_screen.dart    # Hall listing
    ├── hall_detail_screen.dart          # Hall details
    ├── booking_flow_screen.dart         # Booking form
    └── booking_confirmation_screen.dart # Confirmation
```

---

## 🎨 Design System

### Color Palette

```dart
// Background
Deep Purple:    #1A0F2E
Deep Dark:      #0F0B1B
Dark Purple:    #1A1230

// Primary
Neon Green:     #B4FF39
Green Dark:     #8FE526

// Status
Available:      #B4FF39 (Green)
Limited:        #FFA500 (Orange)
Booked:         #FF4444 (Red)
```

### Typography

- **Font Family**: DM Sans (Google Fonts)
- **Headings**: 24-32px, Bold, -0.5 letter spacing
- **Body**: 14-16px, Medium/Regular
- **Captions**: 12-14px, Medium

### Animation Timings

- **Micro-interactions**: 150-300ms
- **Page transitions**: 400-600ms
- **Content reveals**: 800-1200ms
- **Looping effects**: 1500-2000ms

---

## 🏗️ Architecture

### Design Patterns
- **State Management**: StatefulWidget with AnimationControllers
- **Navigation**: PageRouteBuilder with custom transitions
- **Data Layer**: Mock data (ready for backend integration)

### Key Components
- Glassmorphic cards with `BackdropFilter`
- Custom painters for animations
- Reusable widget components
- Responsive layouts

---

## 📱 Screens

### 1. Home Screen (Block Selection)
- College logo with institution name
- Search bar with filter button
- Category chips for block filtering
- Available halls list with descriptions
- Floating bottom navigation

### 2. Hall Availability Screen
- Date selector with horizontal scroll
- Hall cards with status badges
- Pulsing availability indicators
- Staggered entrance animations

### 3. Hall Detail Screen
- Hero section with gradient overlay
- Hall information cards
- Time slot selection with pills
- Animated booking button

### 4. Booking Confirmation Screen
- Animated success icon
- Status badge with shimmer/checkmark
- Booking details card
- Action buttons

---

## 🔧 Configuration

### Assets

The app uses the college logo from the assets folder:
```yaml
flutter:
  assets:
    - assets/
```

Place your logo at: `assets/clg_logo.png`

### Customization

**Change Institution Name:**
Edit `lib/screens/block_selection_screen.dart`:
```dart
Text('Dr. N.G.P. Institute of Technology'),
```

**Modify Halls:**
Edit `lib/data/mock_data.dart` to add/remove halls

**Adjust Colors:**
Update color constants in individual screen files

---

## 🎯 Roadmap

- [ ] Backend integration (Firebase/REST API)
- [ ] User authentication
- [ ] Push notifications
- [ ] Booking history
- [ ] Admin panel
- [ ] Calendar integration
- [ ] Payment gateway
- [ ] QR code generation

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👥 Authors

- **Your Name** - Initial work

---

## 🙏 Acknowledgments

- Design inspiration from Dribbble's Ticket Booking App
- Flutter team for the amazing framework
- Google Fonts for DM Sans typography
- Dr. N.G.P. Institute of Technology

---

## 🔗 Links

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Google Fonts](https://fonts.google.com/)

---

**Made with ❤️ using Flutter**
