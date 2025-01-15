import UIKit

extension UIColor {
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        let length = hexSanitized.count
        guard length == 6 || length == 8 else { return nil }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red, green, blue, alpha: CGFloat
        
        if length == 6 {
            red   = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8)  / 255.0
            blue  = CGFloat(rgb & 0x0000FF)        / 255.0
            alpha = 1.0
        } else {
            red   = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            blue  = CGFloat((rgb & 0x0000FF00) >> 8)  / 255.0
            alpha = CGFloat(rgb & 0x000000FF)        / 255.0
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func toHexString(includeAlpha: Bool = false) -> String {
        guard let components = cgColor.components, components.count >= 3 else {
            return "#000000"
        }
        
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        let alpha = Float(components.count >= 4 ? components[3] : 1.0)
        
        if includeAlpha {
            return String(format: "#%02lX%02lX%02lX%02lX",
                          lroundf(red * 255),
                          lroundf(green * 255),
                          lroundf(blue * 255),
                          lroundf(alpha * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX",
                          lroundf(red * 255),
                          lroundf(green * 255),
                          lroundf(blue * 255))
        }
    }
}
