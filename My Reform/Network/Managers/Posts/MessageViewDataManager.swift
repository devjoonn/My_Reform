//
//  MessageViewDataManager.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/09.
//

import Foundation
import Alamofire

class MessageViewDataManager {
    
    static var Headers : HTTPHeaders = ["Content-Type" : "application/json"]
    
    
    // 서버에 회원가입 값 전송
    func ChatListGet(_ viewController: MessageViewController, _ parameter: MessageViewInput) {
        
        let url = "\(Constants.baseURL)/chats"
        
        AF.request(url ,method: .post, parameters: parameter,encoder: JSONParameterEncoder.default, headers:  MessageViewDataManager.Headers).validate(statusCode: 200..<500).responseDecodable(of: MessageViewModel.self) { response in
                debugPrint(response)
                switch(response.result) {
                case .success(let result) :
//                    print("전체 게시물 서버통신 성공 - \(result)")
                    switch(result.status) {
                    case 200 :
                        guard let data = result.rooms else { return }
                        viewController.successAllPostModel(result: data)
                    
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

//
//class MessageViewDataManager {
//
//
//    func allPostGet(_ viewController: MessageViewController, parameter: MessageViewInput) {
//
//        let url = "\(Constants.baseURL)/chats"
//
//        AF.request(url ,method: .get, parameters: parameter).validate().responseDecodable(of: MesviewMo.self) { response in
//                switch(response.result) {
//                case .success(let result) :
////                    print("전체 게시물 서버통신 성공 - \(result)")
//                    switch(result.status) {
//                    case 200 :
//                        print("연결 성공")
////                        guard let data = result.data else { return }
////                        viewController.successAllPostModel(result: data)
////                        print("result data count = \(result.data?.count)")
////                        print("print - result data = \(result.data!)")
//                    case 404 :
//                        print("게시물이 없는 경우입니다 - \(result.message)")
//                    default:
//                        print("데이터베이스 오류")
//                        let alert = UIAlertController()
//                        alert.title = "서버 오류"
//                        alert.message = "서버에서 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
//                        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
//                        alert.addAction(alertAction)
//                        viewController.present(alert, animated: true, completion: nil)
//                        return
//                    }
//
//                case .failure(let error) :
//                    print(error)
//                    print(error.localizedDescription)
//
//                }
//            }
//    }
//}
