//
//  UploadDataManager.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/01/27.
//

import Foundation
import Alamofire

class UploadDataManager{
    
    static var Headers : HTTPHeaders = ["Content-Type" : "multipart/form-data"
                                        ]
    
    // 서버에 게시물 전송
    static func posts(_ viewController: UploadViewController,_ parameter: UploadInput ,images: [UIImage]) {
        
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
            
            
        }, to: "\(Constants.baseURL)/boards/create", usingThreshold: UInt64.init(), method: .post, headers: Headers).validate(statusCode: 200..<500).responseDecodable(of: UploadModel.self)
        { response in
            print("response ------- \(response)")
            print("response.result ------- \(response.result)")
            switch response.result {
            case .success(let result) :
                switch result.status {
                case 200 :
                    print("게시물 전송 성공")
                    viewController.successPost()
                default:
                    print("데이터 베이스 오류: " + result.message)
                }
            case .failure(let error) :
                print("게시물 등록 실패: \(error)")
            }
        }
    }
    
    
    //서버에 게시물 수정
    static func modifyPosts(_ viewController: UploadViewController,_ parameter: UploadInput ,images: [UIImage]) {
        
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
            
            
        }, to: "\(Constants.baseURL)/boards/create", usingThreshold: UInt64.init(), method: .patch, headers: Headers).validate(statusCode: 200..<500).responseDecodable(of: UploadModel.self)
        { response in
            print("response ------- \(response)")
            print("response.result ------- \(response.result)")
            switch response.result {
            case .success(let result) :
                switch result.status {
                case 200 :
                    print("게시물 전송 성공")
                    viewController.successPost()
                default:
                    print("데이터 베이스 오류: " + result.message)
                }
            case .failure(let error) :
                print("게시물 등록 실패: \(error)")
            }
        }
    }
    
    //서버에서 게시물 삭제
    static func deletePosts(_ viewController: UploadViewController,_ parameter: UploadInput ,images: [UIImage]) {
        
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
            
            
        }, to: "\(Constants.baseURL)/boards/create", usingThreshold: UInt64.init(), method: .delete, headers: Headers).validate(statusCode: 200..<500).responseDecodable(of: UploadModel.self)
        { response in
            print("response ------- \(response)")
            print("response.result ------- \(response.result)")
            switch response.result {
            case .success(let result) :
                switch result.status {
                case 200 :
                    print("게시물 전송 성공")
                    viewController.successPost()
                default:
                    print("데이터 베이스 오류: " + result.message)
                }
            case .failure(let error) :
                print("게시물 등록 실패: \(error)")
            }
        }
    }
}

