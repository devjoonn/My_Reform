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
    
    // User Default에 저장된 User Nickname
    let senderId : String = UserDefaults.standard.object(forKey: "senderId") as! String
    
    static let identifier = "DetailPostViewController"
    
    var detailPostModel: [AllPostData] = []

    var categorysIndex: [String] = []
    var categoryString: String = ""
    
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
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 400)
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
        $0.font = UIFont(name: "Pretendard-Bold", size: 14)
    }
    
    private let minuteLabel = UILabel().then {
        $0.text = "3일 전"
        $0.textColor = .systemGray
        $0.font = UIFont(name: "Pretendard-Regular", size: 13)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "제목최대15자로 공백포함이다"
        $0.font = UIFont(name: "Pretendard-Bold", size: 25)
    }
    
    private let categoryLabel = UILabel().then {
        $0.text = "생활/소품"
        $0.textColor = .systemGray
        $0.font = UIFont(name: "Pretendard-Regular", size: 13)
    }
    
    private let contentText = UILabel().then {
        $0.text = "본문은 body r 행간 160% 최대 글자수 1000자 일단 이정도로 칸 만들어두고 길게 쓴 사람 있으면 스크롤 공간이 더 길어지게 하면 될듯 합니당 아래 스크롤 길이 자유! 본문은 body r 행간 160% 최대 글자수 1000자 일단 이정도로 칸 만들어두고 길게 쓴 사람 있으면 스크롤 공간이 더 길어지게 하면 될듯 합니당 아래 스크롤 길이 자유!본문은 body r 행간 160% 최대 글자수 1000자 일단 이정도로 칸 만들어두고 길게 쓴 사람 있으면 스크롤 공간이 더 길어지게 하면 될듯 합니당 아래 스크롤 길이 자유!본문은 body r 행간 160% 최대 글자수 1000자 일단 이정도로 칸 만들어두고 길게 쓴 사람 있으면 스크롤 공간이 더 길어지게 하면 될듯 합니당 아래 스크롤 길이 자유!본문은 body r 행간 160% 최대 글자수 1000자 일단 이정도로 칸 만들어두고 길게 쓴 사람 있으면 스크롤 공간이 더 길어지게 하면 될듯 합니당 아래 스크롤 길이 자유!"
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.numberOfLines = 0
    }
    
    private let sectionLine = UIView().then {
        $0.backgroundColor = .systemGray
    }
    
    private let heartBtn = UIButton().then {
        $0.setImage(UIImage(named: "heart_off"), for: .normal)
        $0.setImage(UIImage(named: "heart_on"), for: .selected)
    }
    
    private let heartLabel = UILabel().then {
        $0.text = "54"
        $0.font = UIFont(name: "Pretendard-Regular", size: 13)
        $0.textColor = .systemGray
    }
    
    private let bottomSectionLine = UIView().then {
        $0.backgroundColor = .systemGray
    }
    
    private let priceLabel = UILabel().then {
        $0.text = "4,300,000 원"
        $0.font = UIFont(name: "Pretendard-bold", size: 25)
        $0.textColor = .black
    }
    
    private let moveChatBtn = UIButton().then {
        $0.layer.cornerRadius = 25
        $0.setTitle("구매 채팅하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-bold", size: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.mainColor
    }
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // navigation right item 처리
        let setBtn = UIBarButtonItem(image: UIImage(named: "menu")?.resize(newWidth: 25), style: .done, target: self, action: #selector(setBtnClicked))
            
        self.navigationItem.rightBarButtonItem = setBtn
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .label
        
        // 뒤로가기 버튼 < 만 출력
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = UIColor.mainBlack
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        print("detailPost 출력 - \(detailPostModel)")
        setUIView()
        setUIConstraints()
        
        setInfo()
        print("카테고리 인덱스는 = \(categorysIndex)")
        heartBtn.addTarget(self, action: #selector(heartBtnClicked), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        categorysIndex.removeAll()
        categoryString.removeAll()
//        detailPostModel.removeAll()
    }
    
// MARK: - 데이터 전달& 설정 함수들
    
    // 카테고리 Id 값 지정 함수
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
        minuteLabel.text = detailPostModel[0].time
        titleLabel.text = detailPostModel[0].title
        categoryLabel.text = "\(categoryString)"
        contentText.text = detailPostModel[0].contents
        
        guard let heartSelected = detailPostModel[0].likeOrNot else { return }
        guard let heartCount = detailPostModel[0].countOfLike else { return }
        heartBtn.isSelected = heartSelected
        heartLabel.text = String(describing: heartCount)
        
        guard let price = detailPostModel[0].price else { return }
        let commaPrice = numberFormatter(number: price)
        priceLabel.text = "\(commaPrice) 원"
    }
    
    // 세자리수 컴마찍기
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
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
            make.height.equalTo(123)
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
            make.top.height.equalTo(400)
            make.top.leading.trailing.width.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).inset(-20)
            make.leading.equalToSuperview().inset(20)
            make.height.width.equalTo(45)
        }
        
        userNicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).inset(-22)
            make.leading.equalTo(profileImageView.snp.trailing).inset(-11)
        }
        
        minuteLabel.snp.makeConstraints { make in
            make.top.equalTo(userNicknameLabel.snp.bottom).inset(-5)
            make.leading.equalTo(profileImageView.snp.trailing).inset(-11)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).inset(-17)
            make.leading.equalToSuperview().inset(20)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-13)
            make.leading.equalToSuperview().inset(18)
        }
        
        sectionLine.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).inset(-13)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        contentText.snp.makeConstraints { make in
            make.top.equalTo(sectionLine.snp.bottom).inset(-20)
            make.width.equalToSuperview().multipliedBy(0.89)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        heartBtn.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.top).inset(36)
            make.leading.equalToSuperview().inset(18)
            make.height.width.equalTo(30)
        }
        
        heartLabel.snp.makeConstraints { make in
            make.top.equalTo(heartBtn.snp.bottom).inset(-5)
            make.centerX.equalTo(heartBtn.snp.centerX)
        }
        
        bottomSectionLine.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.top).inset(30)
            make.bottom.equalTo(bottomView.snp.bottom).inset(30)
            make.leading.equalTo(heartBtn.snp.trailing).inset(-10)
            make.width.equalTo(1)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView.snp.centerY)
            make.leading.equalTo(bottomSectionLine.snp.trailing).inset(-12)
        }
        
        moveChatBtn.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView.snp.centerY)
            make.trailing.equalTo(bottomView.snp.trailing).inset(16)
            make.width.equalTo(137)
            make.height.equalTo(50)
        }
    }
    
