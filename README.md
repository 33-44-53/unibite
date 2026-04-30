# 🍽️ UniBite — University Student Café Management App

A Flutter mobile application for managing university student café meal contracts. Students can register, login, view their balance, order meals, deposit funds, and track transaction history.

---

## 📱 App Flow

**Landing → Register/Login → Home → Order Meals → History → Profile → Deposit**

---

## ✨ Features

- 🔐 **Register & Login** — Student account system with password, saved locally per student ID
- 💰 **Meal Balance** — Start from 0 ETB, deposit funds and track spending in real time
- 🍳 **Order Meals** — Breakfast, Lunch & Dinner with food selection and quantity control (e.g. 3× Tibs)
- 📋 **Transaction History** — Full history of purchases and deposits with totals summary
- 🏦 **Deposit Funds** — Simulate deposits via CBE Birr, TeleBirr, M-Pesa, eBirr with real logos
- 📖 **Café Menu** — Browse 15 authentic Ethiopian dishes with Amharic descriptions
- 🌐 **Online Store** — Live product data fetched from public API (fakestoreapi.com)
- 📷 **Profile Photo** — Take or pick a photo using device camera/gallery
- 🇪🇹 **Bilingual** — Full English and Amharic language support with one-tap toggle
- 💾 **Local Storage** — All data persisted using SharedPreferences per account

---

## 🛠️ Tech Stack

| Technology | Usage |
|---|---|
| Flutter | UI Framework |
| Dart | Programming Language |
| SharedPreferences | Local data persistence |
| HTTP | API networking |
| image_picker | Camera & gallery access |
| permission_handler | Device permission handling |
| intl | Date formatting |

---

## 📋 Project Requirements Coverage

| Topic | Requirement | Status |
|---|---|---|
| Topic 2 | Stateless & Stateful widgets, Row/Column/Stack, Forms, Snackbar/Dialog | ✅ |
| Topic 3 | Navigator push/pop, data passing, setState(), ChangeNotifier | ✅ |
| Topic 4 | SharedPreferences — accounts, balance, transactions, photo path | ✅ |
| Topic 5 | Fetch from fakestoreapi.com, JSON parsing, loading indicator, error handling | ✅ |
| Topic 6 | image_picker + permission_handler, camera/gallery with full permission flow | ✅ |

---

## 📂 Project Structure

```
lib/
├── main.dart
├── models/
│   └── menu_item.dart
├── screens/
│   ├── splash_screen.dart
│   ├── landing_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── menu_screen.dart
│   ├── history_screen.dart
│   ├── profile_screen.dart
│   ├── deposit_screen.dart
│   └── api_menu_screen.dart
├── services/
│   ├── api_service.dart
│   ├── storage_service.dart
│   └── language_service.dart
└── widgets/
    ├── balance_card.dart
    └── custom_button.dart
```

---

## 🚀 How to Run

### Prerequisites
- Flutter SDK installed
- Chrome browser (for web) or Android device/emulator

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/33-44-53/unibite.git

# 2. Navigate to project
cd unibite

# 3. Install dependencies
flutter pub get

# 4. Run on Chrome
flutter run -d chrome

# 5. Build APK (requires Android SDK)
flutter build apk --release
```

---

## 📦 APK

> Download the latest APK from the [Releases](https://github.com/33-44-53/unibite/releases) section or find it at:
> `build/app/outputs/flutter-apk/app-release.apk`

---

## 🎥 Demo Video

> 📹 Loom Video: **[Add your Loom link here]**

---

## 👥 Group Members

| # | Name | Student ID |
|---|---|---|
| 1 | Umer Selahadin | 1022/15 |
| 2 | Yoftahe Yoseph | 1065/15 |
| 3 | Desalegn Dereje | 0316/15 |
| 4 | Abdi Alemu | 0010/15 |
| 5 | Tesfatsion Tadesse | 0994/15 |

---

## 🏫 Course Information

- **Course:** Mobile Application Development
- **Project:** UniBite — University Café Contract Management App

---

## 📄 License

This project is developed for academic purposes only.
