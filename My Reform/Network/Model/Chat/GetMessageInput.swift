//
//  MessageGetInput.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/13.
//

import Foundation

struct GetMessageInput: Codable {
    var chatroomId : Int?
        
    init(chatroomId: Int) {
        self.chatroomId = chatroomId
    }
}
