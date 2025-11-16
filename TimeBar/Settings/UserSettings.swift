import Foundation
internal import Combine
import ServiceManagement
import AppKit

// 菜单栏中可显示的组件类型
enum MenuBarComponent: String, CaseIterable, Codable {
    case flag
    case time
    case timeDifference
    case dayNight

    var displayName: String {
        switch self {
        case .flag:
            return "Country Flag / City"
        case .time:
            return "Time"
        case .timeDifference:
            return "Time Difference"
        case .dayNight:
            return "Day/Night"
        }
    }
}

// 用于管理用户设置的类
class UserSettings: ObservableObject {
    // 当设置项发生变化时，会发出通知
    let objectWillChange = PassthroughSubject<Void, Never>()

    // 存储时区ID，例如 "Asia/Shanghai"
    @Published var timeZoneIdentifier: String = "Asia/Shanghai" {
        didSet {
            UserDefaults.standard.set(timeZoneIdentifier, forKey: "timeZoneIdentifier")
            objectWillChange.send()
        }
    }

    // 存储是否显示国旗
    @Published var showFlag: Bool = true {
        didSet {
            UserDefaults.standard.set(showFlag, forKey: "showFlag")
            objectWillChange.send()
        }
    }

    // 存储是否显示时差
    @Published var showTimeDifference: Bool = true {
        didSet {
            UserDefaults.standard.set(showTimeDifference, forKey: "showTimeDifference")
            objectWillChange.send()
        }
    }

    // 存储时区的自定义昵称/标签
    @Published var timeZoneNickname: String = "" {
        didSet {
            UserDefaults.standard.set(timeZoneNickname, forKey: "timeZoneNickname")
            objectWillChange.send()
        }
    }
    
