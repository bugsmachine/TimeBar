//
//  AppModal.swift
//  TimeBar
//
//  Created by 曹丁杰 on 2025/9/20.
//

import Foundation
import SwiftUI
internal import Combine

// 语言选项枚举
enum AppLanguage: String, CaseIterable {
    case system = "auto"
    case english = "en"
    case simplifiedChinese = "zh-Hans"
    case traditionalChinese = "zh-Hant"
    
    var displayName: String {
        switch self {
        case .system:
            return "跟随系统"
        case .english:
            return "English"
        case .simplifiedChinese:
            return "简体中文"
        case .traditionalChinese:
            return "繁體中文"
        }
    }
}




// 语言管理器
// 简易语言管理器占位实现，避免编译错误
final class LanguageManager {
    static let shared = LanguageManager()
    private init() {}
    func setLanguage(_ language: AppLanguage) {
        let defaults = UserDefaults.standard
                
                if language == .system {
                    // 如果是“跟随系统”，则移除自定义设置
                    defaults.removeObject(forKey: "AppleLanguages")
                } else {
                    defaults.set([language.rawValue], forKey: "AppleLanguages")
                }
                
                // UserDefaults 的更改可能不会立即同步，强制同步一下
                defaults.synchronize()
    }
    
    func getLocalizedString(forKey key: String, in language: AppLanguage) -> String {
            // "auto" 跟随系统，我们就用当前的 bundle
            let langCode = language == .system ? Locale.current.language.languageCode?.identifier : language.rawValue
            
            // 找到对应语言的 .lproj 文件夹路径
            guard let path = Bundle.main.path(forResource: langCode, ofType: "lproj"),
                  let bundle = Bundle(path: path) else {
                // 如果找不到特定语言的包，就返回英文作为备用
                return NSLocalizedString(key, comment: "")
            }
            
            // 从找到的语言包中加载翻译
            return NSLocalizedString(key, tableName: nil, bundle: bundle, comment: "")
        }
}

// TimeBar模型类
class TimeBarModel: ObservableObject {
    static let shared = TimeBarModel()
    
    // 语言选项数据
    let languageOptions = AppLanguage.allCases
    
    var isSettingsWindowOpen = false
    
    private init() {}
    
    // 获取语言选项的显示名称
    func getLanguageDisplayName(for language: AppLanguage) -> String {
        return language.displayName
    }
}

