بسم الله الرحمن الرحيم

<img src=".readme/app-logo.png" height="50">

<p align="left">
    <img src="https://img.shields.io/badge/Swift-5.4-orange.svg" />
    <a href="https://telegram.me/jawziyya">
        <img src="https://img.shields.io/badge/telegram-@jawziyya-blue.svg?style=flat" alt="Telegram: @jawziyya" />
    </a>
</p>

<br>

## Compatibility

Azkar app supports the following platforms:

- 📱 iOS/iPad 15.0+
- 🖥 macOS 12.0+

<br>

## Download
[![Download on the App Store](http://linkmaker.itunes.apple.com/images/badges/en-us/badge_appstore-lrg.svg)](https://apple.co/2X7LNo7)

## Installation

Azkar app uses [Tuist](https://tuist.io) to generate Xcode project file.

1. Install Tuist.
2. Go to the project directory and run `tuist generate`
3. Open `Azkar.xcodeproj`
4. Build and run.

## Continuous Deployment

App Store submissions are handled through GitHub Actions. When a tag matching
`iOS_v*` or `macOS_v*` is pushed, the CD workflow builds the app and uploads it
to App Store Connect. Pushes to `release/*` branches automatically create
TestFlight builds using the `closed_beta` lane. You can also trigger TestFlight
builds manually from the Actions tab using the `CD` workflow.
