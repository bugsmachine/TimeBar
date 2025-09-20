import SwiftUI
internal import Combine

struct MenuBarLabelView: View {
    @EnvironmentObject var settings: UserSettings
    
    // Timer 最好不要放在 @State 中
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // 使用 @State 来存储需要在视图中动态展示的各个部分
    @State private var prefix: String = ""
    @State private var timeString: String = "..." // 使用更简洁的加载中提示
    @State private var dayNightIconName: String = "hourglass"
    @State private var timeDifference: String = ""

    var body: some View {
        // 方案1：使用纯Text + SF Symbol字符
        Text(buildMenuBarTextWithSymbols())
            .font(.system(.body, design: .monospaced))
            .foregroundColor(.primary)
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
    
    private func buildMenuBarTextWithSymbols() -> String {
        var components: [String] = []
        
        // 1. 国旗或城市名 (总是显示prefix，无论是国旗还是城市名)
        if !prefix.isEmpty {
            components.append(prefix)
        }
        
        // 2. 时间
        components.append(timeString)
        
        // 3. 时差
        if settings.showTimeDifference && !timeDifference.isEmpty {
            components.append(timeDifference)
        }
        
        // 4. 昼夜图标 - 使用SF Symbol的Unicode字符
        let symbolChar = (dayNightIconName == "sun.max.fill") ? "☀︎" : "☽"
        components.append(symbolChar)
        
        
        
        return components.joined(separator: " ")
    }

    private func updateMenuBar() {
        let timeZone = TimeZone(identifier: settings.timeZoneIdentifier) ?? .current
        let date = Date()

        // 1. 更新时间
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.timeZone = timeZone
        self.timeString = timeFormatter.string(from: date)

        // 2. 更新昼夜图标
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "H"
        hourFormatter.timeZone = timeZone
        if let hour = Int(hourFormatter.string(from: date)) {
            self.dayNightIconName = (hour >= 6 && hour < 18) ? "sun.max.fill" : "moon.fill"
        }

        // 3. 更新前缀 (国旗或地区名称)
        if settings.showFlag {
            self.prefix = countryFlag(for: settings.timeZoneIdentifier) ?? "🌍"
        } else {
            // 不显示国旗时，显示地区名称
            self.prefix = extractCityName(from: settings.timeZoneIdentifier)
        }

        // 4. 更新时差
        if settings.showTimeDifference {
            let localTimeZone = TimeZone.current
            let differenceInSeconds = timeZone.secondsFromGMT() - localTimeZone.secondsFromGMT()
            let differenceInHours = differenceInSeconds / 3600
            if differenceInHours != 0 {
                self.timeDifference = String(format: "%+d", differenceInHours)
            } else {
                self.timeDifference = ""
            }
        } else {
            self.timeDifference = "" // 如果不显示，就设置为空字符串
        }
    }

    private func extractCityName(from timeZoneIdentifier: String) -> String {
        // 从时区标识符中提取城市名称
        // 例如: "Asia/Shanghai" -> "Shanghai", "America/New_York" -> "New York"
        let components = timeZoneIdentifier.split(separator: "/")
        if components.count >= 2 {
            let cityName = String(components.last!)
            // 将下划线替换为空格，让城市名更易读
            return cityName.replacingOccurrences(of: "_", with: " ")
        }
        // 如果无法解析，返回完整的时区标识符
        return timeZoneIdentifier
    }

    private func countryFlag(for timeZoneIdentifier: String) -> String? {
        // ... 这个函数保持不变 ...
        guard let countryCode = timeZoneIdentifier.split(separator: "/").first.map(String.init) else { return nil }
        
        let specialCases: [String: String] = [
            "America": "US", "Europe": "EU", "Asia": ""
        ]
        
        let code = specialCases[countryCode] ?? countryCode

        let base: UInt32 = 127397
        var s = ""
        for v in code.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s.isEmpty ? "🌍" : s
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
