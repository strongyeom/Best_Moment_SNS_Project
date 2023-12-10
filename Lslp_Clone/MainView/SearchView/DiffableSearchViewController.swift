//
//  SearchViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/10.
//

import UIKit
import RxSwift

class DiffableSearchViewController : BaseViewController {
    
    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, ElementReadPostResponse>! = nil
    var collectionView: UICollectionView! = nil
    let disposeBag = DisposeBag()
   lazy var routinArray: [ElementReadPostResponse] = []
    
    override func configure() {
        super.configure()
        setupSearchController()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readPost(next: "", limit: "")
    }
    
    func setupSearchController() {

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}

extension DiffableSearchViewController {
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
//        collectionView.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide)
//        }
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<LikeCollectionViewCell, ElementReadPostResponse> { (cell, indexPath, identifier) in
            cell.configureUI(data: identifier)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ElementReadPostResponse>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: ElementReadPostResponse) -> UICollectionViewCell? in
            // Return the cell.
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, ElementReadPostResponse>()
        snapshot.appendSections([.main])
        print("routinArray - \(routinArray.count)")
        snapshot.appendItems(routinArray, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension DiffableSearchViewController {
    func readPost(next: String, limit: String) {
      
        APIManager.shared.requestReadPost(api: Router.readPost(accessToken: UserDefaultsManager.shared.accessToken, next: next, limit: limit, product_id: "yeom"))
            .catch { err in
                if let err = err as? ReadPostError {
                    print("MainViewController - readPost \(err.errorDescrtion) , \(err.rawValue)")
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                // 네트워크 통신 시작하면 5개 넘어가게 있으면 next_cursor 확인
                // next_cursor 값이 "0"나면 더이상 없는것임
                print("MainVC GET- next_cursor: \(response.next_cursor)")
                owner.routinArray.append(contentsOf: response.data)
                dump(owner.routinArray)
            }
            .disposed(by: disposeBag)

    }
}
