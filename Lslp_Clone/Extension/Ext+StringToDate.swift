//
//  Ext+StringToDate.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/22.
//

import Foundation

extension String {
    func toDate(text: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = text
        guard let date = dateFormatter.date(from: self) else {
            return Date()
        }
        
        return date
    }
}
