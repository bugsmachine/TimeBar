//
//  SettingsView.swift
//  TimeBar
//
//  Created by 曹丁杰 on 2025/9/19.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: UserSettings
    
    // 所有支持的时区列表
    let allTimeZones = TimeZone.knownTimeZoneIdentifiers
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("应用设置")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Form {
                // 时区选择
                Picker("选择时区:", selection: $settings.timeZoneIdentifier) {
                    ForEach(allTimeZones, id: \.self) {
                        Text($0.replacingOccurrences(of: "_", with: " "))
                    }
                }
                
                // 显示国旗或城市名称
                Toggle(isOn: $settings.showFlag) {
                    Text("显示国旗（否则显示城市名称）")
                }
                
                // 显示时差
                Toggle(isOn: $settings.showTimeDifference) {
                    Text("显示时差")
                }
            }
            
            Spacer()
        }
        .padding()
        .frame(width: 450, height: 300)
        .background(WindowCloseObserver())
    }
}
    
// --- 辅助视图，用来监听窗口关闭 ---
// NSViewRepresentable 是 SwiftUI 和 AppKit 之间的桥梁。
struct WindowCloseObserver: NSViewRepresentable {
    
    // 创建一个NSView实例
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        
        // 我们不能立即获取窗口，所以延迟到下一个UI更新周期
        DispatchQueue.main.async {
            // 通过这个视图，我们可以找到它所在的窗口 (NSWindow)
            if let window = view.window {
                // 监听这个特定窗口的“即将关闭”通知
                NotificationCenter.default.addObserver(
                    forName: NSWindow.willCloseNotification,
                    object: window,
                    queue: .main
                ) { _ in
                    // 当收到通知时（即用户关闭了窗口），执行这里的代码
                    
                    // 将App模式切换回“附件”，这会自动隐藏Dock图标
                    NSApp.setActivationPolicy(.accessory)
                }
            }
        }
        return view
    }
    
    // 更新NSView（在这里我们不需要做什么）
    func updateNSView(_ nsView: NSView, context: Context) {}
}


#Preview {
    SettingsView(settings: UserSettings())
}
