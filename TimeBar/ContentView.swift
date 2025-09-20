//
//  ContentView.swift
//  TimeBar
//
//  Created by 曹丁杰 on 2025/9/19.
//

// ContentView.swift 的完整修改

import SwiftUI
import AppKit


struct ContentView: View {
    @Environment(\.openSettings) private var openSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Button("Settings...") {
                // 1. 切换模式，显示Dock图标
                NSApp.setActivationPolicy(.regular)
                
                // 2. 打开设置窗口
                openSettings()
                
                // 3. 激活App，确保窗口在最前
                NSApp.activate(ignoringOtherApps: true)
            }
            
            Divider()
            
            Button("Check for Updates...") {
                if let appDelegate = NSApp.delegate as? AppDelegate {
                    appDelegate.checkForUpdates()
                }
            }

            Divider()

            Button("Quit TimeBar") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(10)
    }
}

#Preview {
    ContentView()
}
