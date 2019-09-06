//
//  ViewControllerExtension.swift
//  GetUIPartsDataSample
//
//  Created by misato.naruse on 2019/05/07.
//

import UIKit

extension ViewController {
    func getVC() {
        self.getParts()
    }

    // データ表示用のViewを表示しているかどうか
    func setIsShowingPartDetailView() {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            var topViewControlelr: UIViewController = rootViewController

            while let presentedViewController = topViewControlelr.presentedViewController {
                topViewControlelr = presentedViewController
            }
            self.isShowingPartDetailView = topViewControlelr.view.subviews.last! is TapGestureView
        }
    }

    // MARK: PrivateMethod

    // パーツを取得する
    private func getParts() {
        print("🔸===ViewController: \(self)")

        // 長押ししたパーツを検出する
        for parts in self.view.recursiveSubviews.reversed() {
            parts.longPress { gesture in
                switch gesture.state {
                case .began:
                    // マイページのバージョン部分を押したとき
                    if parts.tag == 99 {
                        let yesHandler: ((UIAlertAction) -> Void)? = { _ in
                            self.isShowingPartDetailView ? self.deleteObjectView() : self.setObjectView()
                            self.isShowingPartDetailView.toggle()
                        }
                        let message: String = self.isShowingPartDetailView ? "パーツ情報を非表示にしますか？" : "パーツ情報を表示しますか？"
                        let alertController: UIAlertController = self.simpleAlert(title: "パーツ情報",
                                                                                  message: message,
                                                                                  yesHandler: yesHandler,
                                                                                  noHandler: nil)
                        self.present(alertController, animated: true, completion: nil)
                        return
                    } else {
                        if self.isShowingPartDetailView {
                            self.setDataInObjectViewIn(data: self.superView(parts: parts))
                        }
                    }
                default:
                    break
                }
            }

            self.printData(parts: parts)
        }
    }

    private func simpleAlert(title: String?,
                             message: String?,
                             yesHandler: ((UIAlertAction) -> Void)?,
                             noHandler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert: UIAlertController = UIAlertController(title: title,
                                                         message: message,
                                                         preferredStyle: UIAlertController.Style.alert)

        let yesAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: yesHandler)
        let noAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: noHandler)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        return alert
    }

    // 必要であれば親Viewをまたいで情報を取得する
    private func superView(parts: UIView) -> String {
        // tableViewCellをタップしたらその中のデータを取得する
        guard let superView = parts.superview else {
            return ""
        }
        if parts.description.contains("UIView"),
            superView.description.contains("Table") {
            var partsDataText = ""
            for parts in superView.recursiveSubviews {
                partsDataText += self.consoleData(parts: parts)
            }
            return partsDataText
        }
        return self.consoleData(parts: parts)
    }

    private func printData(parts: UIView) {
        switch parts {
        case is UILabel:
            let label = parts as! UILabel
            print("===UILabelLabel: \(label.getData())")
        case is UIButton:
            let button = parts as! UIButton
            print("===UIButtonLabel: \(button.getData())")
        default:
            break
        }
    }

    private func consoleData(parts: UIView) -> String {
        switch parts {
        case is UILabel:
            let label = parts as! UILabel
            return "[\(label.getData())\(label.getConstraints())]"
        case is UIButton:
            let button = parts as! UIButton
            return "[\(button.getData())\(button.getConstraints())]"
        default:
            break
        }
        return ""
    }

    // データ表示用のViewにデータをセットする
    private func setDataInObjectViewIn(data: String) {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            var topViewControlelr: UIViewController = rootViewController

            while let presentedViewController = topViewControlelr.presentedViewController {
                topViewControlelr = presentedViewController
            }
            let tapGestureView = topViewControlelr.view.subviews.last! as! TapGestureView
            (tapGestureView.subviews.last! as! PartsDetailView).partsDetailTextView.text = data
        }
    }

    // データ表示用のViewをセットする
    private func setObjectView() {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            var topViewControlelr: UIViewController = rootViewController

            while let presentedViewController = topViewControlelr.presentedViewController {
                topViewControlelr = presentedViewController
            }
            guard let objectView: PartsDetailView = UINib(nibName: "PartsDetailView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? PartsDetailView else {
                return
            }
            objectView.delegate = self
            let tapGestureView = TapGestureView(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: 200))
            topViewControlelr.view.addSubview(tapGestureView)

            objectView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 200)
            tapGestureView.addSubview(objectView)
        }
    }

    // データ表示用のViewを消す
    private func deleteObjectView() {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            var topViewControlelr: UIViewController = rootViewController

            while let presentedViewController = topViewControlelr.presentedViewController {
                topViewControlelr = presentedViewController
            }
            topViewControlelr.view.subviews.last!.removeFromSuperview()
        }
    }
}

/// データ表示用のViewを画面上を動かすためのベースView
class TapGestureView: UIView {
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touches = touches.first else {
            return
        }
        let location = touches.location(in: self)
        let prevLocation = touches.previousLocation(in: self)

        self.frame.origin.x += location.x - prevLocation.x
        self.frame.origin.y += location.y - prevLocation.y
    }
}

extension ViewController: PartsDetailViewDelegate {
    func closePartsDetailView() {
        self.deleteObjectView()
        self.isShowingPartDetailView = false
    }
}

/// データを意図した文字列で返すextension群
extension UILabel {
    func getData() -> String {
        let color: Any = {
            if self.textColor.cgColor.components?.count ?? 0 > 3 {
                return SampleColor(rawValue: self.textColor.hex()) ?? self.textColor.hex()
            }
            return "clear"
        }()
        return "\(self.classForCoder),\(self.text ?? ""),高さ：\(self.frame.height),幅：\(self.frame.height),\(color)"
    }

    func getConstraints() -> [NSLayoutConstraint] {
        return self.constraints
    }
}

extension UIButton {
    func getData() -> String {
        let color: Any = {
            if self.backgroundColor?.cgColor.components?.count ?? 0 > 3 {
                return SampleColor(rawValue: self.backgroundColor!.hex()) ?? self.backgroundColor!.hex()
            }
            return "clear"
        }()
        return "[\(self.classForCoder),\(self.titleLabel?.text ?? ""),高さ：\(self.frame.height),幅：\(self.frame.height),\(color)]"
    }

    func getConstraints() -> [NSLayoutConstraint] {
        return self.constraints
    }
}
