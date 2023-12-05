////
////  AddDailyRoutinView.swift
////  Lslp_Clone
////
////  Created by 염성필 on 2023/12/05.
////
//
//import UIKit
//import SnapKit
//
//class AddDailyRoutinView: BaseView {
//    
//    let titleTextField = SignInTextField(placeHolder: "제목을 입력해주세요.", brandColor: .blue, alignment: .center)
//    let firstRoutinTextField = SignInTextField(placeHolder: "루틴을 추가해주세요", brandColor: .blue, alignment: .center)
//    let dailyTextView = BasicTextView()
//    
//    let saveBtn = SignInButton(text: "저장하기", brandColor: .blue)
//    let postImage = PostImage()
//    let postImageBg = {
//       let view = UIView()
//        view.backgroundColor = .systemGray
//        return view
//    }()
//    
//    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageBtnTaaped))
//    
//    let postImageLabel = {
//       let view = UILabel()
//        view.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        view.textColor = .white
//        view.text = "오늘의 일상 사진을 넣어주세요."
//        return view
//    }()
//    
//    lazy var imageBtn = {
//        let view = UIImageView(image: UIImage(systemName: "flame"))
//        view.isUserInteractionEnabled = true
//        view.backgroundColor = .yellow
//        return view
//    }()
//    
//    var imageClicked: (() -> Void)?
//    
//    override func configure() {
//        [titleTextField, firstRoutinTextField, saveBtn, postImageBg, dailyTextView].forEach {
//            self.addSubview($0)
//            postImageBg.addSubview(postImageBg)
//            postImage.addSubview(postImageLabel)
//        }
//        postImageBg.addGestureRecognizer(tapGesture)
//    }
//    
//    
//    // 루틴을 추가 할때마다 텍스트 뷰 높이 조절 됨
//    @objc func imageBtnTaaped() {
//        imageClicked?()
//        print("AddDailyRoutinView - 이미지 Bg 클릭 됌 ")
//    }
//    
//    
//}
