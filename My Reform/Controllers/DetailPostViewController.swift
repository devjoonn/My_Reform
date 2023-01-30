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
    
    var detailPostModel: [AllPostData] = []

    var categorysIndex: [String] = []
    var categoryString: String = ""
    
    let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    //MARK: - 프로퍼티

    private let postScrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
    }
    
    private let bottomView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 350)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(DetailPostImageCollectionViewCell.self, forCellWithReuseIdentifier: DetailPostImageCollectionViewCell.identifier)
        // 스크롤되는 이미지를 정중앙으로 배치
        cv.isPagingEnabled = false
        cv.decelerationRate = .fast
        return cv
    }()
    
    
    
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
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        
        print("detailPost 출력 - \(detailPostModel)")
        setUIView()
        setUIConstraints()
        setInfo()
        print("카테고리 인덱스는 = \(categorysIndex)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        categorysIndex.removeAll()
        categoryString.removeAll()
        detailPostModel.removeAll()
    }
    
// MARK: - 데이터 전달& 설정 함수들
    
    // 값들 지정 함수
    func setInfo() {
        
        for i in 0 ..< detailPostModel[0].categoryId!.count {
            
            switch detailPostModel[0].categoryId![i] {
            case 1:
                categorysIndex.append("디지털기기")
            case 2:
                categorysIndex.append("생활/소품")
            case 3:
                categorysIndex.append("스포츠/레저")
            case 4:
                categorysIndex.append("가구/인테리어")
            case 5:
                categorysIndex.append("여성의류")
            case 6:
                categorysIndex.append("여성잡화")
            case 7:
                categorysIndex.append("남성의류")
            case 8:
                categorysIndex.append("남성잡화")
            case 9:
                categorysIndex.append("그림")
            case 10:
                categorysIndex.append("기타")
            default:
                return
            }
        }
        
        for j in 0 ..< categorysIndex.count {
            categoryString += "\(categorysIndex[j])  "
        }
        
        userNicknameLabel.text = detailPostModel[0].nickname
        minuteLabel.text = detailPostModel[0].updateAt
        titleLabel.text = detailPostModel[0].title
        categoryLabel.text = "\(categoryString)"
        contentText.text = detailPostModel[0].contents
        guard let price = detailPostModel[0].price else { return }
        priceLabel.text = "\(price) 원"

    }
    
   
    private func setUIView() {
        view.addSubview(postScrollView)
        view.addSubview(bottomView)
    
        postScrollView.addSubview(imageCollectionView)
        
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
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.height.equalTo(350)
            make.top.leading.trailing.width.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).inset(-30)
            make.leading.equalToSuperview().inset(20)
            make.height.width.equalTo(60)
        }
        
        userNicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).inset(-30)
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
        
        
extension DetailPostViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        detailPostModel[0].imageUrl!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPostImageCollectionViewCell.identifier, for: indexPath) as? DetailPostImageCollectionViewCell else { return UICollectionViewCell() }
        
        let imageUrl = detailPostModel[0].imageUrl![indexPath.row]
        
        cell.configure(with: imageUrl)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            guard let layout = self.imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            
            let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
            
            let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
            let index: Int
            if velocity.x > 0 {
                index = Int(ceil(estimatedIndex))
            } else if velocity.x < 0 {
                index = Int(floor(estimatedIndex))
            } else {
                index = Int(round(estimatedIndex))
            }
            
            targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
        }
}
    

