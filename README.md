# OpenMeteo

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/ighiba/open-meteo/blob/main/LICENSE)

## Description
---

OpenMeteo is an iOS application that provides weather information for different locations. It follows the MVVM architectural pattern and utilizes UIKit, SnapKit, and RealmSwift frameworks.

The app consists of three screens:
1. Weather List: Displays a list of weather information for different locations.
2. Weather Detail: Shows detailed weather information for a specific location, including temperature, precipitation, and other relevant data.
3. Location Search: Allows users to search for locations and view weather details for selected locations.

RealmSwift is used for managing the persistence of location data, enabling users to save their preferred locations and retrieve them when launching the app. Weather data is obtained dynamically from the [Open-Meteo API](https://open-meteo.com/) for the selected locations.

## Features
---

- View weather information for multiple locations.
- Search for locations and get real-time weather data.
- Display detailed weather information, including temperature, precipitation, and more.
- Automatic weather information for the user's current location.
- Intuitive and user-friendly interface.

## Screenshots
---

<!-- ![Screenshot 1](screenshots/screenshot1.png) -->
<!-- ![Screenshot 2](screenshots/screenshot2.png) -->

## Installation
---

1. Clone the repository:

```
git clone https://github.com/ighiba/open-meteo.git
```

2. Install dependencies

```
pod install
```

3. Open the .xcworkspace file in Xcode.

4. Build and run the app on a simulator or device.

## Dependencies
---

The app uses the following dependencies, which are managed using CocoaPods:

- SnapKit: A Swift autolayout library for easy and concise UI layout.
- RealmSwift: A database framework for Swift, used for managing the persistence of user-added locations.

Make sure you have CocoaPods installed on your system.

## Requirements
---

- iOS 13.0+
- Xcode 14.0+
- Swift 5.0+

## Usage
---

Provide instructions on how to use your app. For example:

1. Launch the app on your device or simulator.
2. On the Weather List screen, view the weather information for the preloaded locations.
3. Tap on a location to view detailed weather information on the Weather Detail screen.
4. Use the Location Search screen to search for specific locations and view their weather details.

## API
---

The app uses the free open-source weather [Open-Meteo API](https://open-meteo.com/) to fetch weather data for different locations.

## License
---

This project is licensed under the [MIT License](LICENSE).

