//
//  EditViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/13.
//

import UIKit

class EditViewController : BaseViewController {
    
    let editView = EditView()
    
    override func loadView() {
        self.view = editView
    }
    
    lazy var editButton = {
        let button = UIBarButtonItem(title: "편집완료", style: .plain, target: self, action: #selector(editBtnClicked))
        return button
    }()
                                     
    var data: ElementReadPostResponse?
    
    override func configure() {
        super.configure()
        print(data!)
        navigationBar()
        editView.configureUI(data: data)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTaaped))
        editView.postImage.addGestureRecognizer(tapGesture)
        
    }
    
    func navigationBar() {
        navigationItem.title = "편집"
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func imageTaaped() {
        print("tap 버튼 눌림 ")
    }
    
    @objc func editBtnClicked() {
        print("편집 완료 버튼 눌림")
    }
}
