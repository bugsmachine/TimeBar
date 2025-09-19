//
//  TimeBarApp.swift
//  TimeBar
//
//  Created by 曹丁杰 on 2025/9/19.
//

import SwiftUI
internal import Combine

// --- 【新增】AppDelegate 辅助类 ---
// 这个类用来监听 App 的生命周期事件，比如“启动完成”。
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 当 App 完成启动后，这个函数会被调用。
        // 我们在这里立即将 App 模式设为“附件”，从而隐藏 Dock 图标。
        NSApp.setActivationPolicy(.accessory)
    }
}


@main
struct TimeBarApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var userSettings = UserSettings()
    
    var body: some Scene {
        
        MenuBarExtra {
            ContentView()
                .environmentObject(userSettings)
        } label: {
            MenuBarLabelView()
                .environmentObject(userSettings)
        }

        Settings {
            SettingsView(settings: userSettings)
        }
    }
}
