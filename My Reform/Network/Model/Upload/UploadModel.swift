//
//  Upload.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/01/30.
//

import Foundation

struct UploadModel : Decodable {
    var status : Int
    var code : String?
    var message : String
    let data : [UploadPostData]?
}

struct UploadPostData : Decodable {
    let boardId : Int?
    let userId : Int?
    let nickname : String?
    let categoryId : [Int]?
    let title : String?
    let contents : String?
    let updateAt : String?
    let price : Int?
    let images : [String]?
}

