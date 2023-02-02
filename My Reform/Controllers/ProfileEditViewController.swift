//
//  ProfileEditViewController.swift
//  My Reform
//
//  Created by 최성우 on 2023/01/30.
//

import UIKit

class ProfileEditViewController: UIViewController, UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true) /// 화면을 누르면 키보드 내려가게 하는 것
    }
    
    var nickname : String = ""
    var intro : String = ""
    
    lazy var profileImage = { () -> UIImageView in
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "profile_icon")
        return profileImage
    } ()
    
    lazy var editButton = { () -> UIButton in
        let button = UIButton()
//        button.setBackgroundImage(UIImage(named: "editProfileImage"), for: .normal)
//        button.addTarget(self, action: #selector(editBtnClicked), for: .touchUpInside)
        button.setTitle("프로필 사진 수정", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 13)
        button.setTitleColor(UIColor.mainColor, for: .normal)
        button.addTarget(self, action: #selector(editBtnClicked), for: .touchUpInside)
        return button
    } ()
    
//    lazy var editButton = { () -> UIButton in
//        let button = UIButton()
//        button.setTitle("프로필 편집", for: .normal)
//        button.titleLabel?.font = UIFont(name: "Pretendard", size: 13)
//        button.titleLabel?.textColor = UIColor.mainColor
//        button.setUnderline()
//        button.addTarget(self, action: #selector(profileClicked), for: .touchUpInside)
//        return button
//    } ()
    
    lazy var name_label = { () -> UILabel in
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont(name: "Pretendard-Medium", size: 13)
        label.textColor = UIColor(hex: "212121")
        return label
    }()
    
    lazy var name_label_2 = { () -> UILabel in
        let label = UILabel()
        label.text = "10자 이내의 한글, 영문"
        label.font = UIFont(name: "Pretendard", size: 11)
        label.textColor = UIColor.mainBlack
        return label
    }()
    
    lazy var name_input = { () -> UITextField in
        let text = UITextField()
        text.addLeftPadding()
        text.placeholder = " 닉네임"
        text.font = UIFont(name: "Pretendard-Medium", size: 16)
        text.textColor = .systemGray
        text.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 11
        return text
    }()
    
    lazy var name_length = { () -> UILabel in
        let label = UILabel()
        label.text = "0/10"
        label.font = UIFont(name: "Pretendard-Medium", size: 13)
        label.textColor = UIColor(hex: "666666")
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
        label.font = UIFont(name: "Pretendard-Medium", size: 13)
        label.textColor = UIColor(hex: "212121")
        return label
    }()
    
    lazy var intro_input = { () -> UITextField in
        let text = UITextField()
        text.addLeftPadding()
        text.placeholder = " 소개글을 입력하세요."
        text.font = UIFont(name: "Pretendard-Medium", size: 13)
        text.textColor = .systemGray
        text.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 11
        return text
    }()
    
    let descriptTextView = UITextView()
    
    
    lazy var intro_length = { () -> UILabel in
        let label = UILabel()
        label.text = "0/120"
        label.font = UIFont(name: "Pretendard-Medium", size: 11)
        label.textColor = UIColor(hex: "909090")
        label.alpha = 0.3
        return label
    }()
    
    let descriptionTextCnt = UILabel()
    
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
        view.backgroundColor = .white
        configureNavbar()
        
        attribute()
        initializeSet()
        setAddTarget()

        view.addSubview(profileImage)
        view.addSubview(editButton)
        view.addSubview(name_label)
        view.addSubview(name_label_2)
        view.addSubview(name_input)
        view.addSubview(name_length)
        view.addSubview(intro_label)
        view.addSubview(descriptTextView)
        view.addSubview(descriptionTextCnt)
        
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
        descriptTextView.snp.makeConstraints { make in
          make.top.equalTo(intro_label.snp.bottom).offset(5)
          make.leading.trailing.equalToSuperview().inset(16)
          make.width.equalTo(342)
          make.height.equalTo(106)
        }
        descriptionTextCnt.snp.makeConstraints { make in
          make.trailing.equalTo(descriptTextView.snp.trailing).inset(5)
            make.top.equalTo(descriptTextView.snp.bottom).inset(-5)
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
//        intro_input.addTarget(self, action: #selector(introTextFieldCount), for: .editingChanged)
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
        navigationController?.popViewController(animated: true)
    }
    

    func configureNavbar() {
        
        self.navigationItem.title = "프로필 편집"
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Pretendard-Bold", size: 16)!
        ]
        
        let completeBtn = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeBtnClicked))
        completeBtn.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Pretendard-Bold", size: 16),
            NSAttributedString.Key.foregroundColor : UIColor(red: 1, green: 0.459, blue: 0.251, alpha: 1)],
                                         for: .normal)
        
        self.navigationItem.rightBarButtonItem = completeBtn
//        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 1, green: 0.459, blue: 0.251, alpha: 1)
        
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

extension ProfileEditViewController : UITextViewDelegate {
    func attribute() {
        descriptTextView.text = "소개글을 입력하세요."
        descriptTextView.font = .systemFont(ofSize: 13, weight: .regular)
        descriptTextView.textColor = .secondaryLabel
        descriptTextView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        descriptTextView.delegate = self
        descriptTextView.text = "소개글을 입력하세요."
        descriptTextView.delegate = self
        descriptTextView.textColor = .secondaryLabel
        descriptTextView.layer.cornerRadius = 11
        descriptionTextCnt.font = .systemFont(ofSize: 11)
        descriptionTextCnt.textColor = .secondaryLabel
        descriptionTextCnt.text = "\(descriptTextView.text.count)/120"
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.text = ""
            textView.textColor = .label
        }
        descriptionTextCnt.text = "\(descriptTextView.text.count)/120"
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = descriptTextView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {return false}
        let changeText = currentText.replacingCharacters(in: stringRange, with: text)
        descriptionTextCnt.text = "\(changeText.count)/120"
        
        return true
    }
}

//extension ProfileEditViewController: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//            /// 플레이스 홀더
//            if textView.text == placholder {
//                textView.text = nil
//                textView.textColor = .white
//            } else if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//                textView.text = placholder
//                textView.textColor = .gray200
//            }
//        }
//
//        func textViewDidEndEditing(_ textView: UITextView) {
//            if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//                textView.text = placholder
//                textView.textColor = .gray200
//            }
//        }
//    func textViewDidChange(_ textView: UITextView) {
//        if activityTextView.text.count > 150 {
//           activityTextView.deleteBackward()
//        }
//    }
//}
