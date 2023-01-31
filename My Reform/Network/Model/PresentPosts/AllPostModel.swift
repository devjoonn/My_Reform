//
//  AllPostModel.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/19.
//

import Foundation


// 0126 전체 게시물 조회 API 바꿔야함 [x]
struct AllPostModel : Decodable {
    let status : Int
    let code : String
    let message : String
    let data : [AllPostData]?
}

struct AllPostData : Decodable {
    let boardId : Int?
    let categoryId : [Int]?
    let title : String?
    let contents : String?
    let time : String?
    let updateAt : String?
    let price : Int?
    let nickname : String?
    let imageUrl : [String]?
}
