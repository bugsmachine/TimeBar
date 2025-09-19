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

    init() {
        // 从 UserDefaults 加载保存的设置
        self.timeZoneIdentifier = UserDefaults.standard.string(forKey: "timeZoneIdentifier") ?? "Asia/Shanghai"
        self.showFlag = UserDefaults.standard.bool(forKey: "showFlag")
        self.showTimeDifference = UserDefaults.standard.bool(forKey: "showTimeDifference")
    }
}
