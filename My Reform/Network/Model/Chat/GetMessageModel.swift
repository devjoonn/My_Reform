//
//  GetMessageModel.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/13.
//

import Foundation
struct GetMessageModel : Codable {
    var status : Int
    var code : String
    var message : String
    var messages : [GetMessageData]?
}

struct GetMessageData : Codable {
    var createAt : String?
    var updateAt : String?
    var status : Int?
    var messageId : Int?
    var chatroomId : Int?
    var type : String?
    var userId : String?
    var message : String?
}
