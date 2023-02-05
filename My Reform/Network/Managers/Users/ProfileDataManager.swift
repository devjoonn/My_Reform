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
    
    static func posts(_ viewController: ProfileEditViewController, _ parameter: ProfileInput){
        AF.request("\(Constants.baseURL)", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: Headers).validate(statusCode: 200..<500).responseDecodable(of: ProfileModel.self) { response in
            switch response.result {
            case .success(let result):
                print("회원가입 데이터 전송 성공")
                print(result)
                switch(result.status){
                case 200:
                    return
                case 404:
                    return
                case 409:
                    return
                default:
                    return
                }
            case .failure(let error):
                print("수정된 프로필 데이터 전송 실패")
                print(error.localizedDescription)
                print(response.error ?? "")
            }
        }
    }
}
