//
//  SignUpViewController.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/06.
//

import UIKit
import SnapKit
import Then
//import KakaoSDKCommon
//import KakaoSDKAuth
//import KakaoSDKUser

class LoginViewController: UIViewController {
    
    var keyBoardUp: Bool = false
    
    /* // 카카오 네이티브 키 값 가져오는 코드
     let KAKAO_APP_KEY: String = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String ?? "KAKAO_APP_KEY is nil"
     KakaoSDKCommon.initSDK(appKey: KAKAO_APP_KEY, loggingEnable:true)
     */
    
    
    private let logoImage = UIImageView().then {
        let logo = UIImage(named: "myReform_logo")
        $0.image = logo
    }
    
    private let idLabel = UILabel().then {
        $0.text = "아이디"
        $0.textColor = UIColor(hex: "909090")
        $0.font = UIFont(name: "Pretendard-Bold", size: 11)
    }
    
    private let idTextfield = UITextField().then {
        $0.addLeftPadding()
        $0.placeholder = "아이디를 입력해주세요."
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
        $0.textColor = UIColor(hex: "909090")
        $0.backgroundColor = UIColor(hex: "EFEFEF")
        $0.layer.cornerRadius = 11
    }
    
    private let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.textColor = UIColor(hex: "909090")
        $0.font = UIFont(name: "Pretendard-Bold", size: 11)
    }
    
    private let passwordTextfield = UITextField().then {
        $0.addLeftPadding()
        $0.placeholder = "비밀번호를 입력해주세요."
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
        $0.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        $0.textColor = UIColor(hex: "EFEFEF")
        $0.layer.cornerRadius = 11
        $0.isSecureTextEntry = true
    }
    
    private let loginBtn = UIButton().then {
        $0.backgroundColor = UIColor.mainColor
        $0.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 13
    }
    
    private let noAccountAskLabel = UILabel().then {
        $0.text = "계정이 없으신가요?"
        $0.textColor = UIColor.mainBlack
        $0.font = UIFont(name: "Pretendard-Regular", size: 13)
    }
    
    private let moveSignUpBtn = UIButton().then {
        $0.setTitle("회원가입 하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard", size: 13)
        $0.setTitleColor(UIColor(red: 1, green: 0.459, blue: 0.251, alpha: 1), for: .normal)
        $0.setUnderline()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // 뒤로가기 버튼 < 만 출력
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = UIColor.mainBlack
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        navigationController?.navigationBar.tintColor = .black
        setUIView()
        setUIConstraints()
        setKeyboardObserver()
        hideKeyboard()
        
        idTextfield.delegate = self
        passwordTextfield.delegate = self
        
        moveSignUpBtn.addTarget(self, action: #selector(moveSignup), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(loginBtnDidTap), for: .touchUpInside)
        view.endEditing(true)
        
        //로그인VC 접근시 기존 스택VC들 제거
        let endIndex = (self.navigationController?.viewControllers.endIndex)!
        self.navigationController?.viewControllers.removeSubrange(0..<endIndex - 1)
    }
    
    
    
    private func setUIView() {
        self.view.addSubview(logoImage)
        self.view.addSubview(idLabel)
        self.view.addSubview(idTextfield)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(passwordTextfield)
        self.view.addSubview(loginBtn)
        self.view.addSubview(noAccountAskLabel)
        self.view.addSubview(moveSignUpBtn)
    }
    
    private func setUIConstraints() {
        
        logoImage.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().inset(265.12)
            make.centerX.equalToSuperview()
            make.width.equalTo(251.14)
            make.height.equalTo(47.24)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).inset(-113.82)
            make.leading.equalToSuperview().inset(38.5)
            make.width.equalTo(29)
            make.height.equalTo(17)
        }
        
        idTextfield.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).inset(0)
            make.leading.equalToSuperview().inset(26.5)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(idTextfield.snp.bottom).inset(-6)
            make.leading.equalToSuperview().inset(38.5)
            make.width.equalTo(39)
            make.height.equalTo(17)
        }
        
        passwordTextfield.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).inset(-5)
            make.leading.equalToSuperview().inset(26.5)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordTextfield.snp.bottom).inset(-24)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(26.5)
            make.height.equalTo(58)
        }
        
        noAccountAskLabel.snp.makeConstraints { make in
            make.top.equalTo(loginBtn.snp.bottom).inset(-10)
            make.leading.equalToSuperview().inset(97.5)
            make.width.equalTo(100)
            make.height.equalTo(16)
        }
        
        moveSignUpBtn.snp.makeConstraints { make in
            make.top.equalTo(loginBtn.snp.bottom).inset(-10)
            make.leading.equalTo(noAccountAskLabel.snp.trailing).inset(-5)
            make.centerY.equalTo(noAccountAskLabel.snp.centerY)
            make.width.equalTo(71)
            make.height.equalTo(16)
            
        }
        
    }
    
    @objc func moveSignup() {
        let vc = TermsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loginBtnDidTap() {
        let userData = LoginInput(id: idTextfield.text ?? "", pw: passwordTextfield.text ?? "")
        LoginDataManager.posts(self, userData)
    }
    
    
}

