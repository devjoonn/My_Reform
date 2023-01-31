//
//  UITextfield.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/17.
//

import UIKit

extension UITextField {
    
    // 텍스트 필드 값의 왼쪽부분에 공백 넣기
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addLeftPaddingMulty() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func signUpViewAddLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
}
