//
//  AddRoutinViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/22.
//

import UIKit
import RxSwift
import PhotosUI

class AddRoutinViewController : BaseViewController {
    
    let titleTextField = SignInTextField(placeHolder: "제목을 입력해주세요.", brandColor: .blue)
    let firstRoutinTextField = SignInTextField(placeHolder: "루틴을 추가해주세요", brandColor: .blue)
    let saveBtn = SignInButton(text: "저장하기", brandColor: .blue)
    
    lazy var imageBtn = {
        let view = UIImageView(image: UIImage(systemName: "flame"))
        view.isUserInteractionEnabled = true
        view.backgroundColor = .yellow
        return view
    }()
    
    lazy var cancelBtn = {
        let button = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(cancelBtnTapped))
        return button
    }()
    
    let viewModel = AddRoutinViewModel()
    let disposeBag = DisposeBag()
    var selectedImageData: Data?
    
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
        
        let input = AddRoutinViewModel.Input(title: titleTextField.rx.text.orEmpty, firstRoutrin: firstRoutinTextField.rx.text.orEmpty, saveBtn: saveBtn.rx.tap, imageData: selectedImageData)
        
        let output = viewModel.transform(input: input)
        
        output.saveBtnTapped
            .bind(with: self) { owner, response in
                dump(response)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc func imageBtnTaaped() {
        print("Image 클릭 됌 ---- ")
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photoLibray = UIAlertAction(title: "갤러리", style: .default) { [weak self] _ in
            guard let self else { return }
            var config = PHPickerConfiguration()
            config.selectionLimit = 1
            config.filter = .images
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            self.present(picker, animated: true)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(photoLibray)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
        
    }
    
    override func setConstraints() {
        [titleTextField, firstRoutinTextField, saveBtn, imageBtn].forEach {
            view.addSubview($0)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageBtnTaaped))
        imageBtn.addGestureRecognizer(tapGesture)
        
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
        
        imageBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
        
        saveBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
    }
}

extension AddRoutinViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) // 1
        
        let itemProvider = results.first?.itemProvider // 2
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in // 4
                DispatchQueue.main.async {
                    let image = image as? UIImage
                    
                    self.imageBtn.image = image
                    
                    let jpegData = image?.jpegData(compressionQuality: 1.0)
                    
                    if let data = jpegData {
                        // UImage  -> Data로 변환
                        print("data - \(data)")
                        self.selectedImageData = data
                    }
                    
                }
            }
        } else {
            // TODO: Handle empty results or item provider not being able load UIImage
        }
    }
}
