<div align="center">

<img src="https://raw.githubusercontent.com/aashir-athar/BludStack-iOS-Application/main/BludStack/Resources/Assets.xcassets/logo.imageset/BludStack.png" alt="BludStack logo" width="120" />

# 🩸 BludStack — iOS Blood Donation App

**A native iOS blood donation app built with Swift, UIKit, and Firebase — connecting blood donors with recipients in real time.**

[![Stars](https://img.shields.io/github/stars/aashir-athar/BludStack-iOS-Application?style=for-the-badge&logo=github&color=FFD33D)](https://github.com/aashir-athar/BludStack-iOS-Application/stargazers)
[![Last commit](https://img.shields.io/github/last-commit/aashir-athar/BludStack-iOS-Application?style=for-the-badge)](https://github.com/aashir-athar/BludStack-iOS-Application/commits)
[![Top language](https://img.shields.io/github/languages/top/aashir-athar/BludStack-iOS-Application?style=for-the-badge&logo=swift&logoColor=white&color=FA7343)](https://github.com/aashir-athar/BludStack-iOS-Application)
[![Code size](https://img.shields.io/github/languages/code-size/aashir-athar/BludStack-iOS-Application?style=for-the-badge)](https://github.com/aashir-athar/BludStack-iOS-Application)
[![Repo size](https://img.shields.io/github/repo-size/aashir-athar/BludStack-iOS-Application?style=for-the-badge)](https://github.com/aashir-athar/BludStack-iOS-Application)

<a href="https://github.com/aashir-athar/BludStack-iOS-Application/issues"><strong>Report Bug</strong></a> ·
<a href="https://github.com/aashir-athar/BludStack-iOS-Application/issues"><strong>Request Feature</strong></a>

</div>

---

**BludStack** is a native **iOS blood donation app** written in **Swift** that connects **blood donors** with people in urgent need. Built on **UIKit** and **Firebase**, it lets users post blood requests, discover nearby donors by blood group and location, and notify them with push notifications — a lightweight mobile **blood bank** in your pocket.

> Find nearby blood donors by blood group, create emergency blood requests, and get donor notifications — all from a single iPhone app.

> 🚧 **Project status:** A focused, real-world iOS project (originally built in 2021) showcasing a full MVC Swift + Firebase architecture. It is shared as a portfolio / reference implementation.

## ✨ Features

| | Feature | Description |
|---|---|---|
| 🔐 | **OTP Authentication** | Phone-based sign-in with a one-time-password flow and guided profile setup |
| 🩸 | **Blood Requests** | Create, browse, and view detailed blood requests with donor matching |
| 🗺️ | **Map & Location** | Pick a location, view requests on a map, and find donors near you |
| 🔍 | **Donor Search** | Search and filter donors by blood group and proximity |
| 🔔 | **Push Notifications** | Alerts to donors when a matching request is created |
| 🤝 | **Donor Profiles** | Dedicated donor home, donation history, and recipient flows |
| ☁️ | **Firebase Backend** | Cloud Firestore data + Firebase Storage for images, no custom server |
| 🎨 | **Themed UI** | Centralized theme service, custom fonts, colors, and reusable UIKit components |

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Language** | ![Swift](https://img.shields.io/badge/Swift-FA7343?style=flat-square&logo=swift&logoColor=white) |
| **UI** | ![UIKit](https://img.shields.io/badge/UIKit-2396F3?style=flat-square&logo=apple&logoColor=white) Storyboards · XIBs · Auto Layout |
| **Backend** | ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black) Cloud Firestore · Storage |
| **Maps & Location** | ![MapKit](https://img.shields.io/badge/MapKit_%2F_CoreLocation-2396F3?style=flat-square&logo=apple&logoColor=white) |
| **IDE** | ![Xcode](https://img.shields.io/badge/Xcode-147EFB?style=flat-square&logo=xcode&logoColor=white) |
| **Architecture** | MVC — Controllers · Models · Services · Managers · Views |

### Project structure

```text
BludStack/
├── Controllers/      # Auth (Login, OTP, Splash, Profile), Donor, Request, Map, Home
├── Managers/         # UserManager, RequestManager, PushNotificationSender
├── Services/         # Firestore, Firebase Storage, Location, ImagePicker, Theme, Date
├── Model/            # ObjectUser, ObjectRequest
├── Views/            # Custom cells, text fields, reusable UIKit views (+ XIBs)
├── Storyboards/      # Auth, Main, LaunchScreen
├── Utills/           # Extensions, Enums, Protocols, Typealiases, Constants, Alerts
└── Resources/        # Assets, app icons, logo
```

## 🚀 Getting Started

### Prerequisites

- **Xcode** 13 or newer
- **iOS** 13+ deployment target (uses `SceneDelegate`)
- A **Firebase** project with Firestore and Storage enabled
- An Apple developer signing identity for running on a device

### Installation

```bash
git clone https://github.com/aashir-athar/BludStack-iOS-Application.git
cd BludStack-iOS-Application
```

Open the project in Xcode:

```bash
open BludStack.xcodeproj
```

### Configure Firebase

This app uses Firebase via a `GoogleService-Info.plist`. The committed plist is tied to the original project, so connect your own backend:

1. Create a project in the [Firebase Console](https://console.firebase.google.com/).
2. Add an iOS app and download **your** `GoogleService-Info.plist`.
3. Replace the file at `BludStack/Main/GoogleService-Info.plist`.
4. Enable **Phone Authentication**, **Cloud Firestore**, and **Firebase Storage** in the console.

### Run

Select an iOS Simulator or a connected device in Xcode and press **⌘R** to build and run.

## 📖 Usage

Once the app launches:

1. **Sign in** with your phone number and verify the OTP, then complete your profile and blood group.
2. **Create a request** for a specific blood group and set a location on the map.
3. **Browse requests** in your area and open a request to see its details.
4. **Donors get notified** via push notifications when a matching request is posted.
5. **Track donations** from the donor section and manage your profile from the menu.

## 🗺️ Roadmap

- [x] OTP authentication & profile setup
- [x] Blood request creation, listing & detail views
- [x] Map-based location selection & donor search
- [x] Push notifications to donors
- [ ] Swift Package Manager / dependency manifest in repo
- [ ] In-app chat between donor and recipient
- [ ] Dark mode & accessibility polish
- [ ] Unit & UI test coverage

## 🤝 Contributing

Contributions are welcome. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create a feature branch (`git checkout -b feat/your-feature`)
3. Commit your changes (`git commit -m 'feat: add your feature'`)
4. Push the branch (`git push origin feat/your-feature`)
5. Open a Pull Request

## 📄 License

See the repository's `LICENSE` file (if present) for license details. If no license is included, all rights are reserved by the author.

## 👤 Author

**Aashir Athar**

[![GitHub](https://img.shields.io/badge/GitHub-aashir--athar-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/aashir-athar)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-aashirathar-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/aashirathar/)
[![X](https://img.shields.io/badge/X_(Twitter)-aashirathar-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/aashirathar)

---

<div align="center">

<sub>Built with 🩸 and Swift by <a href="https://github.com/aashir-athar">Aashir Athar</a> · If this project helped you, consider leaving a ⭐</sub>

<br/><br/>

<sub><strong>Keywords:</strong> iOS blood donation app · blood bank management · find blood donors · Swift UIKit Firebase app · blood donor matching · healthcare iOS app · Firestore mobile app · blood request app</sub>

</div>
