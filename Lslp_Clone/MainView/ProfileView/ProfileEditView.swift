import UIKit
import RxSwift
import RxCocoa

class ProfileEditView : BaseViewController {
    
    lazy var cancelBtn = {
        let view = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnClicked))
        return view
    }()
    
    
    override func configure() {
        super.configure()
        navigationItem.leftBarButtonItem = cancelBtn
    }
    
    @objc func cancelBtnClicked() {
        dismiss(animated: true)
    }
    
    
    
    
}
