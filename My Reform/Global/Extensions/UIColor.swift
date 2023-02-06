//
// UIColor.swift
// My Reform
//
// Created by 박현준 on 2023/01/06.
//
import UIKit
extension UIColor {
    
  static let mainColor = UIColor(
    red: 117/255,
    green: 64/255,
    blue: 255/255,
    alpha: 1
  )
    

  static let grayColor = UIColor(red: 0.567, green: 0.567, blue: 0.567, alpha: 1)
    
  static let mainBlack = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1)
    
    
  public convenience init?(hex: String) {
    let r, g, b, a: CGFloat
    if hex.hasPrefix("#") {
      let start = hex.index(hex.startIndex, offsetBy: 1)
      let hexColor = String(hex[start...])
      if hexColor.count == 8 {
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        if scanner.scanHexInt64(&hexNumber) {
          r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
          g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
          b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
          a = CGFloat(hexNumber & 0x000000ff) / 255
          self.init(red: r, green: g, blue: b, alpha: a)
          return
        }
      }
    }
    return nil
  }
}
