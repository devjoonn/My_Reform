//
//  MessageViewTableViewCell.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/03.
//

import UIKit
import SnapKit
import Then
import SDWebImage

class MessageViewTableViewCell: UITableViewCell {
    
    static let identifier = "MessageViewTableViewCell"
    
    var titleCellLabel = UILabel().then {
        $0.text = "이름"
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    
    var titleCellImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
    }
    
    var minuteCellLabel = UILabel().then {
        $0.text = "10분 전"
        $0.textColor = .systemGray
        $0.font = UIFont(name: "Pretendard-Regular", size: 11)
    }
    
    var recentChat = UILabel().then {
        $0.text = "안사요"
        $0.font = UIFont(name: "Pretendard-Bold", size: 16)
    }
    
    var name = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = .systemGray
        $0.font = UIFont(name: "Pretendard-Regular", size: 11)
    }


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleCellImageView)
        contentView.addSubview(titleCellLabel)
//        contentView.addSubview(heartButton)
        contentView.addSubview(minuteCellLabel)
        contentView.addSubview(recentChat)
        contentView.addSubview(name)
        
        setUIConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
   
    
    func setUIConstraints() {

        titleCellImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(15)
            make.leading.equalTo(contentView.snp.leading).inset(15)
            make.bottom.equalTo(contentView.snp.bottom).inset(-15)
            make.width.equalTo(110)
        }
        
        titleCellLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleCellImageView.snp.trailing).inset(-15)
            make.top.equalTo(contentView.snp.top).inset(27)
        }
        
        minuteCellLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleCellImageView.snp.trailing).inset(-15)
            make.bottom.equalTo(recentChat.snp.top).inset(-5)
        }
        
        recentChat.snp.makeConstraints { make in
            make.leading.equalTo(titleCellImageView.snp.trailing).inset(-15)
            make.bottom.equalTo(contentView.snp.bottom).inset(23)
        }
        
        
    }
    
    
    
    //ViewModel 에서 포스터 URL값과 포스터 이름을 불러옴
//    public func configure(with model: HomeFeedViewModel) {
//        guard let url = URL(string:"\(Constants.baseURL)\(model.imageUrl)") else { return }
//        print(url)
//        titleCellImageView.sd_setImage(with:url, completed: nil)
//        titleCellLabel.text = model.title
//        minuteCellLabel.text = model.minute
//        let commaPrice = numberFormatter(number: model.price)
//        recentChat.text = String("\(commaPrice) 원")
//        
//    }

}
