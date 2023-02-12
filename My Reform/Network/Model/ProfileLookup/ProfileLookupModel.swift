//
//  ProfileLookupModel.swift
//  My Reform
//
//  Created by 최성우 on 2023/02/03.
//

import Foundation

struct ProfileLookupModel : Decodable {
    let status : Int
    let code : String
    let message : String
    let data : ProfileLookupData?
}

struct ProfileLookupData : Decodable {
    let email : String?
    let id : String?
    let nickname : String?
    let introduction : String?
    let likeBoards : [AllPostData]?
}