    // 存储用户选择的语言
    @Published var selectedLanguage: AppLanguage = .system {
        didSet {
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "selectedLanguage")
            // 通知语言管理器更新语言
            LanguageManager.shared.setLanguage(selectedLanguage)
            objectWillChange.send()
        }
    }

    // 存储菜单栏组件的显示顺序
    @Published var componentOrder: [MenuBarComponent] = [.flag, .time, .dayNight, .timeDifference] {
        didSet {
            if let encoded = try? JSONEncoder().encode(componentOrder) {
                UserDefaults.standard.set(encoded, forKey: "componentOrder")
            }
            objectWillChange.send()
        }
    }

    // 存储时差组件上次被隐藏时的位置，用于重新显示时恢复位置
    @Published var timeDifferenceLastIndex: Int = 3 {
        didSet {
            UserDefaults.standard.set(timeDifferenceLastIndex, forKey: "timeDifferenceLastIndex")
            objectWillChange.send()
        }
    }

    // 存储是否在登录时启动应用
    @Published var launchAtLogin: Bool = false {
        didSet {
            UserDefaults.standard.set(launchAtLogin, forKey: "launchAtLogin")
            objectWillChange.send()
            updateLaunchAtLogin()
        }
    }

    // 存储是否在启动时显示设置窗口
    @Published var showSettingsWindowAtStartup: Bool = false {
        didSet {
            UserDefaults.standard.set(showSettingsWindowAtStartup, forKey: "showSettingsWindowAtStartup")
            objectWillChange.send()
        }
    }

    // 存储是否自动检查更新
    @Published var automaticallyCheckForUpdates: Bool = true {
        didSet {
            UserDefaults.standard.set(automaticallyCheckForUpdates, forKey: "automaticallyCheckForUpdates")
            objectWillChange.send()
            updateAutomaticUpdateCheck()
        }
    }

    // 存储是否自动下载更新
    @Published var automaticallyDownloadUpdates: Bool = false {
        didSet {
            UserDefaults.standard.set(automaticallyDownloadUpdates, forKey: "automaticallyDownloadUpdates")
            objectWillChange.send()
            updateAutomaticUpdateDownload()
        }
    }

    init() {
        // 从UserDefaults加载保存的设置
        if let savedTimeZone = UserDefaults.standard.string(forKey: "timeZoneIdentifier") {
            timeZoneIdentifier = savedTimeZone
        }

        showFlag = UserDefaults.standard.bool(forKey: "showFlag")
        showTimeDifference = UserDefaults.standard.bool(forKey: "showTimeDifference")

        // 加载时区昵称
        if let savedNickname = UserDefaults.standard.string(forKey: "timeZoneNickname") {
            timeZoneNickname = savedNickname
        }

        // 加载语言设置
        if let savedLanguageRaw = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let savedLanguage = AppLanguage(rawValue: savedLanguageRaw) {
            selectedLanguage = savedLanguage
        }

        // 加载组件顺序设置
        if let savedComponentOrder = UserDefaults.standard.data(forKey: "componentOrder"),
           let decoded = try? JSONDecoder().decode([MenuBarComponent].self, from: savedComponentOrder) {
            componentOrder = decoded
        }

        // 加载时差组件的最后位置
        let savedIndex = UserDefaults.standard.integer(forKey: "timeDifferenceLastIndex")
        if savedIndex > 0 {
            timeDifferenceLastIndex = savedIndex
        }

        // 加载启动设置
        launchAtLogin = UserDefaults.standard.bool(forKey: "launchAtLogin")
        showSettingsWindowAtStartup = UserDefaults.standard.bool(forKey: "showSettingsWindowAtStartup")

        // 加载更新设置
        if UserDefaults.standard.object(forKey: "automaticallyCheckForUpdates") == nil {
            // 如果之前没有保存过，使用默认值 true
            automaticallyCheckForUpdates = true
        } else {
            automaticallyCheckForUpdates = UserDefaults.standard.bool(forKey: "automaticallyCheckForUpdates")
        }
        automaticallyDownloadUpdates = UserDefaults.standard.bool(forKey: "automaticallyDownloadUpdates")

        // 初始化时更新启动项和更新设置
        updateLaunchAtLogin()
        updateAutomaticUpdateCheck()
        updateAutomaticUpdateDownload()
    }

    // MARK: - Launch at Login Implementation
    private func updateLaunchAtLogin() {
        #if os(macOS)
        if #available(macOS 13.0, *) {
            let service = SMAppService.mainApp

            // Debug: Check app's code signing status
            debugPrintCodeSigningStatus()

            do {
                if launchAtLogin {
                    // Try to register for launch at login
                    if service.status != .enabled {
                        try service.register()
                        print("✅ Successfully registered app to launch at login")
                    } else {
                        print("ℹ️ App is already registered to launch at login")
                    }
                } else {
                    // Try to unregister from launch at login
                    if service.status == .enabled {
                        try service.unregister()
                        print("✅ Successfully unregistered app from launch at login")
                    } else {
                        print("ℹ️ App is not registered to launch at login")
                    }
                }
            } catch {
                // Handle any error
                let errorDescription = error.localizedDescription
                let errorCode = (error as NSError).code
                print("❌ Failed to update launch at login: \(errorDescription) (Code: \(errorCode))")

                DispatchQueue.main.async {
                    // Revert the toggle if operation failed
                    self.launchAtLogin = !self.launchAtLogin
                }

                // Show detailed error notification
                showLaunchAtLoginError(errorDescription, errorCode: errorCode)
            }
        }
        #endif
    }

    // Debug function to check code signing status
    private func debugPrintCodeSigningStatus() {
        if let executablePath = Bundle.main.executablePath {
            print("📱 App executable: \(executablePath)")

            // Try to get code signing info
            let task = Process()
            task.launchPath = "/usr/bin/codesign"
            task.arguments = ["-v", "-v", executablePath]

            let pipe = Pipe()
            task.standardError = pipe
            task.standardOutput = pipe

            do {
                try task.run()
                task.waitUntilExit()

                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8) {
                    print("📋 Code signing info:\n\(output)")
                }
            } catch {
                print("⚠️ Could not check code signing: \(error)")
            }
        }
    }

    // Helper to show detailed error notification
    private func showLaunchAtLoginError(_ errorDescription: String, errorCode: Int) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Cannot Update Launch at Login"

            // Provide specific guidance based on error code
            var detailedMessage = ""
            if errorCode == 1 {
                detailedMessage = """
                The app is not properly code-signed. This is required for the "Launch at Login" feature on macOS 13.0+.

                To fix this:
                1. In Xcode, select the TimeBar project
                2. Go to Build Settings
                3. Make sure "Signing Certificate" is set to a valid Apple Development certificate
                4. Ensure the "Team ID" is correctly set

                Error: \(errorDescription)
                """
            } else {
                detailedMessage = """
                Failed to register app for launch at login.

                Error: \(errorDescription) (Code: \(errorCode))

                This may require your Apple Developer account or proper code signing credentials.
                """
            }

            alert.informativeText = detailedMessage
            alert.addButton(withTitle: "OK")
            alert.alertStyle = .warning
            alert.runModal()
        }
    }

    // MARK: - Automatic Update Check Implementation
    private func updateAutomaticUpdateCheck() {
        // This will be handled by Sparkle configuration
        // The updater will use this setting to determine if automatic checks are enabled
        NotificationCenter.default.post(name: NSNotification.Name("UpdateSettingsChanged"), object: nil)
    }

    // MARK: - Automatic Download Implementation
    private func updateAutomaticUpdateDownload() {
        // This will be handled by Sparkle configuration
        // The updater will use this setting to determine if automatic downloads are enabled
        NotificationCenter.default.post(name: NSNotification.Name("UpdateSettingsChanged"), object: nil)
    }
}
