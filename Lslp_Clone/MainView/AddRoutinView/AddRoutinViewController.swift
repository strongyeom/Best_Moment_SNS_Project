//
//  AddRoutinViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/22.
//

import UIKit
import RxSwift

class AddRoutinViewController : BaseViewController {
    
    let titleTextField = SignInTextField(placeHolder: "제목을 입력해주세요.", brandColor: .blue)
    let firstRoutinTextField = SignInTextField(placeHolder: "루틴을 추가해주세요", brandColor: .blue)
    let saveBtn = SignInButton(text: "저장하기", brandColor: .blue)
    
    lazy var cancelBtn = {
        let button = UIBarButtonItem(image: UIImage(systemName: "x.mark"), style: .plain, target: self, action: #selector(cancelBtnTapped))
        return button
    }()
    
    let viewModel = AddRoutinViewModel()
    let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
        bind()
        navigationItem.leftBarButtonItem = cancelBtn
    }
    
    @objc func cancelBtnTapped() {
        dismiss(animated: true)
    }
    
    // 제목 + 루틴 입력후 버튼 누르면 addpost 되게끔 설정
    func bind() {
        
        let input = AddRoutinViewModel.Input(title: titleTextField.rx.text.orEmpty, firstRoutrin: firstRoutinTextField.rx.text.orEmpty, saveBtn: saveBtn.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.saveBtnTapped
            .bind(with: self) { owner, response in
                dump(response)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
            
    }
    override func setConstraints() {
        [titleTextField, firstRoutinTextField, saveBtn].forEach {
            view.addSubview($0)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(60)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        firstRoutinTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(titleTextField)
            make.height.equalTo(50)
        }
        
        saveBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        
    }
}
