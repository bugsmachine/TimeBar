//
//  SettingsView.swift
//  TimeBar
//
//  Created by 曹丁杰 on 2025/9/19.
//

import SwiftUI
import UniformTypeIdentifiers
import Sparkle




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
    case appearance
}

// --- 主设置视图，现在作为导航的容器 ---
struct SettingsView: View {
    @ObservedObject var settings: UserSettings
    @State private var selectedTab: SettingsTab? = .general
    var updater: SPUUpdater?

    private var navigationTitle: Text {
        switch selectedTab {
        case .general:
            return Text("General")
        case .appearance:
            return Text("Appearance")
        case .none:
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
                GeneralSettingsView(settings: settings, updater: updater)
            case .appearance:
                AppearanceSettingsView(settings: settings)
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

    var updater: SPUUpdater?
    
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
                            Toggle("", isOn: $settings.launchAtLogin)
                                .toggleStyle(.switch)
                        }

                        HStack {
                            Text("Show Settings Window at Startup")
                                .fontWeight(.medium)
                            Spacer()
                            Toggle("", isOn: $settings.showSettingsWindowAtStartup)
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
                            Toggle("", isOn: $settings.automaticallyCheckForUpdates)
                                .toggleStyle(.switch)
                        }

                        Divider().padding(.horizontal, 4)

                        HStack {
                            Text("Automatically Download Updates")
                                .fontWeight(.medium)
                            Spacer()
                            Toggle("", isOn: $settings.automaticallyDownloadUpdates)
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
                    VStack(spacing: 8) {
                        Button(action: {
                            updater?.checkForUpdates()
                        }) {
                            Text("Check for Updates...")
                        }
                        .buttonStyle(.bordered)

                        Text("TimeBar v1.6.3")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 10)
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

// --- Merged Time Zone & Appearance Settings View ---
struct TimeZoneSettingsView: View {
    // This view is now deprecated and merged with AppearanceSettingsView
    @ObservedObject var settings: UserSettings

    var body: some View {
        AppearanceSettingsView(settings: settings)
    }
}

// --- 外观与时区设置视图 (Appearance & Display Settings) ---
struct AppearanceSettingsView: View {
    @ObservedObject var settings: UserSettings
    @State private var draggedComponent: MenuBarComponent?
    let allTimeZones = TimeZone.knownTimeZoneIdentifiers

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    // MARK: - Component Order Section (with Live Preview)
                    ComponentOrderSection(settings: settings, draggedComponent: $draggedComponent)

                    // MARK: - Time Zone & Display Options Section
                    TimeZoneDisplaySection(settings: settings, allTimeZones: allTimeZones)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}

// --- Time Zone & Display Options Combined Section ---
struct TimeZoneDisplaySection: View {
    @ObservedObject var settings: UserSettings
    let allTimeZones: [String]
    @FocusState private var isLocationNameFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Time Zone Settings")
                .font(.headline)
                .fontWeight(.medium)

            VStack(alignment: .leading, spacing: 12) {
                // Time Zone Picker
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

                Divider()

                // Timezone Nickname/Label Input
                HStack {
                    Text("Location Name:")
                        .fontWeight(.medium)
                    Spacer()
                    TextField("e.g., Home, Office, Beijing", text: $settings.timeZoneNickname)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 180)
                        .focused($isLocationNameFocused)
                        .onSubmit {
                            isLocationNameFocused = false
                        }
                }

                Divider()

                // Show Flag Toggle - now shows flag emoji or location/timezone name
                HStack {
                    Text("Show Flag/Name")
                        .fontWeight(.medium)
                    Spacer()
                    Toggle("", isOn: $settings.showFlag)
                        .toggleStyle(.switch)
                }

                Divider()

                // Show Time Difference Toggle
                HStack {
                    Text("Show Time Difference")
                        .fontWeight(.medium)
                    Spacer()
                    Toggle("", isOn: $settings.showTimeDifference)
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
        }
    }
}

// --- 组件排序设置组 ---
struct ComponentOrderSection: View {
    @ObservedObject var settings: UserSettings
    @Binding var draggedComponent: MenuBarComponent?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Component Order")
                .font(.headline)
                .fontWeight(.medium)

            Text("Drag to reorder components shown in the menu bar")
                .font(.caption)
                .foregroundColor(.secondary)

            ComponentListView(settings: settings, draggedComponent: $draggedComponent)
        }
    }
}

// --- 水平可拖拽组件列表 ---
struct ComponentListView: View {
    @ObservedObject var settings: UserSettings
    @Binding var draggedComponent: MenuBarComponent?

    private var visibleComponents: [MenuBarComponent] {
        settings.componentOrder.filter { component in
            component != .timeDifference || settings.showTimeDifference
        }
    }

