//
//  ProfileModel.swift
//  My Reform
//
//  Created by 최성우 on 2023/02/02.
//
//  프로필 수정

import Foundation

struct ProfileModel: Decodable {
    let status : Int
    let code : String
    let message : String
}
