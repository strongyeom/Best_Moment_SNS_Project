//
//  TabManViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/08.
//

import UIKit
import Tabman
import Pageboy

class TabManViewController : TabmanViewController {
    
    let baseView = UIView()
    
    private var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TabManViewController - viewDidLoad")
        
        viewControllers.append(MyPostViewController())
        viewControllers.append(MyFavoritePostViewController())
        self.dataSource = self
        
        view.addSubview(baseView)
        baseView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }

        // bar 설정
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .clear
        bar.layout.transitionStyle = .snap
        // 간격 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        // 버튼 글씨 커스텀
        bar.buttons.customize { (button) in
            button.tintColor = .systemGray4
            button.selectedTintColor = .black
            button.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            button.selectedFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
        // 밑줄 쳐지는 부분
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = .black
        bar.indicator.overscrollBehavior = .none
        // Add to view
        addBar(bar, dataSource: self, at: .custom(view: baseView, layout: nil))

    }
}

extension TabManViewController: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        
        switch index {
        case 0:
            let title = "내 게시물"
            return TMBarItem(title: title)
        case 1:
            let title = "좋아요한 게시물"
            return TMBarItem(title: title)
        default:
            return TMBarItem(title: "")
        }
        
    }
}
