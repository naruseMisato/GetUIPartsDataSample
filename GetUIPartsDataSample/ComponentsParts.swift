//
//  ComponentsParts.swift
//  GetUIPartsDataSample
//
//  Created by misato.naruse on 2019/05/07.
//

import Foundation
import UIKit

@IBDesignable class SampleLabelStyle: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.font = UIFont.sample()
    }

    // カラーの変更
    @IBInspectable var color: UIColor? {
        didSet {
            self.textColor = self.color
        }
    }
}

import Foundation
import UIKit

@objcMembers
@IBDesignable class SampleButton: UIButton {
    // 固定値の代入
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.layer.cornerRadius = 2.0
        self.layer.borderWidth = 1.0
        self.titleLabel?.font = UIFont.sample()
    }

    // 背景塗りつぶしパターン
    func primaryFill(title: String = "") {
        if !title.isEmpty {
            self.setTitle(title, for: .normal)
        }
        self.layer.borderColor = UIColor.greenMainColor().cgColor
        self.backgroundColor = UIColor.greenMainColor()
        self.setTitleColor(UIColor.white, for: .normal)
    }
}

extension UIFont {
    private static func apply(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        return self.systemFont(ofSize: size, weight: weight)
    }

    static func sample() -> UIFont {
        return self.apply(size: 19, weight: .bold)
    }
}
