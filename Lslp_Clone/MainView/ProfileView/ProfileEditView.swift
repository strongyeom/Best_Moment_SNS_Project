import UIKit
import RxSwift
import RxCocoa
import PhotosUI
import Kingfisher

class ProfileEditView : BaseViewController {
    
    lazy var profileImage = PostImage("person.fill", color: .blue)
    let saveButton = SignInButton(text: "저장하기", brandColor: .blue)
    lazy var cancelBtn = {
        let view = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnClicked))
        return view
    }()
    
    let tapGesture = UITapGestureRecognizer()
    let profileViewModel = ProfileViewModel()
    var selectedImageData = PublishSubject<Data>()
    let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
        navigationItem.leftBarButtonItem = cancelBtn
        view.addSubview(profileImage)
        view.addSubview(saveButton)
        self.profileImage.addGestureRecognizer(tapGesture)
        
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.center.equalToSuperview()
        }
        
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
        
        bind()
    }
    
    
    
    func bind() {
        
        let input = ProfileViewModel.Input(imageData: selectedImageData, saveBtn: saveButton.rx.tap, imageTap: tapGesture.rx.event)
        
        let output = profileViewModel.transform(input: input)
        
        output.putImageClicked
            .bind(with: self) { owner, response in
                dump(response)
                let imageDownloadRequest = AnyModifier { request in
                    var requestBody = request
                    requestBody.setValue(APIKey.secretKey, forHTTPHeaderField: "SesacKey")
                    requestBody.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: "Authorization")
                    return requestBody
                }
                
//                let url = URL(string: BaseAPI.baseUrl + )
//                
//                self.profileImage.kf.setImage(with: url, options: [ .requestModifier(imageDownloadRequest), .cacheOriginalImage])
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        
        tapGesture.rx.event
            .bind(with: self) { owner, tap in
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
                owner.present(actionSheet, animated: true)
            }
            .disposed(by: disposeBag)
       
    }
    
    @objc func cancelBtnClicked() {
        dismiss(animated: true)
    }
}

extension ProfileEditView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider // 2
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in // 4
                DispatchQueue.main.async {
                    let image = image as? UIImage
                    
                    self.profileImage.image = image
                    
                    let jpegData = image?.jpegData(compressionQuality: 0.5)
//                    let pngData = image?.pngData()
                    
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
