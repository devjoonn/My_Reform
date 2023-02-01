//
//  SettingViewController.swift
//  My Reform
//
//  Created by 최성우 on 2023/01/30.
//

import UIKit
import SnapKit
import Alamofire
import Then
import SDWebImage

class SettingViewController: UIViewController {
    
    //----------------------------------------
    
    lazy var individualLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "개인 설정"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = UIColor(hex: "000000")
        return label
    } ()
    
    lazy var editEmailLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "이메일 변경"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(hex: "000000")
        return label
    } ()
    
    lazy var editPasswordLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "비밀번호 변경"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(hex: "000000")
        return label
    } ()
    
    lazy var line = { () -> UIImageView in
        let image = UIImageView()
        image.image = UIImage(named: "line")
        return image
    } ()
    
    lazy var informationLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "이용 안내"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = UIColor(hex: "000000")
        return label
    } ()
    
    lazy var appVersionLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "앱 버전"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(hex: "000000")
        return label
    } ()
    
    lazy var questionLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "문의하기"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(hex: "000000")
        return label
    } ()
    
    lazy var noticeLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "공지사항"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(hex: "000000")
        return label
    } ()
    
    lazy var termsLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "서비스 이용약관"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(hex: "000000")
        return label
    } ()
    
    lazy var privacyLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "개인정보 처리방침"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(hex: "000000")
        return label
    } ()
    
    lazy var licenseLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "오픈소스 라이선스"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(hex: "000000")
        return label
    } ()
    
    lazy var line2 = { () -> UIImageView in
        let image = UIImageView()
        image.image = UIImage(named: "line")
        return image
    } ()
    
    lazy var etcLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "기타"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = UIColor(hex: "000000")
        return label
    } ()
    
    lazy var withdrawalLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "회원 탈퇴"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(hex: "000000")
        return label
    } ()
    
    lazy var logoutLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "로그아웃"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(hex: "000000")
        return label
    } ()
    
    lazy var versionLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "6.4.1"
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = UIColor.systemGray
        return label
    } ()
    
    //----------------------------

//    var tableView = UITableView(frame: .zero, style: .plain)
//
//    let data = [["이메일 변경","비밀번호 변경"],["앱 버전","문의하기","공지사항","서비스 이용약관","개인정보 처리방침","오픈소스 라이선스"],["회원 탈퇴","로그아웃"]]
////    let data = [[editEmailLabel, editPasswordLabel],[appVersionLabel, questionLabel, noticeLabel, termsLabel, privacyLabel, licenseLabel],[withdrawalLabel, logoutLabel]]
//    let header = ["개인 설정","이용 안내","기타"]
//
    
    
    //--------------------------------------
    
    @objc func editEmailLabelTapped(sender: UITapGestureRecognizer) {
     // 원하는 대로 코드 구성
        print("이동")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureNavbar()
        
//
//        self.view.addSubview(tableView)
//        self.tableView.dataSource = self
//
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
//        self.tableView.translatesAutoresizingMaskIntoConstraints = false
//        self.tableView.separatorStyle = .none
//
//        NSLayoutConstraint.activate([
//            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
//            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
//            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
//        ])
        
        
        //-----------------
        
        
        //-----------------------------------------------
//        스크롤뷰
        
        let scrollView : UIScrollView! = UIScrollView()

        let contentView : UIView! = UIView()

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])

        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = false
        
//        ------------------------------
//
//
//        -------------------------------------------------------------
//        constraint
        
        contentView.addSubview(individualLabel)
        contentView.addSubview(editEmailLabel)
        contentView.addSubview(editPasswordLabel)
        contentView.addSubview(line)
        contentView.addSubview(informationLabel)
        contentView.addSubview(appVersionLabel)
        contentView.addSubview(questionLabel)
        contentView.addSubview(noticeLabel)
        contentView.addSubview(termsLabel)
        contentView.addSubview(privacyLabel)
        contentView.addSubview(licenseLabel)
        contentView.addSubview(line2)
        contentView.addSubview(etcLabel)
        contentView.addSubview(withdrawalLabel)
        contentView.addSubview(logoutLabel)
        contentView.addSubview(versionLabel)

        individualLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(contentView.snp.top).inset(44.87)
            make.leading.equalToSuperview().inset(37.54)
        }

        editEmailLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(individualLabel.snp.bottom).inset(-16.23)
            make.leading.equalToSuperview().inset(37.54)
        }

        editPasswordLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(editEmailLabel.snp.bottom).inset(-12)
            make.leading.equalToSuperview().inset(37.54)
        }

        line.snp.makeConstraints{
            (make) in
            make.top.equalTo(editPasswordLabel.snp.bottom).inset(-26.88)
            make.leading.trailing.equalToSuperview().inset(17)
        }

        informationLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(line.snp.bottom).inset(-26.32)
            make.leading.equalToSuperview().inset(37.54)
        }

        appVersionLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(informationLabel.snp.bottom).inset(-18.23)
            make.leading.equalToSuperview().inset(37.54)
        }

        versionLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(informationLabel.snp.bottom).inset(-18.23)
            make.trailing.equalToSuperview().inset(43.08)
        }

        questionLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(appVersionLabel.snp.bottom).inset(-10)
            make.leading.equalToSuperview().inset(37.54)
        }

        noticeLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(questionLabel.snp.bottom).inset(-12)
            make.leading.equalToSuperview().inset(37.54)
        }

        termsLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(noticeLabel.snp.bottom).inset(-12)
            make.leading.equalToSuperview().inset(37.54)
        }

        privacyLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(termsLabel.snp.bottom).inset(-12)
            make.leading.equalToSuperview().inset(37.54)
        }

        licenseLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(privacyLabel.snp.bottom).inset(-12)
            make.leading.equalToSuperview().inset(37.54)
        }

        line2.snp.makeConstraints{
            (make) in
            make.top.equalTo(licenseLabel.snp.bottom).inset(-34.88)
            make.leading.trailing.equalToSuperview().inset(17)
        }

        etcLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(line2.snp.bottom).inset(-24.88)
            make.leading.equalToSuperview().inset(37.54)
        }

        withdrawalLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(etcLabel.snp.bottom).inset(-16.23)
            make.leading.equalToSuperview().inset(37.54)
        }

        logoutLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(withdrawalLabel.snp.bottom).inset(-12)
            make.leading.equalToSuperview().inset(37.54)
        }
        
        //---------------------------
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editEmailLabelTapped))
        editEmailLabel.addGestureRecognizer(tapGestureRecognizer)
    
        
        // Do any additional setup after loading the view.
    }
    
    //-----------------------------
//      네비게이션바
    func configureNavbar() {
        var image = UIImage(named: "settingLabel")?.resize(newWidth: 29)
        image = image?.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.title = "설정"
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Pretendard-Bold", size: 16)!
        ]
        
        
//        self.navigationItem.titleView = UIImageView(image: image)
        
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .label
    }

}

//extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data[section].count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellWithIndexPath = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
//        cellWithIndexPath.textLabel?.text = data[indexPath.section][indexPath.row]
//        return cellWithIndexPath
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return header.count
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return header[section]
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.backgroundColor = .red
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.font = UIFont(name: "Pretendard", size: 50)
//        header.textLabel?.textColor = .systemRed
//    }
//}

#if DEBUG
import SwiftUI
struct SettingViewControllerRepresentable: UIViewControllerRepresentable {
    
func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
}
@available(iOS 13.0.0, *)
func makeUIViewController(context: Context) -> UIViewController{
    SettingViewController()
    }
}
@available(iOS 13.0, *)
struct SettingViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            SettingViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        }
        
    }
} #endif
