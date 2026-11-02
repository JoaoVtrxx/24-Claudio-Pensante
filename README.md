# NutriVerse

Nutrition app prototype built by **Equipe Cláudio Pensante** for **Code Race 2025**, using FlutterFlow/Flutter, Firebase and a Dify conversational AI integration.

The project explores a more flexible approach to food planning: users provide their goals and preferences, track meals and weight, and interact with an AI assistant. This repository contains the Flutter application, platform configuration and Firebase support files.

**My role:** project management and full-stack development, as part of the five-person team credited below.

## Application features

- **Account and onboarding:** registration, sign-in, password recovery and a questionnaire for personal details, food preferences and goals.
- **Food diary:** a daily view of meals and calorie intake, backed by Firestore records.
- **Conversational assistant:** a chat interface that calls a Dify proxy and stores conversation history in Firestore.
- **Weight tracking:** weight records and progress charts.
- **Profile management:** personal details, profile photo and account settings.
- **Shared codebase:** Flutter project structure for Android, iOS and web, with a Brazilian Portuguese interface.

## Project concept

The original proposal was to help users adapt food plans to changes in routine, preferences, budget and local food availability, rather than follow a fixed plan. The [competition pitch](pitch/Pitch-Cl%C3%A1udioPensantee.pdf) provides the broader product vision; the feature list above describes the application code in this repository.

## Tech stack

| Area | Technologies |
| --- | --- |
| Application | FlutterFlow export, Flutter, Dart |
| Authentication | Firebase Authentication |
| Data and files | Cloud Firestore, Firebase Storage |
| AI integration | Dify, HTTP API calls, Firebase Cloud Functions endpoint |
| Navigation and state | GoRouter, Provider, persisted FlutterFlow app state |
| Charts | `fl_chart` |

## Running locally

### Requirements

- Flutter SDK with Dart compatible with the package constraints in [`pubspec.yaml`](pubspec.yaml) (`>=3.0.0 <4.0.0`) and its pinned dependencies.
- Chrome for web development, or a configured Android/iOS development environment.
- Firebase services configured for a project you control.
- A Dify application and backend proxy for the chat feature.

The repository does not pin a Flutter SDK version. It also does not contain an APK; Android builds must be generated from source.

### 1. Get the source

```bash
git clone https://github.com/JoaoVtrxx/24-Claudio-Pensante.git
cd 24-Claudio-Pensante
flutter pub get
```

### 2. Configure Firebase

The checked-in configuration references the competition's Firebase project. For an independent setup, replace the configuration with your own project settings:

| File | Platform |
| --- | --- |
| [`lib/backend/firebase/firebase_config.dart`](lib/backend/firebase/firebase_config.dart) | Web initialization |
| [`android/app/google-services.json`](android/app/google-services.json) | Android |
| [`ios/Runner/GoogleService-Info.plist`](ios/Runner/GoogleService-Info.plist) | iOS |

Enable the authentication providers you intend to use, configure Firestore and Storage, and review the rules and indexes under [`firebase/`](firebase). The app's record classes describe the `users`, `diarios` and `chat` collections, along with weight records under each user.

### 3. Connect the AI backend

The chat screen uses `DifyCall` in [`lib/backend/api_requests/api_calls.dart`](lib/backend/api_requests/api_calls.dart). It sends `query`, `conversation_id` and `user` to a Firebase HTTPS function named `difyProxy`, then reads `answer` and `conversation_id` from the response.

The proxy implementation and Dify agent configuration are **not included** in this repository. To reproduce the chat feature, provide a compatible backend, store the Dify credential on that backend and update the endpoint in `DifyCall`.

The same API file also contains a separate direct Dify call definition. Keep private API credentials on the server when configuring or extending this integration.

### 4. Run the application

After configuring the services:

```bash
flutter run -d chrome
```

For a configured mobile device or emulator, select it with `flutter devices`, then run `flutter run -d <device-id>`.

To generate a release APK:

```bash
flutter build apk --release
```

The output is written to `build/app/outputs/flutter-apk/app-release.apk`. Firebase access and the external AI backend are required for the corresponding features; this repository is not a self-contained offline demo.

## Code map

| Path | Contents |
| --- | --- |
| [`lib/pages`](lib/pages) | Authentication, onboarding, diary, chat, charts and profile screens |
| [`lib/components`](lib/components) | Meal, navigation and profile-photo components |
| [`lib/backend/schema`](lib/backend/schema) | Firestore records and meal/ingredient structures |
| [`lib/backend/api_requests`](lib/backend/api_requests) | HTTP request definitions and API helpers |
| [`lib/auth`](lib/auth) | Authentication integration |
| [`lib/flutter_flow`](lib/flutter_flow) | Generated themes, routing, widgets and utility functions |
| [`firebase`](firebase) | Rules, indexes and included Cloud Functions files |
| [`pitch`](pitch) | Competition presentation |

## Team — Cláudio Pensante

| Member | Role |
| --- | --- |
| Gabriel Souza Baggio | Backend and AI engineering |
| Guilherme Menegheti Einloft | Design and project management |
| **João Vitor da Silva** | **Project management and full-stack development** |
| Luís Gustavo Werle Tozevich | Project management and frontend |
| Mathias Eckert Recktenvald | Backend and database administration |
