//
//  ViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/13.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SignupViewController: BaseViewController {
    
    let nicknameTextField = BaseTextField(placeHolder: "닉네임을 설정해주세요.", brandColor: .systemGreen, alignment: .center)
    let emailTextField = BaseTextField(placeHolder: "이메일을 입력해주세요.", brandColor: .systemGreen, alignment: .center)
    let passwordTextField = BaseTextField(placeHolder: "비밀번호를 입력해주세요", isSecure: true, brandColor: .systemGreen)
    let duplicateBtn = {
       let button = UIButton()
        button.setCornerButton(text: "중복확인", brandColor: .lightGray)
        return button
    }()
    
    let signupBtn = {
       let button = UIButton()
        button.setCornerButton(text: "회원 가입 완료", brandColor: UIColor(named: "brandColor") ?? .systemGreen)
        return button
    }()
    
    let viewModel = SignupViewModel()
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        super.configure()
        print("SigupViewController - configure")
        title = "회원가입"
        navigationController?.navigationBar.tintColor = .black
        bind()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func bind() {
        
        let input = SignupViewModel.Input(emailText: emailTextField.rx.text.orEmpty, nickText: nicknameTextField.rx.text.orEmpty,passwordText: passwordTextField.rx.text.orEmpty,duplicateTapped: duplicateBtn.rx.tap, signupBtnTapped: signupBtn.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        
        /// 에러 문구 Alert
        output.errorMessage
            .bind(with: self) { owner, err in
                owner.messageAlert(text: err, completionHandler: nil)
            }
            .disposed(by: disposeBag)
        
        /// 이메일 검증 여부
        output.isEmailValid
            .bind(with: self, onNext: { owner, result in
                owner.signupBtn.isEnabled = result
                let color = result ? UIColor(named: "brandColor") : UIColor.lightGray
                owner.signupBtn.backgroundColor = color
            })
            .disposed(by: disposeBag)

        /// 이메일 중복 체크
        output.dulicateTapped
            .bind(with: self, onNext: { owner, response in
                owner.messageAlert(text: response.message, completionHandler: nil)
                output.isEmailValid.onNext(true)
            })
            .disposed(by: disposeBag)

        /// 회원 가입
        output.signupBtnTapped
            .bind(with: self, onNext: { owner, response in
                print(response)
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

    }
    
   
    
    override func setConstraints() {
        [nicknameTextField, emailTextField, passwordTextField, duplicateBtn, signupBtn].forEach {
            view.addSubview($0)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        duplicateBtn.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextField)
            make.width.equalTo(100)
            make.leading.equalTo(emailTextField.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signupBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        
    }
    
}
