//
//  SecondViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/08.
//

import UIKit
import RxSwift
import RxCocoa

final class MyFavoritePostViewController : BaseViewController {
    
    private lazy var collectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collection.register(MyPostCell.self, forCellWithReuseIdentifier: MyPostCell.identifier)
        return collection
    }()
    
    private var nextCursor: String = ""
    private var myArray: [ElementReadPostResponse] = []
    private lazy var myFavoritesPosts = BehaviorSubject(value: myArray)
    private let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
        view.addSubview(collectionView)
       
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myArray = []
        requestGetLikes(next: "")
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    fileprivate func bind() {
        
        myFavoritesPosts
            .bind(to: collectionView.rx.items(cellIdentifier: MyPostCell.identifier, cellType: MyPostCell.self)) {
                row, element, cell in
//                print("myArray - \(element.creator.nick)")
                cell.configureUI(data: element, isHidden: .favorite)
            }
            .disposed(by: disposeBag)
    }
    
    fileprivate func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 10
        let width = (UIScreen.main.bounds.width - (spacing * 5))
        layout.itemSize = CGSize(width: width / 3 , height: width / 3)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
    }
}

extension MyFavoritePostViewController {
    fileprivate func requestGetLikes(next: String) {
    
        APIManager.shared.requestAPIFunction(type: ReadPostResponse.self, api: Router.getLikes(accessToken: UserDefaultsManager.shared.accessToken, next: next, limit: "20"), section: .getLikes)
            .catch { err in
                if let err = err as? NetworkAPIError {
                    print("🙏🏻 내가 좋아요한 포스팅 조회 에러 - \(err.description)")
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                owner.nextCursor = response.next_cursor
                owner.myArray = response.data
//                print("myArray Count\(self.myArray.count)")
//                print("myArray \(self.myArray)")
                print("myArray - Count : \(self.myArray.count)")
                print("myArray - nickname: \(self.myArray.map { $0.creator.nick})")
                owner.myFavoritesPosts.onNext(owner.myArray)
            }
            .disposed(by: disposeBag)
            
    }
}
