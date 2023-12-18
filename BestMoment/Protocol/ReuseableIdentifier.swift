//
//  ReuseableIdentifier.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/10.
//

import UIKit

protocol ReuseableIdentifier {
    static var identifier: String { get }
}

extension UITableViewCell : ReuseableIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReuseableIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}
