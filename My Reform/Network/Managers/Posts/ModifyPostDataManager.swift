//
//  ModifyPostDataManager.swift
//  My Reform
//
//  Created by 박현준 on 2023/02/06.
//

import Foundation
import Alamofire

class ModifyPostDataManager {
    
    static var Headers : HTTPHeaders = ["Content-Type" : "multipart/form-data"]
    
    // 서버에 게시물 수정 데이터 전송
    static func Modifyposts(_ viewController: ModifyViewController,_ parameter: UploadInput ,_ images: [UIImage], _ boardId: Int) {
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            let saveObj : [String : Any] = [
                "nickname" : parameter.nickname,
                "categoryId" : parameter.categoryId,
                "title" : parameter.title,
                "contents" : parameter.contents,
                "price" : parameter.price
            ]
            
            //image
            for i in 0 ..< images.count {
                if let image = images[i].pngData() {
                    multipartFormData.append(image, withName: "file", fileName: "\(image).jpg", mimeType: "image/jpg")
                }
            }
            
            // json
            var valueJson = ""
            do {
                let jsonCreate = try JSONSerialization.data(withJSONObject: saveObj, options: .prettyPrinted)

                // json 데이터를 변수에 삽입 실시
                valueJson = String(data: jsonCreate, encoding: .utf8) ?? ""
            } catch {
                print(error.localizedDescription)
            }
            print("[create json data]")
            print("jsonObj : " , valueJson)


            print(valueJson)
            multipartFormData.append("\(valueJson)".data(using: .utf8)!, withName: "saveObj", mimeType: "application/json")
            
            
            // 원래는 .patch 이지만 api상 post로 지워짐
        }, to: "\(Constants.baseURL)/boards/\(boardId)", usingThreshold: UInt64.init(), method: .post, headers: Headers).validate(statusCode: 200..<500).responseDecodable(of: CUDModel.self)
        { response in
            switch response.result {
            case .success(let result) :
                switch result.status {
                case 200 :
                    viewController.successedModify()
                    print("게시물 수정 데이터 전송 성공")
                case 403 :
                    ToastService.shared.showToast("게시물을 변경할 수 있는 권한이 없습니다.")
                    print("게시물을 변경할 수 있는 권한이 없습니다.")
                default:
                    print("데이터 베이스 오류: " + (result.message ?? ""))
                }
            case .failure(let error) :
                print("게시물 등록 실패: \(error)")
            }
        }
    }
}
