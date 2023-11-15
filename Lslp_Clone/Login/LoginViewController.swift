//
//  LoginViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class LoginViewController : BaseViewController {
    
    let emailTextField = SignInTextField(placeHolder: "이메일을 입력해주세요.")
    let passwordTextField = SignInTextField(placeHolder: "비밀번호를 입력해줏요", isSecure: true)
    let signInBtn = SignInButton(text: "로그인")
    let signupBtn = {
       let button = UIButton()
        button.setTitle("회원이 아니십니까?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
        bind()
    }
    
    func bind() {
        // 회원 가입 View로 전환
        signupBtn.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(SignupViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func setConstraints() {
        [emailTextField, passwordTextField, signInBtn, signupBtn].forEach {
            view.addSubview($0)
        }
        
        
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signupBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInBtn.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    
    
}
