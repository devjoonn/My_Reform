//
//  DeleteModel.swift
//  My Reform
//
//  Created by 박현준 on 2023/02/10.
//

import Foundation

class PostAuthModel : Decodable {
    var status : Int
    var code : String
    var message : String
    var authority : Bool?
}
