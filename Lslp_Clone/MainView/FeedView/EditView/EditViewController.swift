//
//  EditViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/13.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa

final class EditViewController : BaseViewController {
    
    lazy var editButton = {
        let button = UIBarButtonItem(title: "편집완료", style: .plain, target: self, action: nil)
        return button
    }()
    
    let editView = EditView()
  
    override func loadView() {
        self.view = editView
    }
    
 
                                     
    let vieewModel = EditViewModel()
    let selectedImageData = PublishSubject<Data>()
    var data: ElementReadPostResponse?
    var postID: String?
    let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
        navigationBar()
        editView.configureUI(data: data)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTaaped))
        editView.postImage.addGestureRecognizer(tapGesture)
        bind()
    }
    
    func bind() {
        let input = EditViewModel.Input(titleText: editView.postTitleTextField.rx.text.orEmpty, contentText: editView.contentTextView.rx.text.orEmpty, imageData: selectedImageData, editBtn: editButton.rx.tap, postID: postID ?? "")
        
        let output = vieewModel.transform(input: input)
        
        output.errorMessage
            .bind(with: self) { owner, errorText in
                owner.messageAlert(text: errorText, completionHandler: nil)
            }
            .disposed(by: disposeBag)
        
    
        output.editBtnClicked
            .bind(with: self) { owner, response in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func navigationBar() {
        navigationItem.title = "편집"
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func imageTaaped() {
        print("EditVC - tap 버튼 눌림 ")
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
}

extension EditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) // 1
        
        let itemProvider = results.first?.itemProvider // 2
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in // 4
                DispatchQueue.main.async {
                    let image = image as? UIImage
                    
                    self.editView.postImage.image = image
                    
                    let jpegData = image?.jpegData(compressionQuality: 0.3)
                    
                    if let data = jpegData {
                        // UImage  -> Data로 변환
                        print("data - \(data)")
                        self.selectedImageData.onNext(data)
                    }
                    
                }
            }
        } else {
            print("EditVC - PHPickerControllerDelegte: canLoadObject Error")
        }
    }
}
