//
// SignUpViewController.swift
// My Reform
//
// Created by 곽민섭 on 2023/01/16.
//
import UIKit
import SnapKit
import Then
import Alamofire



class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var keybaordDiscern: Bool = false
        
    var nickname : String = ""
    var id : String = ""
    var email: String = ""
    var pw : String = ""
    var pwCheck : String = ""
    var marketingAllow: Bool! // TermsViewController 에서 넘겨받음
    
//MARK: - Instance
    private let mainview = UIScrollView().then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = true
        $0.isScrollEnabled = true
        $0.indicatorStyle = .black
        $0.scrollIndicatorInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -3)
    }
    
    lazy var name_label = { () -> UILabel in
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont(name: "Pretendard-Medium", size: 13)
        label.textColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)
        return label
    }()
    lazy var name_label_2 = { () -> UILabel in
        let label = UILabel()
        label.text = "10자 이내의 한글, 영문"
        label.font = UIFont(name: "Pretendard-Regular", size: 11)
        label.textColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1)
        return label
    }()
    lazy var name_input = { () -> UITextField in
        let text = UITextField()
        text.signUpViewAddLeftPadding()
        // placeholder 색 바꾸기
        text.attributedPlaceholder = NSAttributedString(
            string: "닉네임을 입력해주세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )

        text.font = UIFont(name: "Pretendard-Regular", size: 16)
        text.backgroundColor = UIColor(red: 0.938, green: 0.938, blue: 0.938, alpha: 1)
        text.layer.cornerRadius = 11.0
        return text
    }()
    lazy var name_length = { () -> UILabel in
        let label = UILabel()
        label.text = "0/10"
        label.font = UIFont(name: "Pretendard-Medium", size: 15)
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
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
    // ------------------
    lazy var id_label = { () -> UILabel in
        let label = UILabel()
        label.text = "아이디"
        label.font = UIFont(name: "Pretendard-Medium", size: 13)
        label.textColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)
        return label
    }()
    lazy var id_label_2 = { () -> UILabel in
        let label = UILabel()
        label.text = "6~12자의 영문, 숫자"
        label.font = UIFont(name: "Pretendard-Regular", size: 11)
        label.textColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1)
        return label
    }()
    lazy var id_input = { () -> UITextField in
        let text = UITextField()
        text.signUpViewAddLeftPadding()
        text.attributedPlaceholder = NSAttributedString(
            string: "아이디를 입력해주세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        text.font = UIFont(name: "Pretendard-Regular", size: 16)
        text.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 11.0
        return text
    }()
    lazy var id_length = { () -> UILabel in
        let label = UILabel()
        label.text = "0/12"
        label.font = UIFont(name: "Pretendard-Medium", size: 13)
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        return label
    }()
    lazy var usable_id_label = { () -> UILabel in
        let label = UILabel()
        label.isHidden = true
        label.text = "ID의 형식에 안 맞아요."
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.mainColor
        return label
        
    }()    // --- 이메일 ----
    lazy var email_label = { () -> UILabel in
        let label = UILabel()
        label.text = "이메일"
        label.font = UIFont(name: "Pretendard-Medium", size: 13)
        label.textColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)
        return label
    }()
    lazy var email_label_2 = { () -> UILabel in
        let label = UILabel()
        label.text = "예시) identity@website.com"
        label.font = UIFont(name: "Pretendard-Regular", size: 11)
        label.textColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1)
        return label
    }()
    lazy var email_input = { () -> UITextField in
        let text = UITextField()
        text.signUpViewAddLeftPadding()
        text.attributedPlaceholder = NSAttributedString(
            string: "이메일을 입력해주세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        text.font = UIFont(name: "Pretendard-Regular", size: 16)
        text.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 11.0
        return text
    }()
    // --- 비밀번호 -----
    lazy var password_label = { () -> UILabel in
        let label = UILabel()
        label.text = "비밀번호"
        label.font = UIFont(name: "Pretendard-Medium", size: 13)
        label.textColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)
        return label
    }()
    lazy var password_label_2 = { () -> UILabel in
        let label = UILabel()
        label.text = "8자 이상 영문, 숫자, 기호"
        label.font = UIFont(name: "Pretendard-Regular", size: 11)
        label.textColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1)
        return label
    }()
    lazy var password_input = { () -> UITextField in
        let text = UITextField()
        text.signUpViewAddLeftPadding()
        text.attributedPlaceholder = NSAttributedString(
            string: "비밀번호를 입력해주세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        text.font = UIFont(name: "Pretendard-Regular", size: 16)
        text.isSecureTextEntry = true
        text.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 11.0
        return text
    }()
    lazy var usable_password_label = { () -> UILabel in
        let label = UILabel()
        label.isHidden = true
        label.text = "비밀번호가 형식에 안 맞아요."
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.mainColor
        return label
    }()
    lazy var password_check_label = { () -> UILabel in
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.font = UIFont(name: "Pretendard-Regular", size: 11)
        label.textColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1)
        return label
    }()
    lazy var password_check_input = { () -> UITextField in
        let text = UITextField()
        text.signUpViewAddLeftPadding()
        text.attributedPlaceholder = NSAttributedString(
            string: "비밀번호를 다시 한 번 입력해주세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        text.isSecureTextEntry = true
        text.font = UIFont(name: "Pretendard-Regular", size: 16)
        text.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 11.0
        return text
    }()
    lazy var usable_password_check_label = { () -> UILabel in
        let label = UILabel()
        label.isHidden = true
        label.text = "비밀번호가 틀려요"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.mainColor
        return label
    }()
    lazy var next_btn = { () -> UIButton in
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        btn.setTitle("다음", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 11
        // 버튼 비활성화
        btn.isEnabled = false
        btn.backgroundColor = UIColor.mainColor.withAlphaComponent(0.4)
        return btn
    }()
    
//MARK: - Property
    
    var isValidNickname = false{
        didSet{ self.validateUserInput() }
    }
    
    var isValidId = false{
        didSet{ self.validateUserInput() }
    }
    
    var isValidEmail = false{
        didSet { self.validateUserInput() }
    }
    
    var isValidPasswd = false{
        didSet{ self.validateUserInput() }
    }
    
    var isValidPasswdCheck = false{
        didSet{ self.validateUserInput() }
    }
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupNavigationBar()
        initializeSet()
        setAddTarget()
        setUIView()
        setUIConstraints()
    }
    
    //MARK: - 유효성 검사 후 맨위에 스트링으로 집어넣음
    func validateUserInput(){
        if isValidNickname
            && isValidId
            && isValidEmail
            && isValidPasswd
            && isValidPasswdCheck {
            next_btn.backgroundColor = UIColor.mainColor
            next_btn.isEnabled = true
            print("다음버튼 활성화")
        }else{
            next_btn.backgroundColor = UIColor.mainColor.withAlphaComponent(0.4)
            next_btn.isEnabled = false
        }
    }
    @objc func didTapLeftBarButton() {
        let vc = TermsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupNavigationBar() {
        self.title = "회원가입"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Pretendard-Bold", size: 16)!]
        
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .label
        
//        let leftBarButtonItem = UIBarButtonItem(
//            image: UIImage(named: "back_icon"),
//            style: .plain,
//            target: self,
//            action: #selector(didTapLeftBarButton)
//        )
//
//        leftBarButtonItem.tintColor = .label
//        navigationItem.leftBarButtonItem = leftBarButtonItem

    }
    
    //MARK: - Init
    private func initializeSet() {
        
        addActionToTextFieldByCase()
        setTextFieldDelegate()
        
    }
    
    // 유효성 검사
    func addActionToTextFieldByCase() {
        
        let tfEditedEndArray = [id_input, name_input, email_input, password_input, password_check_input]
    
        tfEditedEndArray.forEach{ each in
            each.addTarget(self, action: #selector(textFieldDidEditingEnd(_:)), for: .editingDidEnd)
        }
        
        name_input.addTarget(self, action: #selector(initNicknameCanUseLabel), for: .editingDidBegin)
    }
    
    func setTextFieldDelegate() {
        let textFields = [name_input, id_input, email_input, password_input, password_check_input]
        
        textFields.forEach{ each in
            each.delegate = self
        }
    }
    
//MARK: - Action
    
    @objc func initNicknameCanUseLabel(){
        usable_name_label.isHidden = false
        usable_name_label.text = "*10자 이하의 한글,영어,숫자로만 가능합니다."
    }
    
    @objc func textFieldDidEditingEnd(_ sender : UITextField){
        
        let text = sender.text ?? ""
        
        switch sender{
        
        case id_input:
            isValidId = text.isValidId()
            if(isValidId){
                usable_id_label.isHidden = true
                id = text
                print(id)
            }else{
                usable_id_label.isHidden = false
                print("isvalid ID failed")
            }
            return
            
        case name_input:
            isValidNickname = text.isValidNickname()
            if(isValidNickname){
                usable_name_label.isHidden = true
                nickname = text
                print(nickname)
            }else{
                usable_name_label.isHidden = false
                print("isvalid nickname failed")
            }
            return
            
        case email_input:
            
            isValidEmail = text.isValidEmail()
            email = text
            print(email)
            
        case password_input:
            isValidPasswd = text.isValidPassword()
            if(isValidPasswd){
                usable_password_label.isHidden = true
                pw = text
                print(pw)
            }else{
                usable_password_label.isHidden = false
                print("isvalid nickname failed")
            }
            return
            
        case password_check_input:
            
            isValidPasswdCheck = text.isValidPassword()
            if sender.text == pw {
                usable_password_check_label.isHidden = true
                pwCheck = text
            } else {
                usable_password_check_label.isHidden = false
            }
            return
        default:
            fatalError("Missing Textfield")
        }
    }
    
    func setAddTarget() {
        name_input.addTarget(self, action: #selector(nicknameTextFieldCount), for: .editingChanged)
        id_input.addTarget(self, action: #selector(textField), for: .editingChanged)
        next_btn.addTarget(self, action: #selector(nextFunc), for: .touchUpInside)
        password_check_input.addTarget(self, action: #selector(password_keyboard), for: .editingDidBegin)
        password_input.addTarget(self, action: #selector(password_keyboard), for: .editingDidBegin)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)),name: UITextField.textDidChangeNotification, object: name_input)
    }
    
    @objc func password_keyboard() {
        keybaordDiscern = true
    }
    
    func setUIView() {
        view.addSubview(name_label)
        view.addSubview(name_label_2)
        view.addSubview(name_input)
        view.addSubview(name_length)
        view.addSubview(id_label)
        view.addSubview(id_label_2)
        view.addSubview(id_input)
        view.addSubview(id_length)
        view.addSubview(email_label)
        view.addSubview(email_label_2)
        view.addSubview(email_input)
        view.addSubview(password_label)
        view.addSubview(password_label_2)
        view.addSubview(password_input)
        view.addSubview(next_btn)
        view.addSubview(usable_name_label)
        view.addSubview(usable_id_label)
        view.addSubview(usable_password_label)
        view.addSubview(usable_password_check_label)
        view.addSubview(password_check_input)
        view.addSubview(password_check_label)
        
    }
    
    func setUIConstraints() {
        //------------
        //노치 있는 아이폰과 없는 아이폰 구분
        if UIScreen.main.bounds.size.height == 667 {
            name_label.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaInsets.top).inset(59.91)
                make.leading.equalToSuperview().inset(25.74)
            }
        } else {
            name_label.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaInsets.top).inset(103.47)
                make.leading.equalToSuperview().inset(25.74)
            }
        }
        
        if UIScreen.main.bounds.size.height == 667 {
            name_label_2.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaInsets.top).inset(61.91)
                make.leading.equalTo(name_label.snp.trailing).offset(6.7
              )
            }
        } else {
            name_label_2.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaInsets.top).inset(105.91)
                make.leading.equalTo(name_label.snp.trailing).offset(6.7
              )
            }
        }
        
        name_input.snp.makeConstraints { make in
            make.top.equalTo(name_label.snp.bottom).offset(3.91)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        name_length.snp.makeConstraints { make in
            make.trailing.equalTo(name_input.snp.trailing).inset(16.64)
            make.centerY.equalTo(name_input)
        }
        
        usable_name_label.snp.makeConstraints { make in
            make.top.equalTo(name_input.snp.bottom).offset(1.87)
            make.leading.equalTo(name_label.snp.leading)
        }
        //-------
        id_label.snp.makeConstraints { make in
            make.top.equalTo(name_input.snp.bottom).offset(34.37)
            make.centerX.equalTo(email_label)
        }
        id_label_2.snp.makeConstraints { make in
            make.top.equalTo(name_input.snp.bottom).offset(35.87)
            make.leading.equalTo(name_label.snp.trailing).offset(6.7)
        }
        id_input.snp.makeConstraints { make in
            make.top.equalTo(id_label.snp.bottom).offset(3.63)
            make.leading.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        id_length.snp.makeConstraints { make in
            make.trailing.equalTo(id_input.snp.trailing).inset(16.64)
            make.centerY.equalTo(id_input)
        }
        usable_id_label.snp.makeConstraints { make in
            make.top.equalTo(id_input.snp.bottom).inset(2.14)
            make.leading.equalTo(email_label.snp.leading)
        }
        //---------------
        
        email_label.snp.makeConstraints { make in
            make.top.equalTo(id_input.snp.bottom).offset(34.62)
            make.leading.equalToSuperview().inset(25.74)
        }
        
        email_label_2.snp.makeConstraints { make in
            make.top.equalTo(id_input.snp.bottom).offset(36.62)
            make.leading.equalTo(email_label.snp.trailing).offset(6.7)
        }
        email_input.snp.makeConstraints { make in
            make.top.equalTo(email_label.snp.bottom).offset(3.87)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        //-----
        password_label.snp.makeConstraints { make in
            make.bottom.equalTo(email_input.snp.bottom).offset(54.37)
            make.leading.equalTo(name_label.snp.leading)
        }
        password_label_2.snp.makeConstraints { make in
            make.bottom.equalTo(email_input.snp.bottom).offset(53.47)
          make.leading.equalTo(password_label.snp.trailing).offset(7)
        }
        password_input.snp.makeConstraints { make in
            make.top.equalTo(password_label.snp.bottom).offset(3.91)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        usable_password_label.snp.makeConstraints { make in
            make.top.equalTo(password_input.snp.bottom).offset(2)
            make.leading.equalTo(password_label.snp.leading)
        }
        //-----
        password_check_label.snp.makeConstraints { make in
            make.top.equalTo(password_input.snp.bottom).offset(26.87)
            make.leading.equalTo(name_label.snp.leading)
        }
        password_check_input.snp.makeConstraints { make in
            make.top.equalTo(password_check_label.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        usable_password_check_label.snp.makeConstraints { make in
            make.top.equalTo(password_check_input.snp.bottom).offset(2)
            make.leading.equalTo(password_check_label.snp.leading)
        }
        
        //-----
        next_btn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.snp.bottom).inset(33)
            make.leading.trailing.equalToSuperview().inset(26.5)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            
        }
        
    }
    
    
    //MARK: - 닉네임 아이디 변할 때
    @objc func nicknameTextFieldCount(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (name_input.text!.count > 10) {
          return false
        } else if (name_input.text!.count == 10) {
          name_length.textColor = .red
          name_length.font = UIFont.boldSystemFont(ofSize: 15)
          name_length.alpha = 0.6
        }else {
          name_length.textColor = .black
          name_length.font = UIFont.systemFont(ofSize: 15)
          name_length.alpha = 0.3
        }
        name_length.text = "\(name_input.text!.count)/10"
        return true
        
    }
    
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (id_input.text!.count > 12) {
          return false
        } else if (id_input.text!.count == 12) {
          id_length.textColor = .red
          id_length.font = UIFont.boldSystemFont(ofSize: 15)
          id_length.alpha = 0.6
        }else {
          id_length.textColor = .black
          id_length.font = UIFont.systemFont(ofSize: 15)
          id_length.alpha = 0.3
        }
        id_length.text = "\(id_input.text!.count)/12"
        return true
    }
    
    
    
    // MARK: - 다음 버튼 눌렀을 시
    @objc func nextFunc() {
        print("회원가입 버튼 누름")
        
        let userData = SignUpInput(id: id, email: email, nickname: nickname, pw: pw, marketing: marketingAllow)
        SignUpDataManager.posts(self, userData)
        
    }
    
  @objc private func textDidChange(_ notification: Notification) {
      
      if let textField = notification.object as? UITextField {
        if let text = textField.text {
          if text.count > 10 {
            // 10글자 넘어가면 자동으로 키보드 내려감
            textField.resignFirstResponder()
          }
          // 초과되는 텍스트 제거
          if text.count > 10 {
            let index = text.index(text.startIndex, offsetBy: 10)
            let newString = text[text.startIndex..<index]
            textField.text = String(newString)
          }
        }
      }
    }
}

//MARK: - 키보드처리
extension SignUpViewController {
    @objc func keyboardWillShowHandle(notification: NSNotification) {
        print("keyboardWillShowHandle() called")
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            // 키보드가 버튼을 덮을 때 -> 덮은 만큼의 값을 구함
            if(keybaordDiscern == true && keyboardSize.height < password_check_input.frame.origin.y) {
                self.view.frame.origin.y =  -password_check_input.frame.height
            }
            keybaordDiscern = false

            print("keyboardSize.height: \(keyboardSize.origin.y )")
            print("password_check_input.frame.origin.y: \(password_check_input.frame.origin.y)")
        }
    }
    @objc func keyboardWillHideHandle(notification: NSNotification) {
        print("keyboardWillHide() called")
        self.view.frame.origin.y = 0
    }
    // 키보드 노티 등록
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear() called")
        // 키보드 올라가는 이벤트를 받는 처리
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // 키보드 노티 등록 해제
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear() called")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.id_input.resignFirstResponder()
        self.password_check_input.resignFirstResponder()
        self.email_input.resignFirstResponder()
        self.password_input.resignFirstResponder()
        self.name_input.resignFirstResponder()
        
     
    }
}



#if DEBUG
import SwiftUI
struct SignUpViewControllerRepresentable: UIViewControllerRepresentable {
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
  }
  @available(iOS 13.0.0, *)
  func makeUIViewController(context: Context) -> some UIViewController {
    SignUpViewController()
  }
}
@available(iOS 13.0, *)
struct SignUpViewControllerRepresentable_PreviewProvider: PreviewProvider {
  static var previews: some View {
    Group {
      SignUpViewControllerRepresentable()
        .ignoresSafeArea()
        .previewDisplayName("Preview")
        .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
//        .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
    }
  }
} #endif

