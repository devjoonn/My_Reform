//
//  AllPostDataManager.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/19.
//

import Foundation
import Alamofire

class AllPostDataManager {
    
    
    func allPostGet(_ viewController: HomeViewController) {
        
        let url = "\(Constants.baseURL)/boards?size=20"
        
        AF.request(url ,method: .get, parameters: nil).validate().responseDecodable(of: AllPostModel.self) { response in
                switch(response.result) {
                case .success(let result) :
                    print("전체 게시물 서버통신 성공 - \(result)")
                    switch(result.status) {
                    case 200 :
                        guard let data = result.data else { return }
                        viewController.successAllPostModel(result: data)
//                        print("result data count = \(result.data?.count)")
//                        print("print - result data = \(result.data!)")
                    case 404 :
                        print("게시물이 없는 경우입니다 - \(result.message)")
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
