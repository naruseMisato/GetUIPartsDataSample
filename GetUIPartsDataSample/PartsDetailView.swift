//
//  PartsDetailView.swift
//  Jmty
//
//  Created by misato.naruse on 2019/05/01.
//

import UIKit

//閉じるデリゲートメソッド
protocol PartsDetailViewDelegate: NSObjectProtocol {
    func closePartsDetailView()
}

/// パーツの詳細表示用View
class PartsDetailView: UIView {
    @IBOutlet weak var partsDetailTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!

    weak var delegate: PartsDetailViewDelegate?

    override func awakeFromNib() {
        self.deleteButton.addTarget(self,
                                    action: #selector(self.onTapPostButton),
                                    for: .touchUpInside)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touches = touches.first else {
            return
        }
        let location = touches.location(in: self)
        let prevLocation = touches.previousLocation(in: self)

        self.frame.origin.x += location.x - prevLocation.x
        self.frame.origin.y += location.y - prevLocation.y
    }

    // MARK: PrivateMethod

    @objc private func onTapPostButton() {
        self.delegate?.closePartsDetailView()
    }
}
