//
//  DetailPostImageCollectionViewCell.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/30.
//

import UIKit
import SnapKit
import Then


class DetailPostImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DetailPostImageCollectionViewCell"
    
    let postImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(postImageView)
        
        postImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = contentView.bounds
    }
    
    // 셀이보여지면 이 함수가 호출됨
    public func configure(with imageUrl: String) {
        print("configure 호출 ")
        guard let url = URL(string: "\(Constants.baseURL)\(imageUrl)") else { return }
        postImageView.sd_setImage(with: url, completed: nil)
    }
}
