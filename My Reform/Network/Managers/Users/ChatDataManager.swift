//
//  ChatDataManager.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/08.
//

import Foundation
import Alamofire

class ChatDataManager {
    
    static var Headers : HTTPHeaders = ["Content-Type" : "application/json"]
    
    
    // 서버에 회원가입 값 전송
    static func posts(_ viewController: ChatViewController, _ parameter: ChatInput){
        AF.request("\(Constants.baseURL)/chats/create", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: Headers).validate(statusCode: 200..<500).responseDecodable(of: ChatModel.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let result):
//                print("보낸 값: senderNickname -> \(parameter.senderNickname), boardId -> \(parameter.boardId)")
                print("Chat 데이터 전송 성공")
                print(result)
                switch(result.status){
                case 200:
                    print("Chat 서버 연결 성공")
//                    viewController.navigationItem.title = result.data?.ownder
                    
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
