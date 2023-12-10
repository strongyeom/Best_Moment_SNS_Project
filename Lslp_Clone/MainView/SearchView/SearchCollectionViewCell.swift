//
//  SearchCollectionViewCell.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/10.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    let thumbnail = {
       let view = UIImageView()
        return view
    }()
    
    let thumbnailDescription = {
        let view = UILabel()
        // custom font를 적용
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


