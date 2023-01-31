//
//  CategoryPostModel.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/29.
//

import Foundation

struct CategoryPostModel : Decodable{
    let status : Int
    let code : String
    let message : String
    let data : [CategoryPostData]?
}

struct CategoryPostData : Decodable {
    let boardId : Int?
    let categoryId : Int?
    let title : String?
    let contents : String?
    let updateAt : String?
    let price : Int?
    let nickname : String?
    let imageUrl : [String]?
}
