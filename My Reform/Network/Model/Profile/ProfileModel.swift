//
//  ProfileModel.swift
//  My Reform
//
//  Created by 최성우 on 2023/02/02.
//

import Foundation

struct ProfileModel: Decodable {
    let status : Int
    let code : String
    let message : String
    let data : [ProfileData]?
}

struct ProfileData : Decodable {
    let imageUrl : [String]?
    let nickname : String?
    let introduction : String?
}
