//
//  UploadInput.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/01/27.
//

import Foundation
import SwiftUI

struct UploadInput: Encodable{
    
    var id: String?
    var categoryId: [Int]?
    var title: String?
    var contents: String?
    var price: Int?
    

    init(id: String, categoryId: [Int], title: String, contents: String, price: Int/*, images: [Image]*/) {
        self.id = id
        self.categoryId = categoryId
        self.title = title
        self.contents = contents
        self.price = price
//        self.images = images
    }
    
}
