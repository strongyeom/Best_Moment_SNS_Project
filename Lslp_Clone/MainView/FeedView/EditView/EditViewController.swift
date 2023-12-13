//
//  EditViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/13.
//

import UIKit
import PhotosUI
import RxSwift

class EditViewController : BaseViewController {
    
    let editView = EditView()
    
    override func loadView() {
        self.view = editView
    }
    
    lazy var editButton = {
        let button = UIBarButtonItem(title: "편집완료", style: .plain, target: self, action: #selector(editBtnClicked))
        return button
    }()
                                     
    let selectedImageData = PublishSubject<Data>()
    var data: ElementReadPostResponse?
    let disposeBag = DisposeBag()
    
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
    
    @objc func editBtnClicked() {
        print("편집 완료 버튼 눌림")
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
            // TODO: Handle empty results or item provider not being able load UIImage
        }
    }
}
