//
//  UIAlertAction.swift
//  My Reform
//
//  Created by 박현준 on 2023/02/04.
//

import UIKit

extension UIAlertAction {
    var titleTextColor: UIColor? {
        get {
            return self.value(forKey: "titleTextColor") as? UIColor
        } set {
            self.setValue(newValue, forKey: "titleTextColor")
        }
    }
}
