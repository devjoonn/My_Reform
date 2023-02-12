//
//  ProfileInput.swift
//  My Reform
//
//  Created by 최성우 on 2023/02/02.
//

import Foundation

struct ProfileInput: Encodable{
    
    var nickname: String?
    var introduction: String?
    
    //nickname 유효성 검사용 생성자
    init(nickname: String?, introduction: String?) {
        self.nickname = nickname
        self.introduction = introduction
    }
    
}
