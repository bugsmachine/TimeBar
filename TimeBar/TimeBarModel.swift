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
        // TODO: 实际切换语言逻辑（如 LocalizedStringKey/Bundle 方案）
        // 目前作为占位，无副作用
    }
}

// TimeBar模型类
class TimeBarModel: ObservableObject {
    static let shared = TimeBarModel()
    
    // 语言选项数据
    let languageOptions = AppLanguage.allCases
    
    private init() {}
    
    // 获取语言选项的显示名称
    func getLanguageDisplayName(for language: AppLanguage) -> String {
        return language.displayName
    }
}

