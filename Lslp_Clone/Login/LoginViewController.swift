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
    
    let emailTextField = SignInTextField(placeHolder: "이메일을 입력해주세요.", brandColor: .blue, alignment: .center)
    let passwordTextField = SignInTextField(placeHolder: "비밀번호를 입력해줏요", isSecure: true, brandColor: .blue)
    let signInBtn = SignInButton(text: "로그인", brandColor: .blue)
    let signupBtn = {
       let button = UIButton()
        button.setTitle("회원이 아니십니까?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
       
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 로그인 뷰 떳을때 빈값으로 설정
    }
    
    
    
    func bind() {
        
        let input = LoginViewModel.Input(emailText: emailTextField.rx.text.orEmpty, passwordText: passwordTextField.rx.text.orEmpty, loginBtn: signInBtn.rx.tap, signupBtn: signupBtn.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        
        // 에러 문구 Alert
        output.errorMessage
            .bind(with: self) { owner, error in
                owner.messageAlert(text: error, completionHandler: nil)
            }
            .disposed(by: disposeBag)
           
        
        // 로그인 확인
        output.loginBtnTapped
            .bind(with: self) { owner, response in
                //print(response)
                // 1. UD에 AT, RT 저장하기
                UserDefaultsManager.shared.saveUserID(response._id)
                UserDefaultsManager.shared.saveAccessToken(accessToken: response.token)
                UserDefaultsManager.shared.saveRefreshToken(refreshToken: response.refreshToken)
                // 2. Home 화면으로 이동
                owner.navigationController?.pushViewController(TabViewController(), animated: false)
                
                let mainView = TabViewController()
                mainView.modalPresentationStyle = .fullScreen
                owner.present(mainView, animated: false)
                
            }
            .disposed(by: disposeBag)
        
        
        // 회원 가입 View로 전환
        output.signupTapped
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
