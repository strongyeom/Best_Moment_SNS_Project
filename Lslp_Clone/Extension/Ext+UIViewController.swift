//
//  Ext+UIViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/15.
//

import UIKit

extension UIViewController {
    func messageAlert(text: String, completionHandler: (() -> Void)?) {
        let alert = UIAlertController(title: "알림", message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler?()
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func logOutAlert(completionHandler: (() -> Void)?) {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        let logout = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            completionHandler?()
        }
        alert.addAction(ok)
        alert.addAction(logout)
        present(alert, animated: true)
    }
    
}
