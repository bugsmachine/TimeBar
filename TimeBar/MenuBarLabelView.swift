import SwiftUI
internal import Combine

struct MenuBarLabelView: View {
    @EnvironmentObject var settings: UserSettings
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var prefix: String = ""
    @State private var timeString: String = "加载中..."
    @State private var dayNightIconName: String = "hourglass"
    @State private var timeDifference: String = ""

    var body: some View {
        Text(buildMenuBarText())
            .font(.system(.body, design: .monospaced))
            .onAppear {
                print("MenuBarLabelView appeared")
                updateMenuBar()
            }
            .onReceive(timer) { _ in
                updateMenuBar()
            }
            .onChange(of: settings.timeZoneIdentifier) { _ in 
                print("TimeZone changed to: \(settings.timeZoneIdentifier)")
                updateMenuBar() 
            }
            .onChange(of: settings.showFlag) { _ in 
                print("ShowFlag changed to: \(settings.showFlag)")
                updateMenuBar() 
            }
            .onChange(of: settings.showTimeDifference) { _ in 
                print("ShowTimeDifference changed to: \(settings.showTimeDifference)")
                updateMenuBar() 
            }
    }
    
    private func buildMenuBarText() -> String {
        var components: [String] = []
        
        // 1. 国旗或城市名
        if settings.showFlag && !prefix.isEmpty {
            components.append(prefix)
        }
        
        // 2. 时间
        components.append(timeString)
        
        // 3. 昼夜图标 (用emoji替代SF Symbol)
        let dayNightEmoji = (dayNightIconName == "sun.max.fill") ? "☀️" : "🌙"
        components.append(dayNightEmoji)
        
        // 4. 时差
        if settings.showTimeDifference && !timeDifference.isEmpty {
            components.append(timeDifference)
        }
        
        return components.joined(separator: " ")
    }

    private func updateMenuBar() {
        print("updateMenuBar called")
        let timeZone = TimeZone(identifier: settings.timeZoneIdentifier) ?? .current
        let date = Date()
        print("Current date: \(date), TimeZone: \(timeZone.identifier)")

        // 1. 时间 (HH:mm)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.timeZone = timeZone
        let newTimeString = timeFormatter.string(from: date)
        print("Formatted time: \(newTimeString)")
        self.timeString = newTimeString

        // 2. 图标 (☀️/🌙)
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "H"
        hourFormatter.timeZone = timeZone
        let hour = Int(hourFormatter.string(from: date)) ?? 0
        print("Current hour: \(hour)")
        // 【修改】将 emoji 替换为 SF Symbol 的名字
        self.dayNightIconName = (hour >= 6 && hour < 18) ? "sun.max.fill" : "moon.fill"
        print("Icon name: \(self.dayNightIconName)")

        // 3. 国旗或城市名
        if settings.showFlag {
            let flag = countryFlag(for: settings.timeZoneIdentifier) ?? "🌍"
            print("Flag: \(flag)")
            self.prefix = flag
        } else {
            self.prefix = ""
        }

        // 4. 时差
        if settings.showTimeDifference {
            let localTimeZone = TimeZone.current
            let differenceInSeconds = timeZone.secondsFromGMT() - localTimeZone.secondsFromGMT()
            let differenceInHours = differenceInSeconds / 3600
            if differenceInHours != 0 {
                self.timeDifference = String(format: "%+d", differenceInHours)
            } else {
                self.timeDifference = ""
            }
            print("Time difference: \(self.timeDifference)")
        } else {
            self.timeDifference = ""
        }
        
        print("Final state - prefix: '\(prefix)', timeString: '\(timeString)', icon: '\(dayNightIconName)', timeDiff: '\(timeDifference)'")
    }

    // 根据时区ID获取国家代码，再转换为国旗emoji
    private func countryFlag(for timeZoneIdentifier: String) -> String? {
        guard let countryCode = timeZoneIdentifier.split(separator: "/").first.map(String.init) else { return nil }
        
        // 一些特殊映射
        let specialCases: [String: String] = [
            "America": "US",
            "Europe": "EU",
            "Asia": ""
        ]
        
        let code = specialCases[countryCode] ?? countryCode

        let base: UInt32 = 127397
        var s = ""
        for v in code.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s.isEmpty ? nil : s
    }
}

#if DEBUG
struct MenuBarLabelView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarLabelView()
            .environmentObject(UserSettings())
    }
}
#endif
