//
//  PostImageViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/01.
//

import UIKit

class PostImageViewController: BaseViewController {
    
    var array: [UIImage?] = [UIImage(systemName: "flame"), UIImage(systemName: "star"), UIImage(systemName: "book")]
    
    // images 배열을 받아서 CollectionviewCell에 뿌려줄것임
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout())
        return view
    }()
    
    override func configure() {
        super.configure()
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let spacing: CGFloat = 0
//        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: 300, height: 300)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        return layout
    }
    
    
}

extension PostImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostImageCell.identifier, for: indexPath) as? PostImageCell else {
            return UICollectionViewCell()
        }
        
        
        cell.postImage.image = array[indexPath.item]
        
        cell.pageControl.numberOfPages = array.count
        // 페이지 컨트롤의 현재 페이지를 0으로 설정
        cell.pageControl.currentPage = 0
        // 페이지 표시 색상을 밝은 회색 설정
        cell.pageControl.pageIndicatorTintColor = UIColor.lightGray
        // 현재 페이지 표시 색상을 검정색으로 설정
        cell.pageControl.currentPageIndicatorTintColor = UIColor.black
        cell.postImage.image = array.first!
        return cell
    }
}
