# Estately

**Estately** is a premium, high-performance real estate application built with Flutter. It provides users with an intuitive and seamless experience for discovering, filtering, and enquiring about properties (Homes, Commercial spaces, and Plots).

## 🌟 Key Features

- **Dynamic Property Discovery**: Browse through carefully curated property listings with a stunning UI.
- **Interactive Map Search**: Navigate and discover properties directly on an interactive map, complete with smooth animations and dynamic clustering using `flutter_map`.
- **Advanced Filtering**: Quickly narrow down choices by Property Type (Home, Commercial, Plot), Listing Type (Rent, Sale), Price Range, Bedrooms, and more.
- **Real-Time Profile Tracking**: 
  - Save your favorite properties.
  - Automatically track your "Recently Viewed" properties.
  - Submit direct enquiries to agents and track their status in real-time in the Profile section.
- **Agent Profiles**: View detailed profiles of listing agents and read testimonials.
- **State Management**: Robust architecture utilizing `Provider` for cross-screen data updates and centralized user state.

## 🛠 Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** Provider
- **Mapping:** `flutter_map` with `latlong2`
- **Image Caching:** `cached_network_image`
- **Animations:** Custom transitions and `smooth_page_indicator`

## 🚀 Getting Started

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd Estately
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## 🏗 Architecture & Design System

The app follows a highly modular structure, centralizing styles in a custom Design System:
- **`AppColors`**: Centralized brand and semantic colors ensuring light/dark balance.
- **`AppTextStyles`**: Standardized typography hierarchy.
- **`AppProvider`**: Global state controller that manages Navigation, Property Filters, Saved lists, and User Profile tracking.
