# 🍽️ UniBite — University Student Café Management App

> **Last Updated:** April 30, 2026 · Built with Flutter · Bilingual (English & Amharic) · Fully Offline

---

## 🎥 Demo Video

> 📹 **[Watch Full Presentation on Loom](https://www.loom.com/share/cc5f1dd8b10b40f5bc1c6b8d643ffe1f)**
> - Live demo on real Android device
> - Full code walkthrough
> - Use case trace explanation
> - 25–30 minutes · All 5 members presenting

---

## 📦 APK Download

> ✅ **[Download unibite.apk](https://github.com/33-44-53/unibite/raw/main/build/app/outputs/flutter-apk/unibite.apk)**
>
> - Min Android: 5.0 (API 21)
> - Size: ~17.3 MB
>
> **Install:** Download → tap APK → enable Unknown Sources → Install

---

## 📱 App Flow

```
Splash Screen
    ↓
Landing Screen  (animated feature showcase)
    ↓
Login / Register  (with password, per-account storage)
    ↓
Home Screen  (balance card + order meals)
    ├── 🍳 Order Breakfast / Lunch / Dinner
    │       └── Select multiple foods + quantity control
    ├── 💰 Deposit Funds  (CBE, TeleBirr, M-Pesa, eBirr)
    ├── 📖 Café Menu  (live meals from TheMealDB API)
    ├── 📋 Transaction History  (purchases + deposits)
    ├── 🌐 Online Meals  (live data from TheMealDB API)
    └── 👤 Profile  (photo, stats, reset account)
```

---

## ✨ Features

| Feature | Description |
|---|---|
| 🔐 Register & Login | Student account with password — each Student ID is a separate account |
| 💰 Meal Balance | Starts at 0 ETB — deposit funds to get started |
| 🍳 Order Meals | Breakfast, Lunch & Dinner — select multiple foods with quantity (e.g. 3× Tibs) |
| 🏦 Deposit Funds | Simulated deposits via CBE Birr, TeleBirr, M-Pesa & eBirr with real logos |
| 📋 Transaction History | Full history of purchases and deposits with totals summary |
| 📖 Café Menu | Live meals fetched from TheMealDB API with category filter and search |
| 🌐 Online Meals | Live meal data fetched from `themealdb.com` with loading indicator and error handling |
| 📷 Profile Photo | Take or pick a photo using device camera or gallery |
| 🇪🇹 Bilingual | Full English ↔ Amharic toggle — one tap switches the entire app |
| 💾 Local Storage | All data persisted using SharedPreferences — works fully offline |
| 👥 Multi-Account | Multiple students can register and login on the same device |

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

**API Used:** [TheMealDB](https://www.themealdb.com/api/json/v1/1/search.php) — free public food/meal REST API

---

## 📋 Project Requirements Coverage

| Topic | Requirement | Implementation | Status |
|---|---|---|---|
| Topic 2 | Stateless & Stateful widgets | `BalanceCard` (Stateless), `_HomeScreenState` (Stateful) | ✅ |
| Topic 2 | Row / Column / Stack layouts | Used throughout all screens | ✅ |
| Topic 2 | Forms & input fields | Register, Login, Deposit forms with full validation | ✅ |
| Topic 2 | Snackbar & Dialog | Order confirmation, insufficient balance dialog, logout dialog | ✅ |
| Topic 3 | Navigator push/pop | All screen transitions with data passing | ✅ |
| Topic 3 | Data passing between screens | Balance returned from DepositScreen to HomeScreen | ✅ |
| Topic 3 | setState() | Used in all stateful screens | ✅ |
| Topic 3 | Structured state | `AppLanguage` ChangeNotifier for language toggle | ✅ |
| Topic 4 | SharedPreferences | Accounts, balance, transactions, photo path — all persisted | ✅ |
| Topic 5 | Fetch from public API | `https://www.themealdb.com/api/json/v1/1/search.php` | ✅ |
| Topic 5 | JSON parsing | `ApiProduct.fromMealJson()` in `api_service.dart` | ✅ |
| Topic 5 | Loading indicator | `CircularProgressIndicator` while fetching | ✅ |
| Topic 5 | Error handling | WiFi-off icon + retry button on failure | ✅ |
| Topic 6 | image_picker plugin | Camera and gallery photo selection | ✅ |
| Topic 6 | permission_handler plugin | Camera and photos permission request | ✅ |
| Topic 6 | Full permission flow | Granted → pick photo · Denied → snackbar · Permanently denied → open settings | ✅ |

---

## 📂 Project Structure

```
unibite/
├── lib/
│   ├── main.dart                    # App entry point + theme
│   ├── models/
│   │   └── menu_item.dart           # MenuItem model + Ethiopian dishes data
│   ├── screens/
│   │   ├── splash_screen.dart       # Animated splash with auto-navigation
│   │   ├── landing_screen.dart      # Animated landing with feature showcase
│   │   ├── login_screen.dart        # Login + Register tabs with validation
│   │   ├── home_screen.dart         # Balance card + meal ordering
│   │   ├── menu_screen.dart         # Café menu fetched from TheMealDB API
│   │   ├── history_screen.dart      # Transaction history with summary
│   │   ├── profile_screen.dart      # Profile photo + stats (Topic 6)
│   │   ├── deposit_screen.dart      # Deposit via CBE, TeleBirr, M-Pesa, eBirr
│   │   └── api_menu_screen.dart     # Online meals from TheMealDB (Topic 5)
│   ├── services/
│   │   ├── api_service.dart         # HTTP fetch + JSON parsing from TheMealDB
│   │   ├── storage_service.dart     # All SharedPreferences operations
│   │   └── language_service.dart    # English/Amharic language toggle
│   └── widgets/
│       ├── balance_card.dart        # Reusable balance display card
│       └── custom_button.dart       # Reusable button widget
├── assets/
│   ├── cbe.jpg                      # CBE Birr logo
│   ├── telebirr.webp                # TeleBirr logo
│   ├── mpesa.png                    # M-Pesa logo
│   └── ebirr.png                    # eBirr logo
└── build/app/outputs/flutter-apk/
    └── unibite.apk                  # Release APK (~17.3 MB)
```

---

## 🚀 How to Run

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
- **Project:** UniBite — University Café Contract Management App
- **Submission Deadline:** April 30, 2026

---

## 📄 License

This project is developed for academic purposes only.
