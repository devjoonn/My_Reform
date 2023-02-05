//
//  ProfileInput.swift
//  My Reform
//
//  Created by 최성우 on 2023/02/02.
//

import Foundation

struct ProfileInput: Encodable{
    
    var email: String?
    var pw: String?
    var nickname: String?
    var introduction: String?
    
    //nickname 유효성 검사용 생성자
    init(email: String? = nil, pw: String? = nil, nickname: String? = nil, introduction: String? = nil) {
        self.email = email
        self.pw = pw
        self.nickname = nickname
        self.introduction = introduction
    }
    
}
