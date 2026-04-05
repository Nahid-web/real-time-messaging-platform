# RTMP — Real-Time Messaging Platform

A full-stack, cross-platform messaging app built with **Flutter**, **Firebase**, **Agora RTC**, **Cloudinary**, and **Riverpod**. Supports Android, iOS, and **Web**.

---

## GitHub Repository

[![GitHub Repo](https://img.shields.io/badge/GitHub-Repository-blue?style=for-the-badge)](https://github.com/Nahid-web/real-time-messaging-platform)

---

## Technologies

| Layer | Technology |
|---|---|
| UI / Framework | Flutter (Dart) |
| State Management | Riverpod |
| Authentication | Firebase Auth (Phone + OTP) |
| Database | Cloud Firestore |
| File Storage | Firebase Storage + Cloudinary |
| Audio/Video Calls | Agora RTC Engine |
| Web | Flutter Web (responsive layout) |

---

## Features

### Authentication
- Phone number sign-in with OTP verification
- Country code picker
- Profile setup with name and photo

### Messaging
- One-to-one and group chats
- Message types: text, image, video, audio (with recording), GIF, emoji
- Reply to specific messages (swipe-to-reply)
- Message seen / double-tick confirmation
- Online / offline status indicators
- Auto-scroll to latest message
- Cached images and videos for performance

### Stories
- Post image stories visible only to contacts
- Stories auto-expire after 24 hours

### Calling
- One-to-one audio and video calls (Agora RTC)
- Works on both mobile and web
- Mute / unmute, camera toggle, end call controls
- Incoming call screen with accept / decline

### Web
- Responsive layout — full sidebar + chat panel on wide screens
- Messages, Stories, and Calls tabs on web left panel
- Calling supported directly in the browser

---

## Installation

### Prerequisites
- Flutter SDK `^3.5.4`
- Firebase project
- Cloudinary account
- Agora account (for calling)
- Node.js (for the token server)

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/Nahid-web/real-time-messaging-platform.git
   cd real-time-messaging-platform
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   Enable **Phone Authentication** in the Firebase console.

4. Create a `.env` file in the project root:
   ```env
   CLOUD_NAME=your_cloudinary_cloud_name
   API_KEY=your_cloudinary_api_key
   API_SECRET=your_cloudinary_api_secret
   agoraAppId=your_agora_app_id
   serverBaseUrl=http://localhost:3000
   ```

5. Start the Agora token server:
   ```bash
   cd server
   npm install
   node index.js
   ```

6. Run the app:
   ```bash
   # Mobile
   flutter run

   # Web
   flutter run -d chrome
   ```

---

## Dependencies

| Package | Version |
|---|---|
| agora_rtc_engine | ^6.3.2 |
| audioplayers | ^6.1.0 |
| cached_network_image | ^3.4.1 |
| cached_video_player_plus | ^4.1.0 |
| cloud_firestore | ^6.2.0 |
| cloudinary_flutter | ^1.3.0 |
| country_picker | ^2.0.27 |
| emoji_picker_flutter | ^4.4.0 |
| firebase_auth | ^6.3.0 |
| firebase_core | ^4.6.0 |
| firebase_storage | ^13.2.0 |
| flutter_contacts | ^2.0.1 |
| flutter_dotenv | ^6.0.0 |
| flutter_riverpod | ^3.3.1 |
| flutter_sound | ^9.17.8 |
| giphy_get | ^3.6.0 |
| image_picker | ^1.1.2 |
| permission_handler | ^12.0.1 |
| story_view | ^0.16.5 |
| swipe_to | ^1.0.6 |
| uuid | ^4.5.1 |
| video_player | ^2.11.1 |

---

## Feedback

📧 nahidamin266@gmail.com
