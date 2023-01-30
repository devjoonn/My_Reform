//
//  ProfileEditViewController.swift
//  My Reform
//
//  Created by 최성우 on 2023/01/30.
//

import UIKit

class ProfileEditViewController: UIViewController {
    
    lazy var profileImage = { () -> UIImageView in
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "profile_icon")
        return profileImage
    } ()
    
    lazy var editButton = { () -> UIButton in
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "editProfileImage"), for: .normal)
        button.addTarget(self, action: #selector(editBtnClicked), for: .touchUpInside)
        return button
    } ()
    
    lazy var name_label = { () -> UILabel in
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var name_label_2 = { () -> UILabel in
        let label = UILabel()
        label.text = "10자 이내의 한글, 영문"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    lazy var name_input = { () -> UITextField in
        let text = UITextField()
        text.addLeftPadding()
        text.placeholder = " 닉네임"
        text.font = UIFont.systemFont(ofSize: 20)
        text.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 10.0
        return text
    }()
    
    lazy var name_length = { () -> UILabel in
        let label = UILabel()
        label.text = "0/10"
        label.font = UIFont.systemFont(ofSize: 15)
        label.alpha = 0.3
        return label
    }()
    
    lazy var intro_label = { () -> UILabel in
        let label = UILabel()
        label.text = "소개글"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var intro_input = { () -> UITextField in
        let text = UITextField()
        text.addLeftPadding()
        text.placeholder = " 소개글을 입력하세요."
        text.font = UIFont.systemFont(ofSize: 20)
        text.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 10.0
        return text
    }()
    
    lazy var intro_length = { () -> UILabel in
        let label = UILabel()
        label.text = "0/120"
        label.font = UIFont.systemFont(ofSize: 15)
        label.alpha = 0.3
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()

        view.addSubview(profileImage)
        view.addSubview(editButton)
        view.addSubview(name_label)
        view.addSubview(name_label_2)
        view.addSubview(name_input)
        view.addSubview(name_length)
        view.addSubview(intro_label)
        view.addSubview(intro_input)
        view.addSubview(intro_length)
        
        profileImage.snp.makeConstraints{
            (make) in
            make.top.equalToSuperview().inset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(117)
            make.height.equalTo(116)
        }
        
        editButton.snp.makeConstraints{
            (make) in
            make.top.equalTo(profileImage.snp.bottom).inset(-10)
            make.centerX.equalToSuperview()
            make.width.equalTo(85)
            make.height.equalTo(13)
        }
        
        name_label.snp.makeConstraints { make in
          make.top.equalTo(editButton.snp.bottom).inset(-25)
          make.leading.equalToSuperview().inset(30)
        }
        name_label_2.snp.makeConstraints { make in
          make.bottom.equalTo(name_label)
          make.leading.equalTo(name_label.snp.trailing).offset(10
          )
        }
        name_input.snp.makeConstraints { make in
          make.top.equalTo(name_label.snp.bottom).offset(5)
          make.leading.trailing.equalToSuperview().inset(16)
          make.width.equalTo(342)
          make.height.equalTo(50)
        }
        name_length.snp.makeConstraints { make in
          make.trailing.equalTo(name_input.snp.trailing).inset(5)
          make.centerY.equalTo(name_input)
        }
        
        intro_label.snp.makeConstraints { make in
          make.top.equalTo(name_input.snp.bottom).inset(-25)
          make.leading.equalToSuperview().inset(30)
        }
        intro_input.snp.makeConstraints { make in
          make.top.equalTo(intro_label.snp.bottom).offset(5)
          make.leading.trailing.equalToSuperview().inset(16)
          make.width.equalTo(342)
          make.height.equalTo(106)
        }
        intro_length.snp.makeConstraints { make in
          make.trailing.equalTo(intro_input.snp.trailing).inset(5)
          make.centerY.equalTo(intro_input)
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func editBtnClicked(){
        
    }
    
    @objc func completeBtnClicked(){
        
    }
    

    func configureNavbar() {
        var image = UIImage(named: "profileEditLabel")?.resize(newWidth: 76)
        image = image?.withRenderingMode(.alwaysOriginal)
        
        var image2 = UIImage(named: "complete_label")?.resize(newWidth: 28)
        image2 = image2?.withRenderingMode(.alwaysOriginal)
        
        let completeBtn = UIBarButtonItem(image: image2, style: .done, target:self, action: #selector(completeBtnClicked))
        
        self.navigationItem.titleView = UIImageView(image: image)
        self.navigationItem.rightBarButtonItem = completeBtn
        
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .label
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
