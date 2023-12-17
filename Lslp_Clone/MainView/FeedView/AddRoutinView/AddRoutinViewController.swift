//
//  AddRoutinViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/22.
//

import UIKit
import RxSwift
import PhotosUI

final class AddRoutinViewController : BaseViewController {
    
    let titleTextField = BaseTextField(placeHolder: "제목을 입력해주세요.", brandColor: .lightGray, alignment: .center)
    let dailyTextView = BasicTextView()
    
    let saveBtn = BaseButton(text: "저장하기", brandColor: .blue)
    let postImage = PostImage(nil, color: .lightGray)
    let viewModel = AddRoutinViewModel()
    let disposeBag = DisposeBag()
    var selectedImageData = PublishSubject<Data>()
    
    lazy var cancelBarBtn = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnClicked))
        return button
    }()
   
    override func configure() {
        super.configure()
        bind()
        title = "일상 추가"
        dailyTextView.delegate = self
        navigationItem.leftBarButtonItem = cancelBarBtn
    }
   
    // 제목 + 루틴 입력후 버튼 누르면 addpost 되게끔 설정
    func bind() {
        
        let input = AddRoutinViewModel.Input(title: titleTextField.rx.text.orEmpty, firstRoutin: dailyTextView.rx.text.orEmpty, saveBtn: saveBtn.rx.tap, imageData: selectedImageData)
        
        let output = viewModel.transform(input: input)
        
        
        output.saveBtnTapped
            .bind(with: self) { owner, response in
                owner.dismiss(animated: true)
                // 버튼 눌렀을때 첫번째 탭으로 이동
                owner.tabBarController?.selectedIndex = 0
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .bind(with: self) { owner, errMessage in
                owner.messageAlert(text: errMessage, completionHandler: nil)
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc func cancelBtnClicked() {
        self.dismiss(animated: true)
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
        [titleTextField, dailyTextView, saveBtn, postImage].forEach {
            view.addSubview($0)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageBtnTaaped))
        postImage.addGestureRecognizer(tapGesture)
        postImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(self.postImage.snp.width).multipliedBy(0.8)
        }
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(postImage.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
        
        dailyTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(titleTextField)
            make.height.equalTo(100)
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
                    
                    self.postImage.image = image
                    
                    let jpegData = image?.jpegData(compressionQuality: 0.3)
                    
                    if let data = jpegData {
                        // UImage  -> Data로 변환
                        print("data - \(data)")
                        self.selectedImageData.onNext(data)
                    }
                    
                }
            }
        } else {
            // TODO: Handle empty results or item provider not being able load UIImage
        }
    }
}


// MARK: - UITextViewDelegate
extension AddRoutinViewController : UITextViewDelegate {
    // 텍스트 칼라가 회색이면 -> nil, textColor -> black
    func textViewDidBeginEditing(_ textView: UITextView) {
        if dailyTextView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    // 텍스트가 비어있으면 placeHolder, 회색으로 설정
    func textViewDidEndEditing(_ textView: UITextView) {
        if dailyTextView.text.isEmpty {
            dailyTextView.text = "당신의 일상을 공유해주세요."
            dailyTextView.textColor = .lightGray
            
        }
    }
    
    // TextView 소문자만
    func textViewDidChange(_ textView: UITextView) {
        dailyTextView.text = textView.text.lowercased()
    }
}
