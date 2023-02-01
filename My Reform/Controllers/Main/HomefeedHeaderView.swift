//
//  HomefeedHeaderView.swift
//  My Reform
//
//  Created by 최성우 on 2023/01/28.
//

import UIKit
import SnapKit
import Then

class HomefeedHeaderView: UITableViewHeaderFooterView {

    let titleView: UILabel = UILabel().then {
        $0.text = "  업로드한 리폼"
        $0.font = UIFont(name: "Pretendard-Bold", size: 16)
        $0.textColor = UIColor.mainBlack
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.addSubview(titleView)
        
        titleView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
