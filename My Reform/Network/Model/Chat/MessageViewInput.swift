//
//  MessageViewInput.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/09.
//

import Foundation


// 채팅방 리스트 조회
struct MessageViewInput : Encodable{
    var userId : String
    
    init(userId: String) {
        self.userId = userId
    }
}
