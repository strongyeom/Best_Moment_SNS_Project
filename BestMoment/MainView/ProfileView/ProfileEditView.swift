import UIKit
import RxSwift
import RxCocoa
import PhotosUI
import Kingfisher

class ProfileEditView : BaseViewController {
    
    private lazy var profileImage = PostImage("person.circle.fill", color: .lightGray)
    private let nicknameTitle = BaseLabel(text: "닉네임 수정", fontSize: 22, weight: .medium)
    private let imageModifyText = BaseLabel(text: "사진을 수정 할 수 있어요.", fontSize: 11, weight: .medium)
    private let nicknameTextField = BaseTextField(placeHolder: "닉네임을 설정해주세요.", brandColor: UIColor(named: "brandColor") ?? .systemBlue, alignment: .left)
    private let saveButton = BaseButton(text: "저장하기", brandColor: UIColor(named: "brandColor") ?? .systemBlue)
    private lazy var cancelBtn = {
        let view = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(cancelBtnClicked))
        return view
    }()
    var nickname: String?
    private let tapGesture = UITapGestureRecognizer()
    private let profileViewModel = ProfileViewModel()
    private var selectedImageData = PublishSubject<Data>()
    let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
        
        
        [profileImage, nicknameTitle, imageModifyText, nicknameTextField, saveButton].forEach {
            view.addSubview($0)
        }
        
        self.profileImage.addGestureRecognizer(tapGesture)
        nicknameTextField.text = nickname
        bind()
        navigationSetting()
        addKeyboardNotifications()
    }
    
    func navigationSetting() {
        navigationItem.title = "프로필 편집"
        navigationItem.leftBarButtonItem = cancelBtn
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotificiations()
    }
    
    
    
    fileprivate func bind() {
        
        let input = ProfileViewModel.Input(imageData: selectedImageData, saveBtn: saveButton.rx.tap, imageTap: tapGesture.rx.event, nickText: nicknameTextField.rx.text.orEmpty)
        
        let output = profileViewModel.transform(input: input)
        
        output.saveProfile
            .bind(with: self) { owner, response in
                dump(response)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .bind(with: self) { owner, errMessage in
                owner.messageAlert(text: errMessage, completionHandler: nil)
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
    override func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(60)
        }
        
        imageModifyText.snp.makeConstraints { make in
            make.centerX.equalTo(profileImage)
            make.top.equalTo(profileImage.snp.bottom).offset(3)
        }
        
        nicknameTitle.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nicknameTitle.snp.makeConstraints { make in
            make.top.equalTo(imageModifyText.snp.bottom).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        
        nicknameTextField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        nicknameTextField.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameTitle)
            make.leading.equalTo(nicknameTitle.snp.trailing).offset(15)
            make.height.equalTo(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        
        saveButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(nicknameTitle.snp.bottom).offset(40)
            make.height.equalTo(50)
        }
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

                    if let data = jpegData {
                        // UImage  -> Data로 변환
                        print("***data - \(data.description)")
                        self.selectedImageData.onNext(data)
                    }
                    
                }
            }
        } else {
            // TODO: Handle empty results or item provider not being able load UIImage
        }
    }
}
