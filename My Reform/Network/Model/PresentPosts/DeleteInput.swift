//
//  DeleteInput.swift
//  My Reform
//
//  Created by 박현준 on 2023/02/10.
//

import Foundation

class DeleteInput : Encodable {
    var id : String?
    
    init(id: String?) {
        self.id = id
    }
}
