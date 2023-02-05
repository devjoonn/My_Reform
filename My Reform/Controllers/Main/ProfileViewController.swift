//
//  ProfileViewController.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/06.
//

import UIKit
import SnapKit
import Then
import Alamofire
import SDWebImage

class ProfileViewController: UIViewController {

    static let identifier = "ProfileViewController"

    var lastBoardId : Int = 100
    
    var profileDataManagerUrl: String = "\(Constants.baseURL)/users/{userId}/profiles"
    
    var myPostDataManagerUrl: String = "\(Constants.baseURL)/boards?lastBoardId=&size=&id="
    
//     데이터 모델이 추가될 때 마다 테이블 뷰 갱신
    var allPostModel: [AllPostData] = []{
        didSet {
            self.myFeedTable.reloadData()
        }
    }
    
    var profileLookupModel: [ProfileLookupData] = []
    
    private let refreshControl = UIRefreshControl()
    
    lazy var myFeedTable = { () -> UITableView in
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        table.backgroundColor = .white
        return table
    } ()

    lazy var profileImage = { () -> UIImageView in
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "profile_icon")
        return profileImage
    } ()
    
    lazy var editButton = { () -> UIButton in
        let button = UIButton()
//        button.setBackgroundImage(UIImage(named: "edit_icon"), for: .normal)
        button.setTitle("프로필 편집", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard", size: 13)
        button.titleLabel?.textColor = UIColor.mainColor
        button.setUnderline()
        button.addTarget(self, action: #selector(profileClicked), for: .touchUpInside)
        return button
    } ()
    
    lazy var backgroundImage = { () -> UIImageView in
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "backgroundImage")
        return backgroundImage
    } ()
    
    lazy var nameLabel = { () -> UILabel in
        let nameLabel = UILabel()
        nameLabel.text = "백살먹은 리포머"
        nameLabel.font = UIFont(name: "Pretendard-Bold", size: 16)
        nameLabel.textColor = UIColor(hex: "000000")
        return nameLabel
    } ()
    
    lazy var introLabel = { () -> UILabel in
        let introLabel = UILabel()
        introLabel.text = "혼자 만드는 거 좋아하는 리포머입니다. @reformer_hundred"
        introLabel.font = UIFont(name: "Pretendard-Medium", size: 13)
        introLabel.textColor = UIColor(hex: "000000")
        introLabel.numberOfLines = 2
        introLabel.textAlignment = .center
        introLabel.preferredMaxLayoutWidth = 240
        return introLabel
    } ()
    
    lazy var uploadLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "업로드한 리폼"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = UIColor.mainBlack
        return label
    } ()
    
    func setUIView(){
        self.view.insertSubview(backgroundImage, belowSubview: profileImage)
        self.view.addSubview(editButton)
        self.view.addSubview(profileImage)
        self.view.addSubview(nameLabel)
        self.view.addSubview(introLabel)
        self.view.addSubview(uploadLabel)
    }
    
    func setUIConstraints(){
        editButton.snp.makeConstraints{
            (make) in
            make.top.equalTo(introLabel.snp.bottom).inset(-10)
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        
        backgroundImage.snp.makeConstraints{
            (make) in
            make.top.equalToSuperview().inset(0)
            make.leading.equalToSuperview().inset(-5)
            make.width.equalTo(476.32)
            make.height.equalTo(182.97)
        }
        
        profileImage.snp.makeConstraints{
            (make) in
            make.top.equalToSuperview().inset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(117)
            make.height.equalTo(116)
        }
        
        nameLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(profileImage.snp.bottom).inset(-15)
            make.centerX.equalToSuperview()
            make.height.equalTo(26)
        }
        
        introLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(nameLabel.snp.bottom).inset(-15)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        uploadLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(editButton.snp.bottom).inset(-21.23)
            make.leading.equalToSuperview().inset(18)
        }
        
        myFeedTable.snp.makeConstraints {
            $0.top.equalTo(uploadLabel.snp.bottom).inset(-9.6)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.insertSubview(myFeedTable, belowSubview: backgroundImage)

        
        myFeedTable.delegate = self
        myFeedTable.dataSource = self
        
        setUIView()
        setUIConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        configureNavbar()
        fetchingAll(100)
        allPostGet()
        profileChanged()
        
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\(profileLookupModel)")
    }
    
    func profileChanged(){
        print("profileChanged called")
        guard let model = profileLookupModel.first else { return }
        print(model)
        nameLabel.text = model.nickname
        introLabel.text = model.introduction
    }
    
    //------------------------------- 프로필 정보 불러오기
    
    func allPostGet() {
        print("allPostGet Called")
        let url = "\(Constants.baseURL)users/1/profiles"
        
        AF.request(url ,method: .get, parameters: nil).validate().responseDecodable(of: ProfileLookupModel.self) { response in
                switch(response.result) {
                case .success(let result) :
                    print("프로필 서버통신 성공 - \(result)")
                    switch(result.status) {
                    case 200 :
                        guard let data = result.data else { return }
                        print("data!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\(data)")
                        self.profileLookupModel.append(contentsOf: data)
                    case 404 :
                        print("프로필이 없는 경우입니다 - \(result.message)")
                    default:
                        print("데이터베이스 오류")
                        let alert = UIAlertController()
                        alert.title = "서버 오류"
                        alert.message = "서버에서 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
                        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(alertAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                case .failure(let error) :
                    print(error)
                    print(error.localizedDescription)
                }
            }
    }
    
    //---------- 게시글 불러오기
    
    private func fetchingAll(_ lastBoardId: Int) {
        print("fetchingAll - lastBoardId = \(lastBoardId)")
        AF.request("\(Constants.baseURL)/boards?lastBoardId=&size=10", method: .get, parameters: nil).validate().responseDecodable(of: AllPostModel.self) { response in
            DispatchQueue.main.async {
                self.myFeedTable.tableFooterView = nil
            }
            switch(response.result) {
            case .success(let result) :
                print("게시물 추가조회 성공 - \(result)")
                switch(result.status) {
                case 200 :
                    DispatchQueue.main.async {
                        self.myFeedTable.tableFooterView = nil
                    }
                    guard let data = result.data else{
                        return
                    }
                    self.successAllPostModel(result: data)
                    DispatchQueue.main.async {
                        self.myFeedTable.reloadData()
                    }
                case 404 :
                    print("게시물이 없는 경우입니다 - \(result.message)")
                default:
                    print("데이터베이스 오류")
                }
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
    //-------------------------
    //버튼 클릭 시
    
    @objc func profileClicked(){
        let vc = ProfileEditViewController()
        vc.modalTransitionStyle = .flipHorizontal
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func settingClicked(){
        //설정 페이지 넘어가게
        let vc = SettingViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //----------------------------------
    //네비게이션 바
    
    func configureNavbar() {
        print("configureNavbar 실행")
        // 뒤로가기 버튼 < 만 출력
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
            backBarButtonItem.tintColor = .black
            self.navigationItem.backBarButtonItem = backBarButtonItem

        var image2 = UIImage(named: "setting_icon")?.resize(newWidth: 24.95)
        image2 = image2?.withRenderingMode(.alwaysOriginal)

        let settingBtn = UIBarButtonItem(image: image2, style: .done, target:self, action: #selector(settingClicked))

        self.navigationItem.title = "프로필"

        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Pretendard-Bold", size: 16)!
        ]
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationItem.rightBarButtonItem = settingBtn

        if (ProfileViewController.isEqual(self.view)){
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes =  [
                .foregroundColor: UIColor.white,
                .font: UIFont(name: "Pretendard-Bold", size: 16)!
            ]

            // 네비게이션바 배경색
            appearance.backgroundColor = UIColor.mainColor

            // 아래 회색 라인 없애기
            appearance.shadowColor = .clear

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance

            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.backgroundColor = .clear
            navigationController?.navigationBar.tintColor = .clear
        } else {

        }
    }
    
        
    //----------------------------------------------------
    
    func successProfileModel(result: [ProfileLookupData]){
        self.profileLookupModel.append(contentsOf: result)
        print(profileLookupModel.count)
    }
    
    func successAllPostModel(result: [AllPostData]) {
        self.allPostModel.append(contentsOf: result)
        print(allPostModel.count)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPostModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell()  }
        
        let model = allPostModel[indexPath.row]
        
        guard let updateAt = model.updateAt else {return UITableViewCell()}
        guard let price = model.price else { return UITableViewCell()}
        
        cell.configure(with: HomeFeedViewModel(imageUrl: model.imageUrl?.first ?? "", title: model.title ?? "", minute: updateAt, price: price))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("cell indexPath = \(indexPath)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = allPostModel[indexPath.row]
        
        let vc = DetailPostViewController()
        vc.detailPostModel = [model]
        print("detailPostModel에 data 저장됨")
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let position = scrollView.contentOffset.y
        if position > (myFeedTable.contentSize.height-100-scrollView.frame.size.height) {
            print("데이터 불러오는 중")
            dataFetch()
        }
    }
    
    func dataFetch() {
        print("dataFetch() called - ")
        self.myFeedTable.tableFooterView = createSpinnerFooter()
        
        if allPostModel.count == 0{
            return
        }
        
        lastBoardId = allPostModel[allPostModel.count - 1].boardId!
        print("lastBoardId = \(lastBoardId)")
        fetchingAll(lastBoardId)
    }
}

extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
}

#if DEBUG
import SwiftUI
struct ProfileViewControllerRepresentable: UIViewControllerRepresentable {
    
func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
}
@available(iOS 13.0.0, *)
func makeUIViewController(context: Context) -> UIViewController{
    ProfileViewController()
    }
}
@available(iOS 13.0, *)
struct ProfileViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        }
        
    }
} #endif
