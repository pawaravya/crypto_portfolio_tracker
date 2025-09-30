# Crypto Portfolio Tracker

A Flutter application to track and manage cryptocurrency portfolios.  
Users can add coins, view live prices, calculate portfolio value, and manage their holdings in a simple and user-friendly way.

---

## Features
- Add and remove coins from portfolio  
- Live price updates every few seconds  
- Automatic calculation of total portfolio value  
- Local storage to save data between app restarts  
- Shimmer effect while loading data  
- Lottie animations for empty states and errors  
- Simple and responsive UI for both Android and iOS  

---

## Setup Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/pawaravya/crypto_portfolio_tracker.git
Navigate to the project folder:

cd crypto_portfolio_tracker
Get the dependencies:

flutter pub get
Run the application:


flutter run

---

Architectural Choices

State Management: GetX (controller-driven, reactive updates)

Persistence: SharedPreferences for storing user’s coins locally

API Layer: Repository + Service (separation of concerns)

UI Layer: Modular widgets with reusable components

---

Third-party Packages

http

hexcolor

internet_connection_checker

cached_network_image

logger

lottie

shimmer

package_info_plus

flutter_svg

shared_preferences

get

top_snackbar_flutter

---
Demo video 
https://drive.google.com/file/d/1QPyuVyxBjtxmbw5rhEp27zxf1v0sMnyQ/view?usp=sharing
---

Apk 
https://drive.google.com/file/d/1lrfiri-CpjSF4PC5NdVfXaY2V5US-p-U/view?usp=sharing
---

