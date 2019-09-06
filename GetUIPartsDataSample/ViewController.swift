//
//  ViewController.swift
//  GetUIPartsDataSample
//
//  Created by misato.naruse on 2019/05/07.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var startButton: UILabel!
    @IBOutlet weak var buttonParts: SampleButton!
    var isShowingPartDetailView = false

    // MARK: LifeSycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getVC()
        self.buttonParts.primaryFill()
    }
}

