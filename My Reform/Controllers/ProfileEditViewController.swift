//
//  ProfileEditViewController.swift
//  My Reform
//
//  Created by 최성우 on 2023/01/30.
//

import UIKit

class ProfileEditViewController: UIViewController, UITextFieldDelegate {
    
    var nickname : String = ""
    var intro : String = ""
    
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
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    lazy var name_label_2 = { () -> UILabel in
        let label = UILabel()
        label.text = "10자 이내의 한글, 영문"
        label.font = UIFont.boldSystemFont(ofSize: 11)
        return label
    }()
    
    lazy var name_input = { () -> UITextField in
        let text = UITextField()
        text.addLeftPadding()
        text.placeholder = " 닉네임"
        text.font = UIFont.systemFont(ofSize: 16)
        text.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 10.0
        return text
    }()
    
    lazy var name_length = { () -> UILabel in
        let label = UILabel()
        label.text = "0/10"
        label.font = UIFont.systemFont(ofSize: 13)
        label.alpha = 0.3
        return label
    }()
    
    lazy var usable_name_label = { () -> UILabel in
        let label = UILabel()
        label.isHidden = true
        label.text = "닉네임의 형식에 안 맞아요."
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.mainColor
        return label
    }()
    
    lazy var intro_label = { () -> UILabel in
        let label = UILabel()
        label.text = "소개글"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    lazy var intro_input = { () -> UITextField in
        let text = UITextField()
        text.addLeftPadding()
        text.placeholder = " 소개글을 입력하세요."
        text.font = UIFont.systemFont(ofSize: 13)
        
        text.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 10.0
        return text
    }()
    
    lazy var intro_length = { () -> UILabel in
        let label = UILabel()
        label.text = "0/120"
        label.font = UIFont.systemFont(ofSize: 11)
        label.alpha = 0.3
        return label
    }()
    
    lazy var usable_intro_label = { () -> UILabel in
        let label = UILabel()
        label.isHidden = true
        label.text = "소개글의 형식에 안 맞아요."
        label.font = UIFont.systemFont(ofSize: 120)
        label.textColor = UIColor.mainColor
        return label
    }()
    
    var isValidNickname = false{
        didSet{ self.validateUserInput() }
    }
    
    var isValidIntro = false{
        didSet{ self.validateUserInput() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        
        initializeSet()
        setAddTarget()

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
            make.top.equalTo(intro_input.snp.bottom).inset(-5)
        }
        // Do any additional setup after loading the view.
    }
    
    func validateUserInput(){
        if isValidNickname && isValidIntro {
            print("가능한 닉네임과 소개글")
        } else{
            print("불가능한 닉네임 혹은 소개글")
        }
    }
    
    func addActionToTextFieldByCase() {
        let tfEditedEndArray = [name_input, intro_input]
        
        tfEditedEndArray.forEach{ each in
            each.addTarget(self, action: #selector(textFieldDidEditingEnd(_:)), for: .editingDidEnd)
        }
        
        name_input.addTarget(self, action: #selector(initNicknameCanUseLabel), for: .editingDidBegin)
    }
    
    func setTextFieldDelegate() {
        let textFields = [name_input, intro_input]
        
        textFields.forEach{ each in
            each.delegate = self
        }
    }
    
    @objc func initNicknameCanUseLabel() {
        usable_name_label.isHidden = false
        usable_name_label.text = "*10자 이하의 한글, 영어, 숫자로만 가능합니다."
    }
    
    @objc func textFieldDidEditingEnd(_ sender : UITextField){
        let text = sender.text ?? ""
        
        switch sender{
            
        case name_input:
            isValidNickname = text.isValidNickname()
            if(isValidNickname){
                usable_name_label.isHidden = true
                nickname = text
                print(nickname)
            } else{
                usable_name_label.isHidden = false
                print("isvalid nickname failed")
            }
            return
            
        case intro_input:
            return
            
            
        default:
            fatalError("Missing Textfield")
        }
    }
    
    func setAddTarget(){
        name_input.addTarget(self, action: #selector(nicknameTextFieldCount), for: .editingChanged)
        intro_input.addTarget(self, action: #selector(introTextFieldCount), for: .editingChanged)
    }
    
    @objc func nicknameTextFieldCount(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (name_input.text!.count > 10) {
            return false
        } else if (name_input.text!.count == 10) {
            name_length.textColor = .red
            name_length.font = UIFont.boldSystemFont(ofSize: 13)
            name_length.alpha = 0.6
        }else {
            name_length.textColor = .black
            name_length.font = UIFont.systemFont(ofSize: 13)
            name_length.alpha = 0.3
        }
        name_length.text = "\(name_input.text!.count)/10"
        return true
    }
    
    @objc func introTextFieldCount(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (intro_input.text!.count > 120) {
            return false
        } else if (intro_input.text!.count == 120) {
            intro_length.textColor = .red
            intro_length.font = UIFont.boldSystemFont(ofSize: 11)
            intro_length.alpha = 0.6
        }else {
            intro_length.textColor = .black
            intro_length.font = UIFont.systemFont(ofSize: 11)
            intro_length.alpha = 0.3
        }
        intro_length.text = "\(intro_input.text!.count)/120"
        return true
    }
    
    private func initializeSet() {
        addActionToTextFieldByCase()
        setTextFieldDelegate()
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
