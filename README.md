# 🍽️ UniBite — University Student Café Management App

> **Last Updated:** April 30, 2026

A Flutter mobile application for managing university student café meal contracts. Students can register, login, view their balance, order meals, deposit funds, and track their full transaction history — all stored locally on the device.

---

## 🎥 Demo Video

> 📹 **Loom Presentation Video:** [Watch Presentation](https://www.loom.com/share/b1d42cc98bb84e40b6a983fd776444fc)
>
> - Duration: 25–30 minutes
> - Each member states their name and Student ID before presenting
> - Includes live demo, code walkthrough, and use case trace explanation

---

## 📦 APK Download

> ✅ **[Download unibite.apk](https://github.com/33-44-53/unibite/raw/main/build/app/outputs/flutter-apk/unibite.apk)**
>
> - Built with: `flutter build apk --release --target-platform android-arm64`
> - Min Android version: Android 5.0 (API 21)
> - Size: ~17.3 MB
>
> **Install Instructions:**
> 1. Download the APK on your Android device
> 2. Go to Settings → Security → Enable **Install Unknown Apps**
> 3. Tap the downloaded APK to install

---

## 📱 App Flow

```
Splash Screen
    ↓
Landing Screen  (animated feature showcase)
    ↓
Login / Register
    ↓
Home Screen  (balance card + order meals)
    ├── Order Breakfast / Lunch / Dinner
    ├── Deposit Funds
    ├── Café Menu  (fetched from TheMealDB API)
    ├── Transaction History
    └── Profile  (photo, stats, online meals)
```

---

## ✨ Features

| Feature | Description |
|---|---|
| 🔐 Register & Login | Student account system with password, saved locally per Student ID |
| 💰 Meal Balance | Starts at 0 ETB, deposit funds and track spending in real time |
| 🍳 Order Meals | Breakfast, Lunch & Dinner with food selection and quantity control (e.g. 3× Tibs) |
| 📋 Transaction History | Full history of purchases and deposits with totals summary banner |
| 🏦 Deposit Funds | Simulated deposits via CBE Birr, TeleBirr, M-Pesa, eBirr with real logos |
| 📖 Café Menu | Browse meals fetched live from TheMealDB API with category filter and search |
| 🌐 Online Meals | Live meal data fetched from `themealdb.com` with loading indicator and error handling |
| 📷 Profile Photo | Take or pick a photo using device camera or gallery with full permission flow |
| 🇪🇹 Bilingual | Full English and Amharic language support with one-tap toggle |
| 💾 Local Storage | All data persisted using SharedPreferences per account (multi-account support) |

---

## 🛠️ Tech Stack

| Technology | Version | Usage |
|---|---|---|
| Flutter | 3.x | UI Framework |
| Dart | 3.x | Programming Language |
| shared_preferences | ^2.2.2 | Local data persistence |
| http | ^1.2.0 | API networking |
| image_picker | ^1.0.7 | Camera & gallery access |
| permission_handler | ^11.3.1 | Device permission handling |
| intl | ^0.19.0 | Date formatting |

**API Used:** [TheMealDB](https://www.themealdb.com/api/json/v1/1/search.php) — free public food/meal API

---

## 📋 Project Requirements Coverage

| Topic | Requirement | Implementation | Status |
|---|---|---|---|
| Topic 2 | Stateless & Stateful widgets | `_MenuCard` (Stateless), `_HomeScreenState` (Stateful) | ✅ |
| Topic 2 | Row / Column / Stack layouts | Used throughout all screens | ✅ |
| Topic 2 | Forms & input fields | Register, Login, Deposit forms with validation | ✅ |
| Topic 2 | Snackbar & Dialog | Order confirmation, insufficient balance dialog, deposit success | ✅ |
| Topic 3 | Navigator push/pop | All screen transitions with data passing | ✅ |
| Topic 3 | Data passing between screens | Deposit returns new balance to HomeScreen | ✅ |
| Topic 3 | setState() | Used in all stateful screens | ✅ |
| Topic 4 | SharedPreferences | Accounts, balance, transactions, photo path — all persisted | ✅ |
| Topic 5 | Fetch from public API | TheMealDB — `https://www.themealdb.com/api/json/v1/1/search.php` | ✅ |
| Topic 5 | JSON parsing | `ApiProduct.fromMealJson()` in `api_service.dart` | ✅ |
| Topic 5 | Loading indicator | `CircularProgressIndicator` while fetching | ✅ |
| Topic 5 | Error handling | WiFi-off icon + retry button on failure | ✅ |
| Topic 6 | image_picker plugin | Camera and gallery photo selection | ✅ |
| Topic 6 | permission_handler plugin | Camera and photos permission request and response | ✅ |
| Topic 6 | Full permission flow | Granted → pick photo, Denied → snackbar, Permanently denied → open settings | ✅ |

---

## 📂 Project Structure

```
unibite/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   └── menu_item.dart           # MenuItem model + hardcoded Ethiopian menu
│   ├── screens/
│   │   ├── splash_screen.dart       # Animated splash with auto-navigation
│   │   ├── landing_screen.dart      # Animated landing with feature showcase
│   │   ├── login_screen.dart        # Login + Register tabs with validation
│   │   ├── home_screen.dart         # Balance card + meal ordering (main screen)
│   │   ├── menu_screen.dart         # Café menu fetched from TheMealDB API
│   │   ├── history_screen.dart      # Transaction history with summary banner
│   │   ├── profile_screen.dart      # Profile photo, stats, camera/gallery (Topic 6)
│   │   ├── deposit_screen.dart      # Deposit funds via payment methods
│   │   └── api_menu_screen.dart     # Online meals from TheMealDB (Topic 5)
│   ├── services/
│   │   ├── api_service.dart         # HTTP fetch + JSON parsing from TheMealDB
│   │   ├── storage_service.dart     # All SharedPreferences operations
│   │   └── language_service.dart    # English/Amharic language toggle
│   └── widgets/
│       ├── balance_card.dart        # Reusable balance display card
│       └── custom_button.dart       # Reusable button widget
├── android/                         # Android build configuration
├── assets/
│   ├── cbe.jpg                      # CBE Birr payment logo
│   ├── telebirr.webp                # TeleBirr payment logo
│   ├── mpesa.png                    # M-Pesa payment logo
│   └── ebirr.png                    # eBirr payment logo
├── build/
│   └── app/outputs/flutter-apk/
│       └── unibite.apk              # Release APK
└── README.md
```

---

## 🚀 How to Run

### Prerequisites
- Flutter SDK 3.x installed
- Android device or emulator (API 21+)
- Or Chrome browser for web preview

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/33-44-53/unibite.git

# 2. Navigate to project
cd unibite

# 3. Install dependencies
flutter pub get

# 4. Run on Chrome (web preview)
flutter run -d chrome

# 5. Run on Android device
flutter run

# 6. Build release APK
flutter build apk --release --target-platform android-arm64
```

---

## 👥 Group Members

| # | Name | Student ID | Presentation Topic |
|---|---|---|---|
| 1 | Umer Selahadin | 1022/15 | Home Screen — Order a Meal use case |
| 2 | Yoftahe Yoseph | 1065/15 | Login Screen — Register a New Account use case |
| 3 | Desalegn Dereje | 0316/15 | Deposit Screen — Deposit Funds use case |
| 4 | Abdi Alemu | 0010/15 | History Screen — Transaction History use case |
| 5 | Tesfatsion Tadesse | 0994/15 | Profile Screen — Camera/Gallery Photo use case |

---

## 🏫 Course Information

- **Course:** Mobile Application Development
- **Institution:** University
- **Project:** UniBite — University Café Contract Management App
- **Submission Deadline:** April 30, 2026

---

## 📄 License

This project is developed for academic purposes only.
