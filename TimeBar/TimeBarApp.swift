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
// 这个类用来监听 App 的生命周期事件，比如“启动完成”。
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        // 程序化设置应用图标，供台前调度使用
    }
}


@main
struct TimeBarApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var userSettings = UserSettings()
    private let updaterController: SPUStandardUpdaterController
    
    init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
    var body: some Scene {
        
        MenuBarExtra {
            ContentView(updater: updaterController.updater)
                .environmentObject(userSettings)
        } label: {
            MenuBarLabelView()
                .environmentObject(userSettings)
        }

        Settings {
            SettingsView(settings: userSettings)
                .onAppear {
                    // 当设置窗口出现时，切换到regular模式并激活应用
                    NSApp.setActivationPolicy(.regular)
                    NSApp.activate(ignoringOtherApps: true)


                    // Workaround for activation issues: toggle focus to Dock and back
                    if let dockApp = NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.dock").first {
                        dockApp.activate(options: [])
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            NSApp.setActivationPolicy(.regular)
                            NSApp.activate(ignoringOtherApps: true)
                        }
                    }
                }
}
    }
}


