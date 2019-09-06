//
//  UIViewExtension.swift
//  GetUIPartsDataSample
//
//  Created by misato.naruse on 2019/09/07.
//

import UIKit

class GestureClosureSleeve<T: UIGestureRecognizer> {
    let closure: (_ gesture: T) -> Void

    init(_ closure: @escaping (_ gesture: T) -> Void) {
        self.closure = closure
    }

    @objc func invoke(_ gesture: Any) {
        guard let gesture = gesture as? T else { return }
        closure(gesture)
    }
}

extension UIView {
    // 画面上のViewを全て取得する
    var recursiveSubviews: [UIView] {
        return self.subviews + self.subviews.flatMap { $0.self.recursiveSubviews }
    }

    // 長押しタップを検出する
    func longPress(_ closure: @escaping (_ gesture: UILongPressGestureRecognizer) -> Void) {
        let sleeve = GestureClosureSleeve<UILongPressGestureRecognizer>(closure)
        let recognizer = UILongPressGestureRecognizer(target: sleeve, action: #selector(GestureClosureSleeve.invoke(_:)))
        recognizer.minimumPressDuration = 0.5
        self.addGestureRecognizer(recognizer)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
