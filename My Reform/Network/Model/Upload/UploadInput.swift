//
//  UploadInput.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/01/27.
//

import Foundation
import SwiftUI


import Foundation

struct UploadInput: Encodable{
//    var value: UploadImages
    var user: UploadUser
    var board: UploadBoard
//    var images: UIImagePickerController?
    

    init(nickname: String, categoryId: [Int], title: String, contents: String, price: Int) {
        self.user = .init(nickname: nickname)
        self.board = .init(categoryId: categoryId, title: title, contents: contents, price: price)
        
    }
    
}

public struct UploadUser: Encodable {
    public var nickname: String
    init(nickname: String) {
        self.nickname = nickname
    }
}

struct UploadBoard: Encodable {
    var categoryId: [Int]
    var title: String
    var contents: String
    var price: Int
    
    init(categoryId: [Int], title: String, contents: String, price: Int) {
        self.categoryId = categoryId
        self.title = title
        self.contents = contents
        self.price = price
    }
}
