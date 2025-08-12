# Flutter Login App with Two Themes 🚀

A modern, production-ready Flutter application featuring a robust authentication system with beautiful dual-theme support (Light & Dark modes).

## ✨ Features

### 🔐 Authentication System
- **Email/Password Authentication** - Secure sign-up and sign-in
- **Phone OTP Authentication** - SMS-based verification for both sign-up and sign-in
- **Firebase Integration** - Powered by Firebase Auth and Firestore
- **User Data Management** - Complete user profile creation and management
- **Session Management** - Persistent authentication state

### 🎨 Theming & UI
- **Dual Theme Support** - Beautiful light and dark themes
- **Dynamic Theme Switching** - Real-time theme changes
- **Consistent Design System** - Unified colors, typography, and components
- **Responsive Design** - Optimized for all screen sizes
- **Modern UI Components** - Custom form fields, buttons, and containers

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
- **State Management**: flutter_bloc
- **Backend**: Firebase (Auth, Firestore)
- **Architecture**: Clean Architecture with Repository Pattern
- **Theming**: Custom theme system with Material Design 3
- **Logging**: Professional logging utility with debug/production modes

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x or higher
- Dart SDK 3.x or higher
- Firebase project with Auth and Firestore enabled
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter_login_two_themes
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project
   - Enable Authentication (Email/Password, Phone)
   - Enable Firestore Database
   - Download and add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Update Firebase configuration in `lib/firebase_options.dart`

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── constants/
│   ├── themes/          # Theme definitions and colors
│   ├── widgets/         # Reusable UI components
│   └── app_strings.dart # App-wide string constants
├── data_layer/
│   ├── models/          # Data models
│   ├── repos/           # Repository implementations
│   └── interfaces/      # Repository contracts
├── logic_layer/
│   └── auth/            # Authentication business logic
├── presentation/
│   ├── screens/         # App screens
│   └── widgets/         # Screen-specific widgets
├── utils/
│   └── logger.dart      # Professional logging utility
└── main.dart            # App entry point
```

## 🔧 Configuration

### Firebase Configuration
The app requires Firebase configuration for authentication and database functionality. Ensure you have:
- Firebase project created
- Authentication methods enabled
- Firestore database created
- Proper security rules configured

### Theme Configuration
Themes are defined in `lib/constants/themes/` and can be customized by modifying:
- `app_colors.dart` - Color palette definitions
- `app_text_styles.dart` - Typography styles
- `app_theme.dart` - Theme configuration

## 📱 Screenshots

*[Add screenshots of your app here]*

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

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the robust backend services
- BLoC team for the excellent state management solution

## 📞 Support

If you have any questions or need help, please:
- Open an issue in the repository
- Check the documentation
- Review the code examples

---

**Built with ❤️ using Flutter**
