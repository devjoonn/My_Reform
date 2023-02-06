//
//  LoginDataManager.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/16.
//

import Foundation
import Alamofire

class LoginDataManager {
    
    static var Headers : HTTPHeaders = ["Content-Type" : "application/json"]
    
    // 서버에 회원가입 값 전송
    static func posts(_ viewController: LoginViewController, _ parameter: LoginInput){
        AF.request("\(Constants.baseURL)/users", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: Headers).validate(statusCode: 200..<500).responseDecodable(of: LoginModel.self) { response in
            switch response.result {
            case .success(let result):
                print("로그인 데이터 전송 성공")
                print(result)
                switch(result.status) {
                case 200:
//                    UserDefaults.standard.set(result.result?.token?.accessToken, forKey: "accessToken")
                    guard let nicknameToken = result.token else { return }
                    
                    UserDefaults.standard.set("\(String(describing: nicknameToken))", forKey: "senderNickname")
                    print("UserDefault에 저장되는 userNickname - \(String(describing: result.token))")
                    print("로그인 성공")
                    viewController.navigationController?.pushViewController(MainTabBarViewController(), animated: true)
                    viewController.navigationController?.isNavigationBarHidden = true
                    ToastService.shared.showToast("로그인이 완료되었습니다.")
                    return
                case 404:
                    if result.code == "B001" {
                        let alert = UIAlertController()
                        alert.title = "로그인 실패"
                        alert.message = "id를 다시 한 번 확인해주세요."
                        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alertAction.titleTextColor = .black
                        alert.addAction(alertAction)
                        viewController.present(alert, animated: true, completion: nil)
                        alert.modalPresentationStyle = .overFullScreen
                        return
                    } else if result.code == "B002" {
                        let alert = UIAlertController()
                        alert.title = "로그인 실패"
                        alert.message = "비밀번호를 다시 한 번 확인해주세요."
                        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alertAction.titleTextColor = .black
                        alert.addAction(alertAction)
                        viewController.present(alert, animated: true, completion: nil)
                        alert.modalPresentationStyle = .overFullScreen
                        return
                    }
                default:
                    print("데이터베이스 오류")
                    let alert = UIAlertController()
                    alert.title = "서버 오류"
                    alert.message = "서버에서 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
                    let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(alertAction)
                    viewController.present(alert, animated: true, completion: nil)
                    return
                }
            case .failure(let error):
                print("로그인 데이터 전송 실패")
                print(error.localizedDescription)
                print(response.error ?? "")
            }
        }
    }
}
