//
//  DeleteInput.swift
//  My Reform
//
//  Created by 박현준 on 2023/02/10.
//

import Foundation

class DeleteInput : Encodable {
    var nickname : String?
    
    init(nickname: String?) {
        self.nickname = nickname
    }
}
