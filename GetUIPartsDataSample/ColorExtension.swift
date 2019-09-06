//
//  ColorExtension.swift
//  GetUIPartsDataSample
//
//  Created by misato.naruse on 2019/05/07.
//

import UIKit

enum SampleColor: String {
    // メイン
    case greenMainColor = "#219E62"
    // サブカラー
    case pinkSubColor = "#FF577C"
}

extension UIColor {
    static func hexColor(_ str: String) -> UIColor {
        if str.substring(to: str.index(str.startIndex, offsetBy: 1)) == "#" {
            let colStr = str.substring(from: str.index(str.startIndex, offsetBy: 1))
            if colStr.utf16.count == 6 {
                let rStr = (colStr as NSString).substring(with: NSRange(location: 0, length: 2))
                let gStr = (colStr as NSString).substring(with: NSRange(location: 2, length: 2))
                let bStr = (colStr as NSString).substring(with: NSRange(location: 4, length: 2))
                let rHex = CGFloat(Int(rStr, radix: 16) ?? 0)
                let gHex = CGFloat(Int(gStr, radix: 16) ?? 0)
                let bHex = CGFloat(Int(bStr, radix: 16) ?? 0)
                return UIColor(red: rHex / 255.0, green: gHex / 255.0, blue: bHex / 255.0, alpha: 1.0)
            }
        }
        return UIColor.white
    }

    func hex() -> String {
        if let components = self.cgColor.components {
            let r = ("0" + String(Int(components[0] * 255.0), radix: 16, uppercase: true)).suffix(2)
            let g = ("0" + String(Int(components[1] * 255.0), radix: 16, uppercase: true)).suffix(2)
            let b = ("0" + String(Int(components[2] * 255.0), radix: 16, uppercase: true)).suffix(2)
            return "#\(String(r + g + b))"
        }
        return "000000"
    }

    @objc static func greenMainColor() -> UIColor {
        return self.hexColor(ColorCode.greenMainColor)
    }

    @objc static func pinkSubColor() -> UIColor {
        return self.hexColor(ColorCode.pinkSubColor)
    }

    // カラーコード
    class ColorCode {
        // メイン
        static let greenMainColor: String = "#219E62"
        // サブ
        static let pinkSubColor: String = "#FF577C"
    }
}
