//
//  LikePostSendDataManager.swift
//  My Reform
//
//  Created by 박현준 on 2023/02/06.
//

import Foundation
import Alamofire

class LikePostSendDataManager {
    
    static var Headers : HTTPHeaders = ["Content-Type" : "application/json"]

    // 서버에 좋아요 값 전송
    static func like(_ viewController: DetailPostViewController, _ parameter: LikeInput){
        
        guard let OptionalNickname = parameter.nickname else {return}
        let nickname = OptionalNickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let boardId = parameter.boardId else {return}
        
        let url = "\(Constants.baseURL)/likes/add?boardId=\(String(describing: boardId))&token=\(String(describing: nickname))"
        print("like url - \(url)")
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: Headers).validate(statusCode: 200..<500).responseDecodable(of: LikeModel.self) { response in
            switch response.result {
            case .success(let result):
                print("게시물 좋아요 데이터 전송 성공")
                print(result)
                switch(result.status){
                case 200:
                    viewController.successedLike(result.countOfLike)
                case 409:
                    ToastService.shared.showToast("좋아요 실패")
                    print("좋아요 실패")
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
                print("좋아요 데이터 전송 실패")
                print(error.localizedDescription)
                print(response.error ?? "")
            }
        }
    }
    
    // 서버에 좋아요 값 전송
    static func unLike(_ viewController: DetailPostViewController, _ parameter: LikeInput){
        
        guard let OptionalNickname = parameter.nickname else {return}
        let nickname = OptionalNickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let boardId = parameter.boardId else {return}
        
        let url = "\(Constants.baseURL)/likes/remove?boardId=\(String(describing: boardId))&token=\(String(describing: nickname))"
        print("like url - \(url)")
        
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: Headers).validate(statusCode: 200..<500).responseDecodable(of: LikeModel.self) { response in
            switch response.result {
            case .success(let result):
                print("게시물 좋아요 취소 데이터 전송 성공")
                print(result)
                switch(result.status){
                case 200:
                    viewController.successedUnLike(result.countOfLike)
                case 404:
                    ToastService.shared.showToast("좋아요 제거 실패")
                    print("좋아요 제거 실패")
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
                print("좋아요 데이터 전송 실패")
                print(error.localizedDescription)
                print(response.error ?? "")
            }
        }
    }
}

