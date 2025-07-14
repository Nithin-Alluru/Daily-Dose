# Daily Dose

Daily Dose is an iOS application built with Swift and SwiftUI that aggregates news, weather, comics, memes, and sudoku into a single, modern interface. It leverages real-time third-party APIs and provides a personalized daily dashboard.

## Features

- **News Feed:** Browse trending and searchable news articles from NewsAPI. Bookmark articles for later reading.
- **Weather:** View current weather and 3-hour forecasts for your location or selected cities using OpenWeather and Mapbox APIs. Includes immersive, dynamic backgrounds and interactive weather maps.
- **Comics:** Enjoy the latest xkcd comic, search for comics, and save favorites.
- **Memes:** Get fresh memes from meme-api.com, including author and subreddit info.
- **Sudoku:** Play sudoku puzzles with a clean, mobile-friendly interface.
- **User Authentication:** Secure login with password and biometric support (FaceID/TouchID). Password reset and security questions available.
- **Settings:** Customize app appearance, manage security questions, and toggle display options.
- **Local Database:** SwiftData-powered storage for bookmarks, favorites, and initial content.

## Powered By

- NewsAPI
- OpenWeather
- Mapbox
- xkcd
- Meme API

## Screenshots

*Add screenshots of each tab for best presentation.*

## Getting Started

### Prerequisites

- Xcode 15 or later
- iOS 16.0+
- Swift 5.9+
- API keys for NewsAPI, OpenWeather, and Mapbox (see below)

### Setup

1. **Clone the repository:**
   ```sh
   git clone https://github.com/Nithin-Alluru/Daily-Dose.git
   ```

2. **Open in Xcode:**
   - Open `DailyDose.xcodeproj` or `DailyDose.xcworkspace`.

3. **API Keys:**
   - The project uses hardcoded API keys in `DailyDose/Supporting Files/Globals.swift`.
   - For production, replace these with your own keys:
     - `newsAPIKey`
     - `openWeatherAPIKey`
     - `mapboxAPIKey`
   - Register for free API keys at the respective provider websites.
   - Example:
     ```swift
     // DailyDose/Supporting Files/Globals.swift
     let newsAPIKey = "YOUR_NEWSAPI_KEY"
     let openWeatherAPIKey = "YOUR_OPENWEATHER_KEY"
     let mapboxAPIKey = "YOUR_MAPBOX_KEY"
     ```

4. **Build & Run:**
   - Select a simulator or device and click **Run** in Xcode.

## Folder Structure

- `DailyDose/Startup Views/` – App entry, login, and main tab view
- `DailyDose/API Models/` – API integration for News, Weather, Comics, Memes, and Mapbox
- `DailyDose/Tab View Items/` – UI for each tab (News, Weather, Comics, Memes, Sudoku, Settings)
- `Database` – SwiftData models and initial content
- `Assets.xcassets` – App icons, colors, and images
- `DailyDose/Supporting Files/` – Utility functions, authentication, global variables

## Usage

- **News:** Search, filter, and bookmark articles.
- **Weather:** View current and forecasted weather, switch cities, and explore weather maps.
- **Comics:** Read the comic of the day, search, and save favorites.
- **Memes:** Browse trending memes.
- **Sudoku:** Play and solve puzzles.
- **Settings:** Manage account and app preferences.

> 📌 **Note:** This repository is a **mirrored academic project** developed as part of a collaborative assignment for CS 3714 (Mobile Software Development) at Virginia Tech.  
> All commit history and contributions reflect work originally done in the source repository: [VT GitLab – cs3714-semester-project-daily-dose](https://git.cs.vt.edu/aargmz02/cs3714-semester-project-daily-dose).