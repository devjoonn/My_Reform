//
//  SignUpDataManager.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/16.
//

import Foundation
import Alamofire

class SignUpDataManager {
    
    static var Headers : HTTPHeaders = ["Content-Type" : "application/json"]

//    // 아이디 중복검사
//    func getsID(_ viewController: SignUpViewController, id: String){
//        AF.request("", method: .get, parameters: ["id":id], encoding: URLEncoding.queryString).validate().responseDecodable(of: SingUpModel.self) { response in
//            print(response)
//            switch response.result {
//            case .success(let result):
//                viewController.checkIdApiResultCode(result.code)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    // 닉네임 중복검사
//    func getNickname(_ viewController: SignUpViewController, nickname: String){
//        AF.request("", method: .get, parameters: ["nickname":nickname], encoding: URLEncoding.queryString).validate().responseDecodable(of: SingUpModel.self) { response in
//            print(response)
//            switch response.result {
//            case .success(let result):
//                viewController.checkNickNameResultCode(result.code)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    
    // 서버에 회원가입 값 전송
    static func posts(_ viewController: SignUpViewController, _ parameter: SignUpInput){
        AF.request("\(Constants.baseURL)/users/new-user", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: Headers).validate(statusCode: 200..<500).responseDecodable(of: SignUpModel.self) { response in
            switch response.result {
            case .success(let result):
                print("회원가입 데이터 전송 성공")
                print(result)
                switch(result.status){
                case 201:
                    let nickname = parameter.nickname
                    let vc = CompleteSignUpViewController()
                    vc.nickname = nickname!
                    viewController.navigationController?.pushViewController(vc, animated: true)
                    ToastService.shared.showToast("회원가입이 완료되었습니다.")
                    return
                case 409:
                    if result.code == "A001" {
                        let alert = UIAlertController()
                        alert.title = "회원가입 실패"
                        alert.message = "중복된 ID 입니다.."
                        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(alertAction)
                        viewController.present(alert, animated: true, completion: nil)
                        alert.modalPresentationStyle = .overFullScreen
                        return
                    } else if result.code == "A002" {
                        let alert = UIAlertController()
                        alert.title = "회원가입 실패"
                        alert.message = "중복된 닉네임 입니다.."
                        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
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
                print("회원가입 데이터 전송 실패")
                print(error.localizedDescription)
                print(response.error ?? "")
            }
        }
    }
    

}
