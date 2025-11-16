import Foundation
internal import Combine

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
    
    // 存储用户选择的语言
    @Published var selectedLanguage: AppLanguage = .system {
        didSet {
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "selectedLanguage")
            // 通知语言管理器更新语言
            LanguageManager.shared.setLanguage(selectedLanguage)
            objectWillChange.send()
        }
    }

    init() {
        // 从UserDefaults加载保存的设置
        if let savedTimeZone = UserDefaults.standard.string(forKey: "timeZoneIdentifier") {
            timeZoneIdentifier = savedTimeZone
        }
        
        showFlag = UserDefaults.standard.bool(forKey: "showFlag")
        showTimeDifference = UserDefaults.standard.bool(forKey: "showTimeDifference")
        
        // 加载语言设置
        if let savedLanguageRaw = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let savedLanguage = AppLanguage(rawValue: savedLanguageRaw) {
            selectedLanguage = savedLanguage
        }
    }
}
