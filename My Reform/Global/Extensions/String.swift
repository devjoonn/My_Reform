//
//  String.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/20.
//

import Foundation

//정규 표현식
extension String{
    
    //영문, 숫자 포함 8자리 이상
    func isValidPassword() -> Bool{
        let regularExpression = "[A-Za-z0-9!_@$%^&+=]{8,20}"        // "^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}"
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        
        return passwordValidation.evaluate(with: self)
    }
    
    //제약 없음
    func isValidEmail() -> Bool{
        let emailRegEx = "[A-Za-z0-9]{3,}"
        //"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        //"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    //6자 이상, 12자 이하
    func isValidId() -> Bool{
        let nameRegEx = "[A-Za-z0-9]{6,12}"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    //1자 이상, 10자 이하
    func isValidNickname() -> Bool{
        let nicknameRegEx = "^[가-힣A-Za-z0-9]{1,10}"
        let nicknameTest = NSPredicate(format: "SELF MATCHES %@", nicknameRegEx)
        return nicknameTest.evaluate(with: self)
    }
}
