//
//  UploadDataManager.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/01/27.
//

import Foundation
import Alamofire

class UploadDataManager{
    
    static var Headers : HTTPHeaders = ["Content-Type" : "multipart/form-data"]
    
    // 서버에 게시물 전송
    static func posts(_ viewController: UploadViewController, _ parameter: UploadInput, images: [UIImage]) {
        AF.upload(multipartFormData: { (multipartFormData) in
            
            let saveObj: [String : Any] = [
                "nickname": parameter.user.nickname,
                "categoryId": parameter.board.categoryId,
                "title": parameter.board.title,
                "contents": parameter.board.contents,
                "price": parameter.board.price
            ]
            
            for i in 0 ..< images.count {
                if let image = images[i].pngData() {
                    multipartFormData.append(image, withName: "post-img", fileName: "\(image).jpg", mimeType: "image/jpg")
                }
            }
            
            for (key, value) in saveObj {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                //이미지 데이터 외에 같이 전달할 데이터
            }
        }, to: "\(Constants.baseURL)/boards/create", usingThreshold: UInt64.init(), method: .post, headers: Headers).validate(statusCode: 200 ..< 500).responseDecodable(of: UploadModel.self)
        { response in
            print("response ----------------- \(response)")
            switch response.result {
            case .success(let result) :
                switch result.status {
                case 200 :
                    print("등록 성공")
                default:
                    print("데이터 베이스 오류: " + result.message)
                }
            case .failure(let error) :
                print(error)
                print("게시물 등록 실패: " + error.localizedDescription)
            }
        }
        
    }
    
   
}
