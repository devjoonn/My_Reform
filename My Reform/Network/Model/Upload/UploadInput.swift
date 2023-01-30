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
    

    init(id: String, categoryId: [Int], title: String, contents: String, price: Int/*, images: [Image]*/) {
        self.user = .init(id: id)
        self.board = .init(categoryId: categoryId, title: title, contents: contents, price: price)
        
    }
    
}

struct UploadImages: Encodable {
    
}

public struct UploadUser: Encodable {
    public var nickname: String
    init(id: String) {
        self.nickname = id
//        self.images = images
    }
}

struct UploadBoard: Encodable {
    var categoryId: [Int]
    var title: String
    var contents: String
    var price: Int
    
    init(categoryId: [Int], title: String, contents: String, price: Int/*, images: [Image]*/) {
        self.categoryId = categoryId
        self.title = title
        self.contents = contents
        self.price = price
//        self.images = images
    }
}





//struct UploadInput: Encodable{
//
//    var user: UploadUser
//    var board: UploadBoard
////    var images: UIImagePickerController?
//
//
//    init(id: String, categoryId: [Int], title: String, contents: String, price: Int/*, images: [Image]*/) {
//        self.nickname = id
//        self.categoryId = categoryId
//        self.title = title
//        self.contents = contents
//        self.price = price
////        self.images = images
//    }
//
//}


