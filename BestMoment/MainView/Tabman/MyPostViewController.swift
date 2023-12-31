//
//  FirstViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/08.
//

import UIKit
import RxSwift
import RxCocoa

class MyPostViewController : BaseViewController {
    
    private lazy var collectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collection.register(MyPostCell.self, forCellWithReuseIdentifier: MyPostCell.identifier)
        return collection
    }()
    
    
    private var nextCursor: String = ""
    private var myID: String = ""
    private var myArray: [ElementReadPostResponse] = []
    let errorMessage = PublishSubject<String>()
    private lazy var myPosts = BehaviorSubject(value: myArray)
    private let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
        print("MyPostViewController - configure")
        view.addSubview(collectionView)
       
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myArray = []
        getPost(next: "", limit: "20")
    }
    
   fileprivate func bind() {
        myPosts
            .bind(to: collectionView.rx.items(cellIdentifier: MyPostCell.identifier, cellType: MyPostCell.self)) {
                row, element, cell in
                cell.configureUI(data: element, isHidden: .post)
            }
            .disposed(by: disposeBag)
       
       errorMessage
           .bind(with: self) { owner, errMessage in
               owner.messageAlert(text: errMessage, completionHandler: nil)
           }
           .disposed(by: disposeBag)
        
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
           
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
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

extension MyPostViewController : UICollectionViewDelegate {
    // 스크롤 하는 중일때 실시간으로 반영하는 방법은 없을까?
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let contentSize = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        // targetContentOffset.pointee.y: 사용자가 스크롤하면 실시간으로 값을 나타낼 수 있음 속도가 떨어지는 지점을 예측한다.
        let targetPointOfy = targetContentOffset.pointee.y
        
        let doneScrollOffSet = contentSize - scrollViewHeight
        if targetPointOfy + 70 >= doneScrollOffSet {
            
            if nextCursor != "0" {
                print("MainVC - 바닥 찍었음 append 네트워크 통신 시작")
                getPost(next: nextCursor, limit: "")
                
            }
        }
    }
}

extension MyPostViewController {
    fileprivate func getPost(next: String, limit: String) {
        
        APIManager.shared.requestAPIFunction(type: GetProfileResponse.self, api: Router.getProfile(accessToken: UserDefaultsManager.shared.accessToken), section: .getProfile)
            .catch { err in
                if let err = err as? NetworkAPIError {
                    print("🙏🏻 프로필 조회 에러 - \(err.description)")
                    self.errorMessage.onNext("🙏🏻 프로필 조회 에러 - \(err.description)")
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                owner.myID = response._id
            }
            .disposed(by: disposeBag)
        
        
        
        
        APIManager.shared.requestAPIFunction(type: ReadPostResponse.self, api: Router.readPost(accessToken: UserDefaultsManager.shared.accessToken, next: next, limit: limit, product_id: "yeom"), section: .getPost)
            .catch { err in
                if let err = err as? NetworkAPIError {
                    print("🙏🏻 - 게시글 조회하기 에러 : \(err.description)")
                    self.errorMessage.onNext("🙏🏻 - 게시글 조회하기 에러 : \(err.description)")
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                owner.nextCursor = response.next_cursor
                let filter = response.data.filter { $0.creator._id == owner.myID}
                owner.myArray.append(contentsOf: filter)
                owner.myPosts.onNext(owner.myArray)
            }
            .disposed(by: disposeBag)
    }
}
