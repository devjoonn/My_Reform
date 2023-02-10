//
//  PostAuthCheckDataManager.swift
//  My Reform
//
//  Created by 박현준 on 2023/02/10.
//

import Foundation
import Alamofire

class PostAuthCheckDataManager {
    
    static var Headers : HTTPHeaders = ["Content-Type" : "application/json"]
    
    // 서버에 좋아요 값 전송
    static func AuthCheck(_ viewController: DetailPostViewController, _ parameter: LikeInput){
        
        guard let OptionalNickname = parameter.nickname else {return}
        let nickname = OptionalNickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let boardId = parameter.boardId else {return}
        
        let url = "\(Constants.baseURL)/boards/\(String(describing: boardId))/\(String(describing: nickname))"
        print("auth check url - \(url)")
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: Headers).validate(statusCode: 200..<500).responseDecodable(of: PostAuthModel.self) { response in
            switch response.result {
            case .success(let result):
                print("게시물 권한 확인 데이터 전송 성공")
                print(result)
                switch(result.status){
                case 200:
                    viewController.successedCheckAuth(result.authority!)
                case 404:
                    ToastService.shared.showToast("게시물에 대한 권한이 없습니다.")
                    print("해당유저 게시물 수정삭제 권한 없음.")
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
                print("게시물 권환 확인 데이터 전송 실패")
                print(error.localizedDescription)
                print(response.error ?? "")
            }
        }
    }
}
