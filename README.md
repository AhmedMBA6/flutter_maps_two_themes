# Smart Map Guide 🚀

A modern Flutter application combining Firebase Authentication, Google Maps integration, and real-time route visualization.
Users can log in securely, search for destinations, and get turn-by-turn route details such as distance and duration — all wrapped in beautiful light/dark themes.

## ✨ Features

### 🧭 Maps & Directions
- **Google Maps Integration** – Interactive map with smooth camera movement
- **Search with Autocomplete** - Find places instantly using Google Places API
- **Live Route Drawing** - Displays route between your location and the selected place
- **Distance & Duration Display** - Real-time info card showing travel details
- **Dynamic Travel Modes (coming soon)** - Driving, walking, biking, and public transport

### 🔐 Authentication System
- **Email/Password Authentication** - Secure sign-up and sign-in
- **Phone OTP Authentication** - SMS-based verification for both sign-up and sign-in
- **Distance & Duration Display** - Real-time info card showing travel details
- **User Data Management** - Complete user profile creation and management
- **Session Management** - Persistent authentication state

### 🎨 Theming & UI
- **Dual Theme Support** - Beautiful light and dark themes
- **Dynamic Theme Switching** - Real-time theme changes
- **Consistent Design System** - Unified colors, typography, and components
- **Responsive Design** - Optimized for all screen sizes
- **Modern UI Components** - Custom form fields, buttons, and containers
- Floating Search Bar UI
- Animated Info Cards for Route Details

### 🏗️ Architecture & Code Quality
- **Clean Architecture** - Well-structured layers (Presentation, Logic, Data)
- **State Management** - BLoC/Cubit pattern for robust state handling
- **Repository Pattern** - Clean data access abstraction
- **Professional Logging** - Structured logging system with different levels
- **Error Handling** - Comprehensive error handling and user feedback
- **Code Quality** - Lint-free, production-ready code

### 📱 User Experience
- **Form Validation** - Real-time input validation with helpful error messages
- **Loading States** - Smooth loading indicators and state management
- **Error Recovery** - Graceful error handling and recovery mechanisms
- **Accessibility** - Screen reader support and keyboard navigation
- **Internationalization Ready** - Structured for multi-language support

## 🛠️ Technical Stack

- **Framework**: Flutter 3.x
- **State Management**: BLoC / Cubit
- **Backend**: Firebase (Auth, Firestore)
- **Mapping & Routing**: Google Maps, Places, and Routes APIs
- **Polyline Decoding**: google_polyline_algorithm
- **HTTP Client**: Dio with PrettyDioLogger
- **Architecture**: Clean Architecture with Repository Pattern
- **Theming**: Custom theme system with Material Design 3

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x or higher
- Dart SDK 3.x or higher
- Firebase project with Auth and Firestore enabled
- Google Cloud project with Maps, Places & Routes APIs enabled
- API key with proper restrictions
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter_maps_two_themes
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **API & Firebase Setup**
   - Create a Firebase project
   - Enable Authentication (Email/Password, Phone)
   - Enable Firestore Database
   - flutterfire configure
   - Google Maps API
   - Places API
   - Routes API (Directions API v2)

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── constants/         # Colors, text styles, themes
├── data_layer/        # Models, repositories, web services
├── logic_layer/       # Cubits, states, business logic
├── presentation/
│   ├── screens/       # Auth & map screens
│   └── widgets/       # Floating search bar, map widgets, info cards
├── utils/             # Helpers, logger
└── main.dart          # Entry point

```

### Theme Configuration
Themes are defined in `lib/constants/themes/` and can be customized by modifying:
- `app_colors.dart` - Color palette definitions
- `app_text_styles.dart` - Typography styles
- `app_theme.dart` - Theme configuration

## 📱 Screenshots

<div align="center">
  <img src="https://github.com/user-attachments/assets/4f88fab4-f3bf-4953-ab09-a4015a6d3590" width="200"/>
  <img src="https://github.com/user-attachments/assets/d66e72a9-51a1-4866-8916-e4329819898c" width="200"/>
  <img src="https://github.com/user-attachments/assets/6928eb1a-ff07-4d90-bc24-cbcac356ce3a" width="200"/>
  <img src="https://github.com/user-attachments/assets/bf307dcc-765a-4c30-9c07-e87d8a5b3916" width="200"/>
  <img src="https://github.com/user-attachments/assets/08efa4a7-3319-4a10-805e-cf617673b979" width="200"/>
  <img src="https://github.com/user-attachments/assets/f82d981c-cef7-46ce-8dc5-4328e904823a" width="200"/>
>

## 🧪 Testing

The app includes comprehensive testing setup:
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for complete flows

Run tests with:
```bash
flutter test
```

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request


## 📞 Support

If you have any questions or need help, please:
- Open an issue in the repository
- Check the documentation
- Review the code examples

---

**Built with ❤️ using Flutter, Firebase & Google Maps APIs**