//MARK: - 키보드 처리
extension LoginViewController : UITextFieldDelegate {
    // 노티피케이션을 추가하는 메서드
    func setKeyboardObserver() {
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object:nil)
    }
    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyBoardUp == false {
            keyBoardUp = true
            // 키보드의 높이만큼 화면을 올려준다.
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                UIView.animate(withDuration: 1) {
                    self.view.window?.frame.origin.y -= keyboardHeight
                }
            }
        }
        
    }
    
    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(notification: NSNotification) {
        if keyBoardUp == true {
            // 키보드의 높이만큼 화면을 내려준다.
            if self.view.window?.frame.origin.y != 0 {
                keyBoardUp = false
                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRectangle.height
                    UIView.animate(withDuration: 1) {
                        self.view.window?.frame.origin.y += keyboardHeight
                    }
                }
            }
        }
        
    }
    
    // TextField Return 클릭 시
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.idTextfield {
            self.passwordTextfield.becomeFirstResponder()
        } else if textField == self.passwordTextfield {
            self.passwordTextfield.resignFirstResponder()
        }
        return true
    }
}


// MARK: - 카카오 API
//extension LoginViewController {
//
//    // 카카오 로그인 버튼 addTarget에 kakaoLoginButtonClicked() 추가 - []
//    private func kakaoLoginButtonClicked() {
//
//        // 카카오톡 설치 여부 확인
//        if (UserApi.isKakaoTalkLoginAvailable()) {
//            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
//            loginWithApp()
//        } else {
//            // 만약, 카카오톡이 깔려있지 않을 경우에는 웹 브라우저로 카카오 로그인함.
//            loginWithWeb()
//            }
//        }
//
//    private func loginWithWeb() {
//        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
//                if let error = error {
//                    print(error)
//                }
//                else {
//                    print("loginWithKakaoAccount() success.")
//
//                    //do something
//                    _ = oauthToken
//
//                    // 어세스토큰
//                    let accessToken = oauthToken?.accessToken
//                    print("어세스 토큰 정보입니다 !!!!!!!!!\(String(describing: accessToken))")
//
//                    //카카오 로그인을 통해 사용자 토큰을 발급 받은 후 사용자 관리 API 호출
//                    self.setUserInfo()
//                    let vc = TermsViewController()
//                    vc.modalPresentationStyle = .fullScreen
//                    self.present(vc, animated: true)
//                }
//            }
//
//    }
//
//
//    private func loginWithApp() {
//        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//                if let error = error {
//                    print(error)
//                }
//                else {
//                    print("loginWithKakaoTalk() success.")
//
//                    //do something
//                    _ = oauthToken
//
//                    // 어세스토큰
//                    let accessToken = oauthToken?.accessToken
//                    print("어세스 토큰 정보입니다 @@@@@@@@@@@@@@\(String(describing: accessToken))")
//
//                    //카카오 로그인을 통해 사용자 토큰을 발급 받은 후 사용자 관리 API 호출
//                    self.setUserInfo()
//                    let vc = TermsViewController()
//                    vc.modalPresentationStyle = .fullScreen
//                    self.present(vc, animated: true)
//                }
//            }
//    }
//
//    private func setUserInfo() {
//        UserApi.shared.me() {(user, error) in
//            if let error = error {
//                print(error)
//            }
//            else {
//                print("me() success.")
//                //do something
//                _ = user
//                }
//        }
//    }
//
//    private func setUserToken() {
//        // 사용자 액세스 토큰 정보 조회
//        UserApi.shared.accessTokenInfo {(accessTokenInfo, error) in
//            if let error = error {
//                print(error)
//            }
//            else {
//                print("accessTokenInfo() success.")
//
//                //do something
//                _ = accessTokenInfo
//                print("accessToken 정보 : \(accessTokenInfo!)")
//            }
//        }
//    }
//}

#if DEBUG
import SwiftUI
struct LoginViewControllerRepresentable: UIViewControllerRepresentable {
    
func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
}
@available(iOS 13.0.0, *)
func makeUIViewController(context: Context) -> UIViewController{
    LoginViewController()
    }
}
@available(iOS 13.0, *)
struct LoginViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            LoginViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        }
        
    }
} #endif
