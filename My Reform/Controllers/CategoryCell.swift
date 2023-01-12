//
//  CategoryCell.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/01/12.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    func setupView() {
//        backgroundColor = .systemGroupedBackground
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
    
}
