//
//  ContentView.swift
//  TimeBar
//
//  Created by 曹丁杰 on 2025/9/19.
//

// ContentView.swift 的完整修改

import SwiftUI
import AppKit
import Sparkle
internal import Combine


struct ContentView: View {
    @Environment(\.openSettings) private var openSettings
    let updater: SPUUpdater
    
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

            CheckForUpdatesView(updater: updater)

            Divider()

            Button("Quit TimeBar") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(10)
    }
}

// This view model class publishes when new updates can be checked by the user
final class CheckForUpdatesViewModel: ObservableObject {
    @Published var canCheckForUpdates: Bool
    private var cancellable: AnyCancellable?

    init(updater: SPUUpdater) {
        // First, initialize all stored properties.
        self.canCheckForUpdates = updater.canCheckForUpdates

        // Now that `self` is available, set up the subscription.
        self.cancellable = updater.publisher(for: \.canCheckForUpdates)
            .assign(to: \.canCheckForUpdates, on: self)
    }
}

// This is the view for the Check for Updates menu item
struct CheckForUpdatesView: View {
    @ObservedObject private var checkForUpdatesViewModel: CheckForUpdatesViewModel
    private let updater: SPUUpdater
    
    init(updater: SPUUpdater) {
        self.updater = updater
        
        // Create our view model for our CheckForUpdatesView
        self.checkForUpdatesViewModel = CheckForUpdatesViewModel(updater: updater)
    }
    
    var body: some View {
        Button("Check for Updates…", action: updater.checkForUpdates)
            .disabled(!checkForUpdatesViewModel.canCheckForUpdates)
    }
}


#Preview {
    ContentView(updater: SPUStandardUpdaterController(startingUpdater: false, updaterDelegate: nil, userDriverDelegate: nil).updater)
}
