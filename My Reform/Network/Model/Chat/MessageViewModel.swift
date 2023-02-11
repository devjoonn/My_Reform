//
//  MessageViewModel.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/09.
//

import Foundation


// 채팅방 리스트 모델
struct MessageViewModel : Decodable {
    var status : Int
    var code : String
    var message : String
    var rooms : [MessageViewData]?
}

struct MessageViewData : Decodable {
    var chatroomId : Int?
    var ownerNickname : String?
    var senderNickname : String?
    var boardTitle : String?
    var boardId : Int?
    var lastMessage : String?
    // 최근 메시지 추가
    // 시간 추가
    // 해당 board의 imageUrl
    // 해당 board의 price
//    var time : String?
}
