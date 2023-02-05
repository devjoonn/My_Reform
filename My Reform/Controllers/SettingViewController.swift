//
//  SettingViewController.swift
//  My Reform
//
//  Created by 최성우 on 2023/01/30.
//

import UIKit
import SnapKit
import Alamofire
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
    
    lazy var logoutButton = { () -> UIButton in
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 16)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    } ()
    
    lazy var versionLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "6.4.1"
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = UIColor.systemGray
        return label
    } ()
    
    @objc func logoutBtnClicked(){
        let vc = LoginViewController()
        navigationController?.popToRootViewController(animated: true)
        vc.modalPresentationStyle = .fullScreen
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
//        navigationController?.present(vc, animated: true)
//        navigationController?.modalPresentationStyle = .fullScreen
    }
    
    //----------------------------
    
    
    //--------------------------------------
    
    func setUIView(){
        view.addSubview(individualLabel)
        view.addSubview(editEmailLabel)
        view.addSubview(editPasswordLabel)
        view.addSubview(line)
        view.addSubview(informationLabel)
        view.addSubview(appVersionLabel)
        view.addSubview(questionLabel)
        view.addSubview(noticeLabel)
        view.addSubview(termsLabel)
        view.addSubview(privacyLabel)
        view.addSubview(licenseLabel)
        view.addSubview(line2)
        view.addSubview(etcLabel)
        view.addSubview(withdrawalLabel)
        view.addSubview(logoutButton)
        view.addSubview(versionLabel)
    }
    
    func setUIConstraints(){
        individualLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(30)
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

        logoutButton.snp.makeConstraints{
            (make) in
            make.top.equalTo(withdrawalLabel.snp.bottom).inset(-12)
            make.leading.equalToSuperview().inset(37.54)
            make.width.equalTo(56)
            make.height.equalTo(26)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureNavbar()
        setUIView()
        setUIConstraints()

        logoutButton.addTarget(self, action: #selector(logoutBtnClicked), for: .touchUpInside)
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
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .label
    }

}