//MARK: - 게시물 수정 & 삭제가 완료되면 실행되는 함수
    func successedDelete() {
        ToastService.shared.showToast("게시물이 삭제되었습니다.")
        navigationController?.popViewController(animated: true)
    }
    
    func successedModify() {
        ToastService.shared.showToast("게시물이 수정되었습니다.")
        navigationController?.popViewController(animated: true)
    }
    
//MARK: - 좋아요 기능
    
    @objc func heartBtnClicked() {
        if heartBtn.isSelected == true {
            LikePostSendDataManager.unLike(self, LikeInput(id: senderId, boardId: detailPostModel.first?.boardId))
        } else {
            LikePostSendDataManager.like(self, LikeInput(id: senderId, boardId: detailPostModel.first?.boardId))
        }
    }
    
    func successedLike(_ likeCount:Int) {
        // 좋아요 버튼을 누르고 데이터가 성공적으로 넘어가면 작동하는 함수 [x]
        heartBtn.isSelected = true
        heartLabel.text = String(describing: likeCount)
        ToastService.shared.showToast("찜")
    }
    
    func successedUnLike(_ likeCount:Int) {
        ToastService.shared.showToast("찜 해제")
        heartLabel.text = String(describing: likeCount)
        heartBtn.isSelected = false
    }
    
//MARK: - 게시물 수정 & 삭제
    @objc func setBtnClicked() {
        // 게시물의 햄버거버튼 클릭 시 권한 확인 - post에 대한 작성자 권한 체크
        PostAuthCheckDataManager.AuthCheck(self, LikeInput(id: senderId, boardId: self.detailPostModel.first?.boardId!))
    }
    
    // 권한 확인 후
    func successedCheckAuth(_ result: Bool) {
        // 작성자가 맞으면
        if result == true {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let deleteSheet = UIAlertController(title: "정말 게시물을 삭제할까요?", message: nil, preferredStyle: .alert)
            let no = UIAlertAction(title: "아니요", style: .default, handler: nil)
            let yes = UIAlertAction(title: "네 삭제할게요", style: .default) { _ in
                // 게시물 삭제
                DeletePostDataManager.deletePosts(self, DeleteInput(id: self.senderId), (self.detailPostModel.first?.boardId!)!)
            }
            no.titleTextColor = .black
            yes.titleTextColor = UIColor.mainColor
            deleteSheet.addAction(no)
            deleteSheet.addAction(yes)
            
            let delete = UIAlertAction(title: "삭제", style: .default) {_ in
                self.present(deleteSheet, animated: true, completion: nil)
            }
            let modify = UIAlertAction(title: "수정", style: .default) { _ in
                // 게시물 수정화면으로 넘어감
                let vc = ModifyViewController()
                vc.modifyPostModel = self.detailPostModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            delete.titleTextColor = UIColor.mainColor
            modify.titleTextColor = .black
            cancel.titleTextColor = .black
            
            actionSheet.addAction(delete)
            actionSheet.addAction(modify)
            
            self.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .white
            
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true, completion: nil)
        } else {
            print("게시물에 대한 권한이 없습니다.")
        }
    }
}


//MARK: - 스크롤 이미지 컬렉션 뷰

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
    
