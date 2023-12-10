//
//  SearchViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/10.
//

import UIKit
import RxSwift

class SearchViewController : BaseViewController {
    
    lazy var collectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collection.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        return collection
    }()
    
    var allOfPost: [ElementReadPostResponse] = []
    lazy var posts = BehaviorSubject(value: allOfPost)
//    let viewModel = SearchViewModel()
    var nextCursor = ""
    let disposeBag = DisposeBag()
    
    
    override func configure() {
        super.configure()
        setupSearchController()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        readPost(next: "", limit: "20")
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        readPost(next: "", limit: "30")
    }
    
    
    func bind() {

        
        posts
            .bind(to: collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.identifier, cellType: SearchCollectionViewCell.self)) { row, element, cell in
                
                cell.configureUI(data: element)
                
            }
            .disposed(by: disposeBag)
        
        
        // TODO: - zip을 사용하고 Cell을 클릭하면 Error 발생 -  rxFatalErrorInDebug

//        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(SearchCollectionViewCell.self))
//            .bind(with: self) { owner, response in
//                print("response row : \(response.0)")
//                print("response element : \(response.1)")
//            }
//            .disposed(by: disposeBag)
//
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    
    
}

extension SearchViewController: UICollectionViewDelegate {
    
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
                readPost(next: nextCursor, limit: "")
            }
        }
    }
}

// 이메일 중복검사 했듯이 닉네임도 중복검사를 통해 고유하게 만든 다음에
// Filter를 통해 찾고 해당 Id를 활용하여 검새하면 어떨까?

extension SearchViewController {
    
    func setupSearchController() {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 5
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: (width - (spacing * 4)) / 3 , height: (width - (spacing * 4)) / 3)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
    }
    
    func readPost(next: String, limit: String) {
        APIManager.shared.requestReadPost(api: Router.readPost(accessToken: UserDefaultsManager.shared.accessToken, next: next, limit: limit, product_id: "yeom"))
            .catch { err in
                if let err = err as? ReadPostError {
                    print("MainViewController - readPost \(err.errorDescrtion) , \(err.rawValue)")
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                owner.nextCursor = response.next_cursor
                owner.allOfPost.append(contentsOf: response.data)
                owner.posts.onNext(owner.allOfPost)
            }
            .disposed(by: disposeBag)
    }
}

extension SearchViewController : UISearchControllerDelegate {
    
}
