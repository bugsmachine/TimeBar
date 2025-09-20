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
    private var updaterController: SPUStandardUpdaterController!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        // 程序化设置应用图标，供台前调度使用
        
        // 初始化Sparkle更新器
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
    // 提供一个方法来检查更新
    func checkForUpdates() {
        // 检查是否配置了更新源
        guard let feedURL = Bundle.main.object(forInfoDictionaryKey: "SUFeedURL") as? String,
              !feedURL.isEmpty else {
            // 如果没有配置更新源，显示提示对话框
            let alert = NSAlert()
            alert.messageText = "更新检查"
            alert.informativeText = "当前版本：\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "未知")\n\n更新源尚未配置。请联系开发者获取更新信息。"
            alert.alertStyle = .informational
            alert.addButton(withTitle: "确定")
            alert.runModal()
            return
        }
        
        updaterController.checkForUpdates(nil)
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


