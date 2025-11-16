<div align="center">

# ⏰ TimeBar

**Elegantly display additional time zones in your macOS menu bar**

[🇺🇸 English](#-timebar) | [🇨🇳 中文](https://github.com/bugsmachine/TimeBar/blob/main/README-zh.md)

<img src="https://raw.githubusercontent.com/bugsmachine/TimeBar/refs/heads/main/TimeBarIcon-T.png" width="128" alt="TimeBar Icon">

[![GitHub Release](https://img.shields.io/github/v/release/bugsmachine/TimeBar?style=flat-square&color=blue)](https://github.com/bugsmachine/TimeBar/releases) [![GitHub License](https://img.shields.io/badge/license-CC%20BY--NC--SA%204.0-green?style=flat-square)](LICENSE) [![macOS](https://img.shields.io/badge/macOS-14.1+-blue?style=flat-square)](https://www.apple.com/macos/) [![Made with SwiftUI](https://img.shields.io/badge/Built%20with-SwiftUI-orange?style=flat-square)](https://developer.apple.com/swiftui/)

A lightweight, elegant macOS menu bar application for tracking time zones of colleagues, family, and friends around the world.

[**Download**](#-installation) • [**Features**](#-features) • [**License**](#-license)

</div>

---

## ✨ Features

<table>
  <tr>
    <td width="50%">
      <h4>🌍 Multiple Time Zones</h4>
      Display additional time zones directly in your menu bar. Perfect for remote teams and global connections.
    </td>
    <td width="50%">
      <h4>🚩 Country Flags</h4>
      Visual indicators showing the country/region flag for quick identification at a glance.
    </td>
  </tr>
  <tr>
    <td>
      <h4>⏱️ Time Difference</h4>
      See the offset from your local timezone instantly. Know who's awake without doing math.
    </td>
    <td>
      <h4>🌐 Multi-Language</h4>
      English, Simplified Chinese, and Traditional Chinese support with more languages coming soon.
    </td>
  </tr>
  <tr>
    <td>
      <h4>⚙️ Highly Customizable</h4>
      Drag-and-drop component reordering, custom location names, and flexible display options.
    </td>
    <td>
      <h4>🔄 Auto Updates</h4>
      Built-in update checks via Sparkle framework. Always stay up to date with new features.
    </td>
  </tr>
  <tr>
    <td>
      <h4>💡 Lightweight</h4>
      Minimal resource usage. Sits quietly in your menu bar without slowing down your Mac.
    </td>
    <td>
      <h4>🔒 Privacy First</h4>
      Fully open source and offline-first. Your data never leaves your computer.
    </td>
  </tr>
</table>

---

## 📋 System Requirements

- **macOS 14.1** (Sonoma) or later
- Apple Silicon or Intel Mac

---

## 🚀 Installation

### Download from GitHub

1. Visit the [Releases](https://github.com/bugsmachine/TimeBar/releases) page
2. Download the latest `TimeBar.zip` file
3. Extract the archive
4. Drag `TimeBar.app` to your **Applications** folder

### First Launch

Since TimeBar is not signed with an Apple Developer subscription, you may see a security warning:

1. Open **System Settings** → **Privacy & Security**
2. Find **TimeBar** under "Security"
3. Click **"Open Anyway"** or **"Allow"**
4. Launch TimeBar again

> **Why not code-signed?** TimeBar is developed by a student without a Developer subscription. The app is fully **open source** and safe to use. Check the [source code](https://github.com/bugsmachine/TimeBar) anytime!

---

## 🎯 Quick Start

1. **Launch TimeBar** - It will appear in your menu bar (top-right corner)
2. **Click the TimeBar icon** - Opens the menu
3. **Select "Settings..."** - Configure your time zones
4. **Choose a timezone** - Select from any timezone worldwide
5. **Customize the display** - Add country flags, custom location names, or show time differences

---

## ⚙️ Configuration

### Settings Overview

- **General Settings**: Language selection, auto-launch preferences, auto-update options
- **Appearance Settings**:
  - Drag to reorder components
  - Choose between flags or custom location names
  - Toggle time difference display
  - Select any world timezone

### Component Customization

TimeBar displays components in your menu bar in the order you choose:
- 🕐 **Time** - The current time in selected timezone
- 🌍 **Flag/Location Name** - Visual indicator or custom name
- 📊 **Time Difference** - Offset from your local time
- ☀️/☽ **Day/Night Indicator** - Quick view of current lighting

---

## 🐛 Known Issues & Support

- **Issue**: About window appears without dock icon ✅ Fixed in v1.0.0
- For other issues or feature requests, please [open a GitHub issue](https://github.com/bugsmachine/TimeBar/issues)

---

## 🛠️ Development

TimeBar is built with:
- **SwiftUI** - Modern, declarative UI framework
- **Sparkle** - Auto-update framework
- **AppKit** - macOS integration

### Contributions

While this is a student project, contributions and suggestions are welcome! Feel free to:
- Report bugs
- Suggest features
- Improve documentation
- Submit pull requests

---

## 📝 License

This project is licensed under **CC BY-NC-SA 4.0**

You are free to:
- ✅ Use, modify, and distribute the software
- ✅ Use for personal and educational purposes

With these conditions:
- 📌 **Attribution** - Credit the original author
- 🚫 **Non-Commercial** - Cannot be used for commercial purposes
- 🔄 **Share Alike** - Any modifications must use the same license

For details, see the [LICENSE](LICENSE) file.

---

## 👨‍💻 Author

Created by **bugsmachine** - A student passionate about macOS development

---

<div align="center">

**[⬆ Back to top](#-timebar)**

Made with ❤️ for the global community

</div>
