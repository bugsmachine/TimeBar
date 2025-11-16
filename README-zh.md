<div align="center">

# ⏰ TimeBar

**在你的菜单栏优雅地显示额外的时区**

[🇺🇸 English](README.md) | [🇨🇳 中文](#-timebar)

<img src="https://raw.githubusercontent.com/bugsmachine/TimeBar/refs/heads/main/TimeBarIcon-T.png" width="128" alt="TimeBar Icon">

[![GitHub Release](https://img.shields.io/github/v/release/bugsmachine/TimeBar?style=flat-square&color=blue)](https://github.com/bugsmachine/TimeBar/releases) [![GitHub License](https://img.shields.io/badge/license-CC%20BY--NC--SA%204.0-green?style=flat-square)](LICENSE) [![macOS](https://img.shields.io/badge/macOS-14.1+-blue?style=flat-square)](https://www.apple.com/macos/) [![Made with SwiftUI](https://img.shields.io/badge/Built%20with-SwiftUI-orange?style=flat-square)](https://developer.apple.com/swiftui/)

一款简洁优雅的 macOS 菜单栏应用，完美适用于追踪全球各地的同事、家人和朋友的时间。

[**下载**](#-安装) • [**功能**](#-功能特性) • [**许可证**](#-许可证)

</div>

---

## ✨ 功能特性

<table>
  <tr>
    <td width="50%">
      <h4>🌍 多时区显示</h4>
      在菜单栏中直接显示额外的时区。非常适合远程团队和全球连接。
    </td>
    <td width="50%">
      <h4>🚩 国旗图标</h4>
      显示所选时区对应的国家/地区旗帜，一目了然地识别位置。
    </td>
  </tr>
  <tr>
    <td>
      <h4>⏱️ 时差显示</h4>
      即时查看与本地时间的偏差。无需心算即可了解谁在工作。
    </td>
    <td>
      <h4>🌐 多语言支持</h4>
      支持英文、简体中文和繁体中文，更多语言即将推出。
    </td>
  </tr>
  <tr>
    <td>
      <h4>⚙️ 高度可定制</h4>
      拖放重新排序组件、自定义位置名称和灵活的显示选项。
    </td>
    <td>
      <h4>🔄 自动更新</h4>
      集成 Sparkle 框架，内置更新检查。始终保持最新版本。
    </td>
  </tr>
  <tr>
    <td>
      <h4>💡 轻量级</h4>
      资源占用极少。安静地坐在菜单栏中，不会拖累你的 Mac。
    </td>
    <td>
      <h4>🔒 隐私优先</h4>
      完全开源且离线优先。你的数据永远不会离开你的电脑。
    </td>
  </tr>
</table>

---

## 📋 系统要求

- **macOS 14.1** (Sonoma) 或更高版本
- Apple Silicon 或 Intel Mac

---

## 🚀 安装

### 从 GitHub 下载

1. 访问 [Releases](https://github.com/bugsmachine/TimeBar/releases) 页面
2. 下载最新的 `TimeBar.zip` 文件
3. 解压存档
4. 将 `TimeBar.app` 拖入**应用程序**文件夹

### 首次启动

由于 TimeBar 未使用 Apple 开发者订阅进行代码签名，你可能会看到安全警告：

1. 打开**系统设置** → **隐私与安全**
2. 在"安全"下找到 **TimeBar**
3. 点击**仍要打开**或**允许**
4. 再次启动 TimeBar

> **为什么没有代码签名？** TimeBar 由一名学生开发，没有开发者订阅。该应用完全**开源**，使用完全安全。你可以随时查看[源代码](https://github.com/bugsmachine/TimeBar)！

---

## 🎯 快速开始

1. **启动 TimeBar** - 它会出现在菜单栏中（右上角）
2. **点击 TimeBar 图标** - 打开菜单
3. **选择"设置..."** - 配置你的时区
4. **选择时区** - 从全球任何时区选择
5. **自定义显示** - 添加国旗、自定义位置名称或显示时差

---

## ⚙️ 配置

### 设置概览

- **通用设置**：语言选择、自启动首选项、自动更新选项
- **外观设置**：
  - 拖放重新排序组件
  - 选择国旗或自定义位置名称
  - 切换时差显示
  - 选择任何世界时区

### 组件自定义

TimeBar 在菜单栏中按你选择的顺序显示组件：
- 🕐 **时间** - 所选时区的当前时间
- 🌍 **国旗/位置名称** - 视觉指示符或自定义名称
- 📊 **时差** - 与本地时间的偏差
- ☀️/☽ **日夜指示符** - 快速查看当前光线状况

---

## 🐛 已知问题与支持

- **问题**：打开"关于"窗口时出现 Dock 图标 ✅ 已在 v1.0.0 中修复
- 如有其他问题或功能请求，请[提交 GitHub issue](https://github.com/bugsmachine/TimeBar/issues)

---

## 🛠️ 开发

TimeBar 采用以下技术构建：
- **SwiftUI** - 现代的声明式 UI 框架
- **Sparkle** - 自动更新框架
- **AppKit** - macOS 集成

### 贡献

虽然这是一个学生项目，但欢迎贡献和建议！你可以：
- 报告错误
- 建议功能
- 改进文档
- 提交拉取请求

---

## 📝 许可证

本项目采用 **CC BY-NC-SA 4.0** 许可证

你可以自由地：
- ✅ 使用、修改和分发软件
- ✅ 用于个人和教育目的

但需要遵守以下条件：
- 📌 **署名** - 注明原作者
- 🚫 **非商业性** - 不能用于商业目的
- 🔄 **相同方式共享** - 如果修改本软件并再次分发，必须使用相同许可证

详情请参阅 [LICENSE](LICENSE) 文件。

---

## 👨‍💻 作者

由 **bugsmachine** 创建 - 一位热情的 macOS 开发学生

---

<div align="center">

**[⬆ 返回顶部](#-timebar)**

Made with ❤️ for the global community

</div>
