//
//  SocketDataManager.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/09.
//

import Foundation
import Alamofire

class SocketDataManager {
    
    static var Headers : HTTPHeaders = ["Content-Type" : "application/json"]
    
    
    // 서버에 회원가입 값 전송
    static func posts(_ viewController: ChatViewController, _ parameter: SocketInput){
        AF.request("ws://211.176.69.65:8080/ws/chat", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: Headers).validate(statusCode: 0..<500).responseDecodable(of: SocketModel.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let result):
                
                print("socket 데이터 전송")
                print(result)
                switch(result.status){
                case 1:
                    print("socket 서버 연결 성공")
                    return
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
                print("채팅 데이터 전송 실패")
                print(error.localizedDescription)
                print(response.error ?? "")
            }
        }
    }
    

}
