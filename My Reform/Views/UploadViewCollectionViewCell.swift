//
//  UploadViewCollectionViewCell.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/01/30.
//

import UIKit

class UploadViewCollectionViewCell: UICollectionViewCell {
    static let id = "MyCell"
    private var uiView = UIView()
    var btn = UIButton()
    private var commonSet = 10
    
    // MARK: Initializer
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var clickCount: Int = 0 {
        didSet {
            if clickCount == 0 {
                self.btn.setTitleColor(UIColor.gray, for: .normal)
                self.btn.layer.borderColor = UIColor.gray.cgColor
            }
            else {
                self.btn.setTitleColor(UIColor.mainColor, for: .normal)
                self.btn.layer.borderColor = UIColor.mainColor.cgColor
            }
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.btn.setTitleColor(UIColor.gray, for: .normal)
        self.btn.layer.borderColor = UIColor.gray.cgColor
        self.prepare(l: "")
    }
    
    func attribute() {
        uiView.layer.borderWidth = 1
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 0.5
    }
    
    func layout() {
        self.contentView.addSubview(self.uiView)
        uiView.snp.makeConstraints{ (make) in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        uiView.addSubview(btn)
        btn.snp.makeConstraints{ (make) in
            make.height.equalTo(29)
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
    }
    
    func prepare(l: String) {
        self.btn.setTitle(l, for: .normal)
    }
    
    func onSelected() {
        self.btn.setTitleColor(UIColor.mainColor, for: .normal)
        self.btn.layer.borderColor = UIColor.mainColor.cgColor
        self.clickCount = 1
    }
    func onDeselected() {
        self.btn.setTitleColor(UIColor.gray, for: .normal)
        self.btn.layer.borderColor = UIColor.gray.cgColor
        self.clickCount = 0
    }
}
