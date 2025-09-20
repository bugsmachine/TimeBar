//
//  SettingsView.swift
//  TimeBar
//
//  Created by 曹丁杰 on 2025/9/19.
//

import SwiftUI




struct WindowConfigurator: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                // Force the modern unified title bar/toolbar style
                window.styleMask.insert(.unifiedTitleAndToolbar)
                
                // Tell the system NOT to save this window's state upon quitting.
                window.isRestorable = false
                
                // Set up the observer to handle closing the window
                NotificationCenter.default.addObserver(
                    forName: NSWindow.willCloseNotification, object: window, queue: .main
                ) { _ in
                    NSApp.setActivationPolicy(.accessory)
                    TimeBarModel.shared.isSettingsWindowOpen = false
                }
            }
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}

enum SettingsTab: Hashable {
    case general
    case time
    case appearance
}

// --- 主设置视图，现在作为导航的容器 ---
struct SettingsView: View {
    @ObservedObject var settings: UserSettings
    
    // 用于控制侧边栏选择的状态变量
    @State private var selectedTab: SettingsTab? = .general

    // --- 【新增】步骤1: 创建一个计算属性来动态生成标题 ---
        private var navigationTitle: String {
            switch selectedTab {
            case .general:
                // 您也可以在这里使用本地化键 LocalizedStringKey("settings.tab.general")
                return "General"
            case .time:
                return "Time Zone"
            case .appearance:
                return "Appearance"
            case .none:
                // 当没有选择任何项时的默认标题
                return "TimeBar Settings"
            }
        }
    
    var body: some View {
        // 使用 NavigationSplitView 来创建侧边栏布局
        NavigationSplitView {
            // --- 侧边栏 (Sidebar) ---
            List(selection: $selectedTab) {
                Label("General", systemImage: "gear")
                    .tag(SettingsTab.general)
                    .padding(.vertical, 2)
                
                Label("Time Zone", systemImage: "clock")
                    .tag(SettingsTab.time)
                    .padding(.vertical, 2)
                Label("Appearance", systemImage: "paintbrush")
                    .tag(SettingsTab.appearance)
                    .padding(.vertical, 2)
            }
            .listStyle(.sidebar)
            .frame(minWidth: 160, maxWidth: 250)
            .scrollContentBackground(.hidden)
            
        } detail: {
            // --- 内容区 (Detail) ---
            // 根据侧边栏的选择，显示不同的视图
            switch selectedTab {
            case .general:
                GeneralSettingsView(settings: settings)
            case .time:
                TimeZoneSettingsView(settings: settings)
            case .appearance:
                Text("Appearance settings will go here.")
                    .foregroundColor(.secondary)
                    .font(.title2)
            case .none:
                Text("Select a category")
                    .foregroundColor(.secondary)
                    .font(.title2)
            }
        }
        .navigationTitle(navigationTitle)
        .background(WindowConfigurator()) // 窗口关闭逻辑保持不变
    }
}


// --- 2. 将"通用"设置项拆分成独立的子视图 ---
struct GeneralSettingsView: View {
    @ObservedObject var settings: UserSettings
    @StateObject private var timeBarModel = TimeBarModel.shared // 保持对 Model 的引用
    
    // 用于语言切换 Alert 的状态
    @State private var showAlert = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var restartButtonText: String = ""
    @State private var laterButtonText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
//            // 标题区域
//            VStack(alignment: .leading, spacing: 8) {
//                Text("General")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                    .padding(.horizontal, 20)
//                    .padding(.top, 20)
//                
//                Divider()
//                    .padding(.horizontal, 20)
//            }
//            
            // 内容区域
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 语言设置组
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Language:")
                                .fontWeight(.medium)
                            Spacer()
                            Picker("", selection: $settings.selectedLanguage) {
                                ForEach(timeBarModel.languageOptions, id: \.self) { language in
                                    Text(timeBarModel.getLanguageDisplayName(for: language)).tag(language)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(width: 120)
                        }
                    }
                    
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 16)
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
        .onChange(of: settings.selectedLanguage) { oldValue, newValue in
            Task {
                // 语言切换的后台逻辑保持不变
                let newLang = newValue
                let title = LanguageManager.shared.getLocalizedString(forKey: "alert.restart.title", in: newLang)
                let message = LanguageManager.shared.getLocalizedString(forKey: "alert.restart.message", in: newLang)
                let restartText = LanguageManager.shared.getLocalizedString(forKey: "alert.restart.button.now", in: newLang)
                let laterText = LanguageManager.shared.getLocalizedString(forKey: "alert.restart.button.later", in: newLang)
                LanguageManager.shared.setLanguage(newLang)

                await MainActor.run {
                    self.alertTitle = title
                    self.alertMessage = message
                    self.restartButtonText = restartText
                    self.laterButtonText = laterText
                    self.showAlert = true
                }
            }
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button(restartButtonText, role: .destructive) {
                // 重启逻辑不变
                let task = Process()
                task.launchPath = "/usr/bin/open"
                task.arguments = ["-n", Bundle.main.bundlePath]
                task.launch()
                NSApp.terminate(nil)
            }
            Button(laterButtonText, role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
}


// --- 3. 将"外观"设置项拆分成独立的子视图 ---
struct TimeZoneSettingsView: View {
    @ObservedObject var settings: UserSettings
    let allTimeZones = TimeZone.knownTimeZoneIdentifiers

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 标题区域
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Appearance")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                    .padding(.horizontal, 20)
//                    .padding(.top, 20)
//                
//                Divider()
//                    .padding(.horizontal, 20)
//            }
            
            // 内容区域
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 时区设置组
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Time Zone:")
                                .fontWeight(.medium)
                            Spacer()
                            Picker("", selection: $settings.timeZoneIdentifier) {
                                ForEach(allTimeZones, id: \.self) {
                                    Text($0.replacingOccurrences(of: "_", with: " "))
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(width: 180)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    
                    // 显示选项组
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Show Country Flag")
                                .fontWeight(.medium)
                            Spacer()
                            Toggle("", isOn: $settings.showFlag)
                                .toggleStyle(.switch)
                        }
                        
                        Divider()
                            .padding(.horizontal, 4)
                        
                        HStack {
                            Text("Show Time Difference")
                                .fontWeight(.medium)
                            Spacer()
                            Toggle("", isOn: $settings.showTimeDifference)
                                .toggleStyle(.switch)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 16)
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}


// Preview 部分可以更新一下，方便单独调试
#Preview {
    // 预览主设置窗口
    SettingsView(settings: UserSettings())
}
