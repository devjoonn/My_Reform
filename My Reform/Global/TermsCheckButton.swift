//
//  TermsCheckButton.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/09.
//

import UIKit

class TermsCheckButton: UIButton {
    
    /// 체크 상태 변경
    var isChecked: Bool = false {
        didSet {
            guard isChecked != oldValue else { return }
            self.setChecked(isChecked)
        }
    }
    
    // 체크상태 확인하고 색상 변경
    private func setChecked(_ isChecked: Bool) {
        if isChecked == true {
            self.backgroundColor = UIColor.mainColor
        } else {
            self.backgroundColor = .systemGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func commonInit() {
        self.addTarget(self, action: #selector(check), for: .touchUpInside)
        self.isChecked = false
    }
    
    @objc func check(_ sender: UIGestureRecognizer) {
            isChecked.toggle()
    }
}
