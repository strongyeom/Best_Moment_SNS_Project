//
//  LikeCollectionViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/06.
//

import UIKit
import RxSwift
import RxCocoa

class LikeCollectionViewController : BaseViewController {
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout())
        return view
    }()
    
    var routinArray: [ElementReadPostResponse] = []
    lazy var likesArray = BehaviorSubject(value: routinArray)
    let disposeBag = DisposeBag()
    
    // 다음 Cursor
    private var nextCursor = ""
    var selectedRow: Int = 0
    var likeID = PublishSubject<String>()
    let likeViewModel = ExampleViewModel()
    
    override func configure() {
        super.configure()
        view.addSubview(collectionView)
        collectionView.register(LikeCollectionViewCell.self, forCellWithReuseIdentifier: LikeCollectionViewCell.identifier)
        navigationItem.title = "내가 좋아요한 게시글"
        bind()
       
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("LikeCollectionViewController - viewWillAppear")
        requestGetLikes(next: "")
        routinArray = []
    }
    
    func bind() {
        
        let input = ExampleViewModel.Input(likeID: likeID)
        
        let output = likeViewModel.transform(input: input)
        
        likesArray
            .bind(to: collectionView.rx.items(cellIdentifier: LikeCollectionViewCell.identifier, cellType: LikeCollectionViewCell.self)) {
                row, element, cell in
                cell.configureUI(data: element)
//                dump(element)
           
                cell.likeBtn.rx.tap
                    .bind(with: self) { owner, _ in
                        print("좋아요 버튼 눌림")
                        // Cell에서 따로 지워져야하고
                        // 서버에서도 지워줘야함
//                        print("** row : \(row)")
                        owner.likeID.onNext(element._id)
                        if let number = owner.routinArray.firstIndex(where: { data in
                            data._id == element._id
                        }) {
                            owner.routinArray.remove(at: number)
                        }
                        
                        owner.likesArray.onNext(owner.routinArray)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        
        output.like
            .bind(with: self) { owner, response in
                print("** response : \(response.like_status)")
            }
            .disposed(by: disposeBag)
        
        
    }
    
    
    func layout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 10
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: (width - (spacing * 3)) / 2 , height: width * 0.7)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
        
    }

    override func setConstraints() {

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension LikeCollectionViewController : UICollectionViewDelegate {
    // 스크롤 하는 중일때 실시간으로 반영하는 방법은 없을까?
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let contentSize = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        // targetContentOffset.pointee.y: 사용자가 스크롤하면 실시간으로 값을 나타낼 수 있음 속도가 떨어지는 지점을 예측한다.
        let targetPointOfy = targetContentOffset.pointee.y
        
        let doneScrollOffSet = contentSize - scrollViewHeight
        if targetPointOfy + 70 >= doneScrollOffSet {
            print("네트워크 통신 시작")
            print("LikeVC - nextCursor - \(nextCursor)")
            if nextCursor != "0" {
                print("MainVC - 바닥 찍었음 append 네트워크 통신 시작")
                requestGetLikes(next: nextCursor)
            }
        }
    }
}

extension LikeCollectionViewController {
    func requestGetLikes(next: String) {
        APIManager.shared.requestReadPost(api: Router.getLikes(accessToken: UserDefaultsManager.shared.accessToken, next: next, limit: ""))
            .catch { err in
                if let err = err as? ReadPostError {
                    print("MainViewController - readPost \(err.errorDescrtion) , \(err.rawValue)")
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                owner.nextCursor = response.next_cursor
                print("LikeVC - response.next_cursor \(response.next_cursor)")
                print("LikeVC - nextCursor: \(owner.nextCursor)")
                DispatchQueue.main.async {
                    owner.routinArray.append(contentsOf: response.data)
                    owner.likesArray.onNext(owner.routinArray)
                }
                
               
            }
            .disposed(by: disposeBag)
    }
}

