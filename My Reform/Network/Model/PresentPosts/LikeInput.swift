//
//  LikeInput.swift
//  My Reform
//
//  Created by 박현준 on 2023/02/06.
//

import Foundation

struct LikeInput: Encodable{
    var id: String?
    var boardId: Int?
    
    // 회원가입용 생성자
    init(id: String?, boardId: Int?) {
        self.id = id
        self.boardId = boardId
    }
}
