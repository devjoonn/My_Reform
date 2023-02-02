//
//  MessagePostModel.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/03.
//

import Foundation

// 0126 전체 게시물 조회 API 바꿔야함 [x]
struct MessagePostModel : Decodable {
    let status : Int
    let code : String
    let message : String
    let data : [MessagePostData]?
}

struct MessagePostData : Decodable {

}
