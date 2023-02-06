//
//  LikeInput.swift
//  My Reform
//
//  Created by 박현준 on 2023/02/06.
//

import Foundation

struct LikeInput: Encodable{
    var nickname: String?
    var boardId: Int?
    
    // 회원가입용 생성자
    init(nickname: String?, boardId: Int?) {
        self.nickname = nickname
        self.boardId = boardId
    }
}
