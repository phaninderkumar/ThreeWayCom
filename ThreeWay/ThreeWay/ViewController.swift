//
//  ViewController.swift
//  ThreeWay
//
//  Created by Phaninder Kumar on 06/10/21.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var label: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView(_:)), name: NSNotification.Name("TimeUpdated"), object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func refreshView(_ notification: Notification) {
        guard let info = notification.userInfo as? [String: String],
              let response = info["response"] else { return }
        DispatchQueue.main.async {
            self.label.stringValue = response
        }
    }
    

}

