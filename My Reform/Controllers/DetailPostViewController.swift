//
//  DetailPostViewController.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/22.
//

import UIKit
import SnapKit
import Then
import Alamofire

// 0126 스크롤 이미지 뷰에 이미지 넣는 함수 - api 보고 다시 지정 [x]

// 테이블 뷰에서 셀 클릭 시 넘어오는 뷰로 클릭했던 data의 indexPath 값을 이 뷰로 전송
class DetailPostViewController: UIViewController, UIScrollViewDelegate {
    
    // 0123 게시물의 상세정보 불러오는 모델로 변경해야함
    var detailPostModel: [AllPostData] = []

    var imageUrls: [UIImage] = []
    
    //MARK: - 프로퍼티
//    var imagesViews = [UIImageView]()
    
    private let postScrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
    }
    
    private let bottomView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let postView = UIView().then {
        $0.backgroundColor = .white
    }
    
    
    private let imageScrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.indicatorStyle = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
        $0.isPagingEnabled = true
    }
    
    
    private let imageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
//        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.spacing = 8
    }
    
//    private let imageView = UIImageView().then {
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.contentMode = .scaleAspectFill
//    }
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "no_profile")
    }
    
    private let userNicknameLabel = UILabel().then {
        $0.text = "백살먹은 리포머"
        $0.font = UIFont.boldSystemFont(ofSize: 19)
    }
    
    private let minuteLabel = UILabel().then {
        $0.text = "3일 전"
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "제목최대15자로 공백포함이다"
        $0.font = UIFont.boldSystemFont(ofSize:26)
    }
    
    private let categoryLabel = UILabel().then {
        $0.text = "생활/소품"
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    private let contentText = UILabel().then {
        $0.text = "본문은 body r 행간 160% 최대 글자수 1000자 일단 이정도로 칸 만들어두고 길게 쓴 사람 있으면 스크롤 공간이 더 길어지게 하면 될듯 합니당 아래 스크롤 길이 자유! 본문은 body r 행간 160% 최대 글자수 1000자 일단 이정도로 칸 만들어두고 길게 쓴 사람 있으면 스크롤 공간이 더 길어지게 하면 될듯 합니당 아래 스크롤 길이 자유!본문은 body r 행간 160% 최대 글자수 1000자 일단 이정도로 칸 만들어두고 길게 쓴 사람 있으면 스크롤 공간이 더 길어지게 하면 될듯 합니당 아래 스크롤 길이 자유!본문은 body r 행간 160% 최대 글자수 1000자 일단 이정도로 칸 만들어두고 길게 쓴 사람 있으면 스크롤 공간이 더 길어지게 하면 될듯 합니당 아래 스크롤 길이 자유!본문은 body r 행간 160% 최대 글자수 1000자 일단 이정도로 칸 만들어두고 길게 쓴 사람 있으면 스크롤 공간이 더 길어지게 하면 될듯 합니당 아래 스크롤 길이 자유!"
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.numberOfLines = 0
    }
    
    private let sectionLine = UIView().then {
        $0.backgroundColor = .systemGray
    }
    
    private let heartBtn = UIButton().then {
        $0.setImage(UIImage(named: "heart_off"), for: .normal)
        $0.setImage(UIImage(named: "heart_on"), for: .selected)
        $0.tintColor = .systemGray
    }
    
    private let heartLabel = UILabel().then {
        $0.text = "54"
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .systemGray
    }
    
    private let bottomSectionLine = UIView().then {
        $0.backgroundColor = .systemGray
    }
    
    private let priceLabel = UILabel().then {
        $0.text = "4,300,000 원"
        $0.font = UIFont.boldSystemFont(ofSize: 22)
        $0.textColor = .black
    }
    
    private let moveChatBtn = UIButton().then {
        $0.layer.cornerRadius = 20
        $0.setTitle("구매 채팅하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.mainColor
    }
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        imageScrollView.delegate = self
        print("detailPost 출력 - \(detailPostModel)")
        setUIView()
        setUIConstraints()
        addContentScrollView()
        setInfo()
    }
    
// MARK: - 데이터 전달& 설정 함수들
    
    // 값들 지정 함수
    func setInfo() {
        addContentScrollView()
        userNicknameLabel.text = detailPostModel[0].nickname
        minuteLabel.text = detailPostModel[0].updateAt
        titleLabel.text = detailPostModel[0].title
        categoryLabel.text = "\(detailPostModel[0].categoryId!)"
        contentText.text = detailPostModel[0].contents
        guard let price = detailPostModel[0].price else { return }
        priceLabel.text = "\(price) 원"

    }
    
    // 스크롤뷰에 이미지 설정
    private func addContentScrollView() {
        
        for i in 0 ..< detailPostModel[0].imageUrl!.count {
            // 이미지뷰를 생성해서 바로 이미지까지 지정
            let imageView = UIImageView().then {
                $0.contentMode = .scaleAspectFit
                // 이미지뷰에 이미지 지정
                guard let url = URL(string:"\(Constants.baseURL)\(detailPostModel[0].imageUrl![i])") else { return }
                print("url 링크는 = \(url)")
                $0.sd_setImage(with:url, completed: nil)
            }
            imageStackView.addArrangedSubview(imageView)

            imageView.snp.makeConstraints { make in
                make.top.leading.trailing.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            
            // 스크롤뷰의 길이(xPos) = 스크롤뷰 가로길이 * 현재 인덱스
//            let xPos = imageScrollView.frame.width * CGFloat(i)
//            imageView.frame = CGRect(x: xPos, y: 0, width: imageScrollView.bounds.width, height: imageScrollView.bounds.height)
//            print(imageScrollView.frame.width)
//            print(imageView.frame.width)
//
////          스크롤뷰의 컨텐츠 사이즈 = imageView 가로길이
//            imageScrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
        }
    }
   
    private func setUIView() {
        view.addSubview(postScrollView)
        view.addSubview(bottomView)
        
        postScrollView.addSubview(postView)
        postView.addSubview(imageScrollView)
        imageScrollView.addSubview(imageStackView)
//        imageScrollView.addSubview(imageView)
        
        postScrollView.addSubview(profileImageView)
        postScrollView.addSubview(userNicknameLabel)
        postScrollView.addSubview(minuteLabel)
        postScrollView.addSubview(titleLabel)
        postScrollView.addSubview(categoryLabel)
        postScrollView.addSubview(contentText)
        postScrollView.addSubview(sectionLine)
        
        bottomView.addSubview(heartBtn)
        bottomView.addSubview(heartLabel)
        bottomView.addSubview(bottomSectionLine)
        bottomView.addSubview(priceLabel)
        bottomView.addSubview(moveChatBtn)
    }
    
    private func setUIConstraints() {
        
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(90)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        postScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        postView.snp.makeConstraints { make in
            make.height.equalTo(350)
            make.top.leading.trailing.equalToSuperview()
        }
        
        imageScrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.height.equalToSuperview()
        }
        
        imageStackView.snp.makeConstraints { make in
            make.top.left.right.bottom.height.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(postView.snp.bottom).inset(-30)
            make.leading.equalToSuperview().inset(20)
            make.height.width.equalTo(60)
        }
        
        userNicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(postView.snp.bottom).inset(-30)
            make.leading.equalTo(profileImageView.snp.trailing).inset(-20)
        }
        
        minuteLabel.snp.makeConstraints { make in
            make.top.equalTo(userNicknameLabel.snp.bottom).inset(-5)
            make.leading.equalTo(profileImageView.snp.trailing).inset(-20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).inset(-27)
            make.leading.equalToSuperview().inset(20)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-27)
            make.leading.equalToSuperview().inset(20)
        }
        
        sectionLine.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).inset(-20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        contentText.snp.makeConstraints { make in
            make.top.equalTo(sectionLine.snp.bottom).inset(-20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        heartBtn.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.top).inset(5)
            make.leading.equalTo(bottomView.snp.leading).inset(17)
            make.height.width.equalTo(60)
        }
        
        heartLabel.snp.makeConstraints { make in
            make.top.equalTo(heartBtn.snp.bottom).inset(10)
            make.centerX.equalTo(heartBtn.snp.centerX)
        }
        
        bottomSectionLine.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.top).inset(10)
            make.bottom.equalTo(bottomView.snp.bottom).inset(10)
            make.leading.equalTo(heartBtn.snp.trailing).inset(-15)
            make.width.equalTo(1)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView.snp.centerY)
            make.leading.equalTo(bottomSectionLine.snp.trailing).inset(-15)
        }
        
        moveChatBtn.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView.snp.centerY)
            make.trailing.equalTo(bottomView.snp.trailing).inset(18)
            make.width.equalTo(115)
            make.height.equalTo(50)
        }
    }
}
        
        
    








#if DEBUG
import SwiftUI
struct ViewControllerRepresentable: UIViewControllerRepresentable {
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
  }
  @available(iOS 13.0.0, *)
  func makeUIViewController(context: Context) -> some UIViewController {
      DetailPostViewController()
  }
}
@available(iOS 13.0, *)
struct ViewControllerRepresentable_PreviewProvider: PreviewProvider {
  static var previews: some View {
    Group {
        SearchViewControllerRepresentable()
        .ignoresSafeArea()
        .previewDisplayName("Preview")
        .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
    }
  }
} #endif
