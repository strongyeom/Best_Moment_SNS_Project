//
//  Ext+UIViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/15.
//

import UIKit

extension UIViewController {
    func setEmailValidAlet(text: String, completionHandler: (() -> Void)?) {
        let alert = UIAlertController(title: "알림", message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler?()
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
}