    var body: some View {
        HStack(spacing: 20) {
            ForEach(Array(visibleComponents.enumerated()), id: \.offset) { _, component in
                SingleComponentView(
                    component: component,
                    isBeingDragged: draggedComponent == component,
                    onDragChange: { value in draggedComponent = value ? component : nil },
                    settings: settings
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

// --- 单个组件卡片 ---
struct SingleComponentView: View {
    let component: MenuBarComponent
    let isBeingDragged: Bool
    let onDragChange: (Bool) -> Void
    @ObservedObject var settings: UserSettings
    @State private var isHovered = false

    var body: some View {
        ComponentDragDropView(
            component: component,
            isBeingDragged: isBeingDragged,
            onDragChange: onDragChange,
            settings: settings,
            isHovered: $isHovered
        )
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// --- Live Component Card View ---
struct ComponentDragDropView: View {
    let component: MenuBarComponent
    let isBeingDragged: Bool
    let onDragChange: (Bool) -> Void
    @ObservedObject var settings: UserSettings
    @Binding var isHovered: Bool

    @State private var liveTime: String = "..."
    @State private var liveFlagOrName: String = ""
    @State private var liveTimeDiff: String = ""
    @State private var liveDayNight: String = ""
    @State private var timer: Timer?

    private var backgroundColor: Color {
        if isBeingDragged {
            return Color.blue.opacity(0.3)
        } else if isHovered {
            return Color.gray.opacity(0.15)
        } else {
            return Color(NSColor.textBackgroundColor)
        }
    }

    private var borderColor: Color {
        if isBeingDragged {
            return Color.blue.opacity(0.6)
        } else if isHovered {
            return Color.gray.opacity(0.4)
        } else {
            return Color.gray.opacity(0.2)
        }
    }

    var body: some View {
        VStack(spacing: 1) {
            componentLiveText
                .font(.system(size: 15, weight: .regular, design: .monospaced))
                .foregroundColor(.primary)
                .lineLimit(1)

            Text(component.displayName)
                .font(.system(size: 8, weight: .regular))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(width: 115, height: 80)
        .background(backgroundColor)
        .cornerRadius(4)
        .border(borderColor, width: 0.5)
        .opacity(isBeingDragged ? 0.8 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isHovered)
        .animation(.easeInOut(duration: 0.15), value: isBeingDragged)
        .onDrag {
            onDragChange(true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onDragChange(false)
            }
            return NSItemProvider(object: component.rawValue as NSString)
        }
        .onDrop(of: [UTType.utf8PlainText], delegate: ComponentDropDelegate(
            component: component,
            settings: settings
        ))
        .onAppear {
            updateLiveData()
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .onChange(of: settings.timeZoneIdentifier) { _, _ in
            updateLiveData()
        }
        .onChange(of: settings.showFlag) { _, _ in
            updateLiveData()
        }
        .onChange(of: settings.timeZoneNickname) { _, _ in
            updateLiveData()
        }
        .onChange(of: settings.showTimeDifference) { _, _ in
            updateLiveData()
        }
    }

    private var componentLiveText: Text {
        switch component {
        case .flag:
            return Text(liveFlagOrName.isEmpty ? "..." : liveFlagOrName)
        case .time:
            return Text(liveTime)
        case .timeDifference:
            return Text(liveTimeDiff.isEmpty ? "-" : liveTimeDiff)
        case .dayNight:
            return Text(liveDayNight)
        }
    }

    private func updateLiveData() {
        let timeZone = TimeZone(identifier: settings.timeZoneIdentifier) ?? .current
        let date = Date()

        // Update time
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.timeZone = timeZone
        liveTime = timeFormatter.string(from: date)

        // Update day/night icon
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "H"
        hourFormatter.timeZone = timeZone
        if let hour = Int(hourFormatter.string(from: date)) {
            liveDayNight = (hour >= 6 && hour < 18) ? "☀︎" : "☽"
        }

        // Update flag or name
        if settings.showFlag {
            if let countryCode = timeZoneToCountryCode[settings.timeZoneIdentifier] {
                liveFlagOrName = countryCodeToFlag(countryCode)
            } else {
                liveFlagOrName = "🌍"
            }
        } else if !settings.timeZoneNickname.isEmpty {
            liveFlagOrName = settings.timeZoneNickname
        } else {
            // Extract city name
            let components = settings.timeZoneIdentifier.split(separator: "/")
            if components.count >= 2 {
                liveFlagOrName = String(components.last!).replacingOccurrences(of: "_", with: " ")
            }
        }

        // Update time difference
        if settings.showTimeDifference {
            let localTimeZone = TimeZone.current
            let differenceInSeconds = timeZone.secondsFromGMT() - localTimeZone.secondsFromGMT()
            let differenceInHours = differenceInSeconds / 3600
            if differenceInHours != 0 {
                liveTimeDiff = String(format: "%+d", differenceInHours)
            } else {
                liveTimeDiff = ""
            }
        } else {
            liveTimeDiff = ""
        }
    }

    private func countryCodeToFlag(_ countryCode: String) -> String {
        let base: UInt32 = 127397
        var s = ""
        for v in countryCode.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateLiveData()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// --- 拖放委托处理 ---
struct ComponentDropDelegate: DropDelegate {
    let component: MenuBarComponent
    @ObservedObject var settings: UserSettings

    func dropEntered(info: DropInfo) {
        // 可以添加视觉反馈
    }

    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [UTType.utf8PlainText]).first else {
            return false
        }

        itemProvider.loadItem(forTypeIdentifier: UTType.utf8PlainText.identifier) { data, _ in
            if let data = data as? Data, let sourceValue = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    performSwap(with: sourceValue)
                }
            }
        }
        return true
    }

    private func performSwap(with sourceValue: String) {
        guard let sourceComponent = MenuBarComponent(rawValue: sourceValue),
              let sourceIndex = settings.componentOrder.firstIndex(of: sourceComponent),
              let targetIndex = settings.componentOrder.firstIndex(of: component) else {
            return
        }

        if sourceIndex != targetIndex {
            settings.componentOrder.swapAt(sourceIndex, targetIndex)
        }
    }
}

#Preview {
    SettingsView(settings: UserSettings(), updater: nil)
        .frame(width: 700, height: 400)
}
