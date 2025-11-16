//
//  TimeBarApp.swift
//  TimeBar
//
//  Created by 曹丁杰 on 2025/9/19.
//

import SwiftUI
internal import Combine
import AppKit
import Sparkle

// --- 【新增】AppDelegate 辅助类 ---
// 这个类用来监听 App 的生命周期事件，比如"启动完成"。
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        // 程序化设置应用图标，供台前调度使用
    }
}

// --- Sparkle 更新委托 ---
class TimeBarUpdaterDelegate: NSObject, SPUUpdaterDelegate {
    weak var settings: UserSettings?

    init(settings: UserSettings) {
        super.init()
        self.settings = settings
    }

    func automaticallyDownloadsUpdates(for updater: SPUUpdater) -> Bool {
        return settings?.automaticallyDownloadUpdates ?? false
    }

    func automaticallyChecksForUpdates(for updater: SPUUpdater) -> Bool {
        return settings?.automaticallyCheckForUpdates ?? true
    }
}


@main
struct TimeBarApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var userSettings = UserSettings()

    private let updaterController: SPUStandardUpdaterController

    init() {
        // Initialize updaterController before body is computed
        let settings = UserSettings()
        let delegate = TimeBarUpdaterDelegate(settings: settings)
        self.updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: delegate, userDriverDelegate: nil)

        // Set the StateObject after initialization
        self._userSettings = StateObject(wrappedValue: settings)
    }

    var body: some Scene {

        MenuBarExtra {
            ContentView(updater: updaterController.updater)
                .environmentObject(userSettings)
        } label: {
            MenuBarLabelView()
                .environmentObject(userSettings)
        }

        WindowGroup(id: "settings-window") {
            SettingsView(settings: userSettings, updater: updaterController.updater)
                .onAppear {
                    NSApp.setActivationPolicy(.regular)
                    NSApp.activate(ignoringOtherApps: true)
                }
                .onDisappear {
                    NSApp.setActivationPolicy(.accessory)
                }
        }
        .defaultPosition(.center)
        .defaultSize(width: 700, height: 500)

    }
}


