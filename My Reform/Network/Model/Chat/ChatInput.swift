//
//  ChatInput.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/08.
//

import Foundation

struct ChatInput: Encodable{
    var senderNickname: String
    var boardId: Int
    
    // 회원가입용 생성자
    init(senderNickname: String, boardId: Int) {
        self.senderNickname = senderNickname
        self.boardId = boardId
    }
}
