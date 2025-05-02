# 📚 BookAI – Smart Book Recommendation & Review App

BookAI is a Flutter-based mobile application that helps users discover new books using AI, manage their reading progress, write reviews, and engage in community discussions — all within a beautiful, responsive interface.

---

## 🚀 Features

- 🔐 **User Authentication** (Firebase Email/Password)
- 🔍 **AI-powered Book Search** via Google Books API
- 📚 **Reading List Manager** (Want to Read / Reading / Finished)
- ⭐ **Star-based Review Submission**
- 💬 **Discussion Boards** to connect with fellow readers
- 👤 **User Profile with Genre Preferences**
- 🧪 **Firestore Sync** for all user data
- 🔒 **Secure `.env` Integration** using `flutter_dotenv`

---

## 🛠️ Tech Stack

| Layer       | Technology                        |
|-------------|------------------------------------|
| Frontend    | Flutter                            |
| Backend     | Firebase Auth + Firestore          |
| API         | Google Books API                   |
| State Mgmt  | setState (for simplicity)          |
| Secrets     | `flutter_dotenv` + `.env` file     |

---

## 🗃️ Project Structure

lib/
├── models/ # Book, Review, User models
├── services/ # Auth, Firestore, Book API
├── screens/ # Auth, Home, Profile, Reading List, Discussion
├── widgets/ # Reusable UI components
├── firebase_options.dart
├── main.dart


---

## 🔐 Environment Variables

This app uses `.env` to keep Firebase config secure.

**DO NOT push `.env` to GitHub.**

Example structure in `.env.example`:

```env
WEB_API_KEY=your_web_api_key
WEB_APP_ID=your_web_app_id
WEB_MESSAGING_SENDER_ID=your_sender_id
WEB_PROJECT_ID=your_project_id
WEB_AUTH_DOMAIN=your_auth_domain
WEB_STORAGE_BUCKET=your_storage_bucket
WEB_MEASUREMENT_ID=your_measurement_id

ANDROID_API_KEY=your_android_api_key
ANDROID_APP_ID=your_android_app_id

IOS_API_KEY=your_ios_api_key
IOS_APP_ID=your_ios_app_id
IOS_BUNDLE_ID=your_ios_bundle_id
