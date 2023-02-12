//
//  ProfileEditDataManager.swift
//  My Reform
//
//  Created by 박현준 on 2023/02/12.
//

import Foundation
import Alamofire

struct ProfileEditDataManager {
    
    static var Headers : HTTPHeaders = ["Content-Type" : "application/json"]
    
    
    // 서버에 프로필 수정부분
    static func profileEdit(_ viewController: ProfileEditViewController,_ senderNickname: String ,_ parameter: ProfileInput){
        
        let nickname = senderNickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request("\(Constants.baseURL)/users/\(nickname)/profiles", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: Headers).validate(statusCode: 200..<500).responseDecodable(of: ProfileModel.self) { response in
            switch response.result {
            case .success(let result):
                print("프로필 수정 데이터 전송 성공")
                print(result)
                switch(result.status){
                case 200:
                    viewController.successedEdit()
                case 409:
                    ToastService.shared.showToast("닉네임이 중복되었습니다.")
                case 404:
                    ToastService.shared.showToast("회원정보 수정을 실패하였습니다.")
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
