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
    
    private var viewControllers = [FirstViewController(), SecondViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TabManViewController - viewDidLoad")
        view.addSubview(baseView)
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        
        
        
        self.dataSource = self

        // Create bar
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap // Customize
        bar.indicator.weight = .custom(value: 1)
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
        let title = "Page \(index)"
        return TMBarItem(title: title)
    }
}
