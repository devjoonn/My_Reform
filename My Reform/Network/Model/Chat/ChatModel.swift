//
//  ChatModel.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/08.
//

import Foundation

struct ChatModel : Decodable {
    var status : Int
    var code : String?
    var message : String?
    var data : ChatData?
}

//struct ChatData : Decodable {
//    var chatroomId : Int?
//    var ownerNickname : String?
//    var senderNickname : String?
//    var boardTitle : String?
//    var ownerId : Int?
//    var senderId : Int?
//    var boardId : Int?
//}

struct ChatData : Decodable {
    var createAt : String?
    var updateAt : String?
    var status : Int?
    var chatrommId : Int?
    var ownderUserId : String?
    var senderUserId : String?
    var boardTitle : String?
    var boardId : Int?
    var messages : [String?]
}
