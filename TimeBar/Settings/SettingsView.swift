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
                window.standardWindowButton(.zoomButton)?.isEnabled = false

                // 禁用窗口大小调整
                window.styleMask.remove(.resizable)
                
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
    @State private var selectedTab: SettingsTab? = .general

   
        private var navigationTitle: Text {
            switch selectedTab {
            case .general:
                return Text("General")
            case .time:
                return Text("Time Zone")
            case .appearance:
                return Text("Appearance")
            case .none:
                // 当没有选择任何项时的默认标题
                return Text("TimeBar Settings")
            }
        }
    
    var body: some View {
        // 使用 NavigationSplitView 来创建侧边栏布局
            NavigationSplitView(columnVisibility: .constant(.all)) {
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
    @StateObject private var timeBarModel = TimeBarModel.shared
    
    // ... (State 变量等保持不变)
    @State private var showAlert = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var restartButtonText: String = ""
    @State private var laterButtonText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    
                    // ... (以上部分代码保持不变) ...
                    
                    // MARK: - 语言设置组
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
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal, 12)
                    
                    // MARK: - 启动设置组
                    Text("Startup Settings")
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Launch at Login")
                                .fontWeight(.medium)
                            Spacer()
                            Toggle("", isOn: .constant(true))
                                .toggleStyle(.switch)
                        }
                        
                        HStack {
                            Text("Show Settings Window at Startup")
                                .fontWeight(.medium)
                            Spacer()
                            Toggle("", isOn: .constant(false))
                                .toggleStyle(.switch)
                        }
                    }
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal, 12)
                    
                    // MARK: - 更新设置组
                    Text("Update Settings")
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Automatically Check for Updates")
                                .fontWeight(.medium)
                            Spacer()
                            Toggle("", isOn: .constant(true))
                                .toggleStyle(.switch)
                        }
                        
                        Divider().padding(.horizontal, 4)
                        
                        HStack {
                            Text("Automatically Download Updates")
                                .fontWeight(.medium)
                            Spacer()
                            Toggle("", isOn: .constant(false))
                                .toggleStyle(.switch)
                        }
                    }
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal, 12)
                    
                    
                    // MARK: - 检查更新按钮和版本信息 (居中)
                    // !!! 样式修改：移除 alignment: .leading, 使用默认的 center 对齐 !!!
                    VStack(spacing: 8) { // 稍微减小间距
                        Button(action: {
                            print("Check for Updates...")
                        }) {
                            Text("Check for Updates...")
                        }
                        .buttonStyle(.bordered)
                        
                        Text("TimeBar v1.6.3")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 10)
                    // !!! 样式修改：让 VStack 撑满宽度以实现居中 !!!
                    .frame(maxWidth: .infinity, alignment: .center)

                }
                .padding(.vertical, 8)
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

// --- 将"外观"设置项拆分成独立的子视图 ---
struct TimeZoneSettingsView: View {
    @ObservedObject var settings: UserSettings
    let allTimeZones = TimeZone.knownTimeZoneIdentifiers

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // MARK: - 新的设置组 (New Settings Group)
                    // 将所有设置项放入这一个 VStack 中
                    VStack(alignment: .leading, spacing: 12) {
                        
                        // 1. 时区选择行 (Time Zone Row)
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
                        
                        // -- 第一个分割线 --
                        Divider()
                        
                        // 2. 显示国旗开关行 (Show Flag Row)
                        HStack {
                            Text("Show Country Flag")
                                .fontWeight(.medium)
                            Spacer()
                            Toggle("", isOn: $settings.showFlag)
                                .toggleStyle(.switch)
                        }
                        
                        // -- 第二个分割线 --
                        Divider()
                        
                        // 3. 显示时差开关行 (Show Time Difference Row)
                        HStack {
                            Text("Show Time Difference")
                                .fontWeight(.medium)
                            Spacer()
                            Toggle("", isOn: $settings.showTimeDifference)
                                .toggleStyle(.switch)
                        }
                    }
                    // MARK: - 样式修饰符 (Styling Modifiers)
                    // 将所有样式统一应用到这个新的 VStack 容器上
                    .padding() // 给整个组的内容添加统一的内边距
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    .overlay(
                        // 使用 overlay 绘制一个更精致的边框
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    // 最后应用外边距，调整整个组在窗口中的位置
                    .padding(.horizontal, 12)
                    
                }
                .padding(.vertical, 8)
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}

