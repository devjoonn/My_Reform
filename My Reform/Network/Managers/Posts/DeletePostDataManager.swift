//
//  DeletePostDataManager.swift
//  My Reform
//
//  Created by 박현준 on 2023/02/06.
//

import Foundation
import Alamofire

class DeletePostDataManager {
    
    //서버에서 게시물 삭제
    static func deletePosts(_ viewController: DetailPostViewController,_ parameter: String,_ boardId: Int) {
        
        let url = "\(Constants.baseURL)boards/\(boardId)"
        
        let nicknameParameters = parameter.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request(url ,method: .delete, parameters: nicknameParameters).validate().responseDecodable(of: CUDModel.self) { response in
            switch(response.result) {
            case .success(let result) :
                print("게시물 삭제 서버통신 성공 - \(result)")
                switch(result.status) {
                case 200 :
                    viewController.successedDelete()
                    print("게시물 삭제 완료")
                case 404 :
                    ToastService.shared.showToast("게시물이 삭제되었습니다.")
                    print("게시물이 없는 경우 - \(result.message)")
                case 403 :
                    ToastService.shared.showToast("게시물을 삭제할 수 있는 권한이 없습니다.")
                    print("게시물을 삭제할 수 있는 권한이 없음 - \(result.message)")
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
