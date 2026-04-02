Here is a GitHub-friendly README.md for your repo:

# Virtual Wallet

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9+-blue)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Private-lightgrey)](#)

## About

Virtual Wallet is a Flutter app for securely saving and managing images of cards, IDs, and documents on your device. Everything is stored locally using SQLite, so no data is sent to the cloud.

## Features

- Register and log in locally
- Upload card/document images from camera or gallery
- Store front/back views of cards
- View upload date and details
- Share cards as a single PDF
- Delete stored items
- Password reset with biometric authentication support
- Privacy-first local storage

## Built With

- Flutter
- Dart
- `flutter_riverpod`
- `sqflite`
- `path_provider`
- `local_auth`
- `image_picker`
- `uuid`
- `pdf`
- `share_plus`

## Project Structure

- main.dart — app entry point
- screens — login, register, home, upload, overview screens
- widgets — reusable UI components
- database.dart — SQLite database access
- cards.dart — state provider for cards
- methods — register, share, delete, info helpers
- displayCard.dart — data model

## Getting Started

1. Clone the repo
2. Install Flutter
3. Run:
   - `flutter pub get`
   - `flutter run`

## Usage

1. Open app
2. Register a new user
3. Log in
4. Upload and manage cards/documents
5. Share as PDF or delete items

## Notes

- All user data stays on device
- Uses wallet.png for app icon
- App is set to `publish_to: none` in pubspec.yaml
