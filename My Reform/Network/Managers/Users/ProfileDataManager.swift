//
//  ProfileDataManager.swift
//  My Reform
//
//  Created by 최성우 on 2023/02/02.
//
//  프로필 수정

import Foundation
import Alamofire

class ProfileDataManager {
    
    static var Headers : HTTPHeaders = ["Content-Type" : "application/json"]
    
    static func profileGet(_ viewController: ProfileViewController,_ senderNickname: String){
        let url = "\(Constants.baseURL)/users/\(senderNickname)/profiles"
        
        print("profileGet URL - \(url)")
        let encodeUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        AF.request(encodeUrl ,method: .get, parameters: nil).validate().responseDecodable(of: ProfileLookupModel.self) { response in switch(response.result) {
                case .success(let result) :
                    print("프로필 서버통신 성공 - \(result)")
                    switch(result.status) {
                    case 200 :
                        guard let data = result.data else { return }
                        print("data!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\(data)")
                        viewController.successProfileModel(result: data)
                    case 404 :
                        print("프로필이 없는 경우입니다 - \(result.message)")
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
                    
                case .failure(let error) :
                    print(error)
                    print(error.localizedDescription)
                }
            }
    }
}
