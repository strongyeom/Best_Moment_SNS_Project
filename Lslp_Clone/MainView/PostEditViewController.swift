//
//  PostEditViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/01.
//

import UIKit
import Kingfisher
import PhotosUI

class PostEditViewController : BaseViewController {
    
    var editPost: ElementReadPostResponse?
    
    let emailTextField = SignInTextField(placeHolder: "이메일을 입력해주세요.", brandColor: .blue)
    let saveBtn = SignInButton(text: "저장", brandColor: .blue)
    
    lazy var postImage = {
        let view = UIImageView()
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTaaped))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        return view
    }()
    
    override func configure() {
        super.configure()
        print("PostEditViewController - configure")
        dump(editPost)
        view.addSubview(emailTextField)
        view.addSubview(postImage)
        guard let editPost else { return }
        
        emailTextField.text = editPost.content
        cofigurePostImage(data: editPost.image.first ?? "")
    }
    
    @objc func imageTaaped() {
        print("PostEditViewController - imageTapped")
        
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveBtnClicked))
        
        postImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(postImage.snp.width)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(postImage.snp.bottom).offset(15)
            make.height.equalTo(50)
        }
        
    }
    
    
    
    func cofigurePostImage(data: String) {
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(APIKey.secretKey, forHTTPHeaderField: "SesacKey")
            requestBody.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: "Authorization")
            return requestBody
        }
        
        let url = URL(string: BaseAPI.baseUrl + data)
        self.postImage.kf.setImage(with: url, options: [ .requestModifier(imageDownloadRequest), .cacheOriginalImage])
    }
    
    @objc func saveBtnClicked() {
        print("저장 눌림")
        dismiss(animated: true) {
            print("dismiss 뒤면서 어떤 동작을 할 것인가 ")
        }
    }
}

extension PostEditViewController: PHPickerViewControllerDelegate {
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
                        
                        
                        // TODO: - VM으로 보내서 mutipartForm형식으로 put 하기
//                        self.selectedImageData.onNext(data)
                    }
                    
                }
            }
        } else {
        }
    }
}
