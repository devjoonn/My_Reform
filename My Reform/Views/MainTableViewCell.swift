//
//  MainTableViewCell.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/12.
//

import UIKit
import SnapKit
import Then
import SDWebImage



class MainTableViewCell: UITableViewCell {

    
    static let identifier = "MainTableViewCell"
    
    
//    var heartButton = UIButton().then {
//        $0.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
//        $0.tintColor = .systemGray
//    }
    
    
    var titleCellLabel = UILabel().then {
        $0.text = "이름"
        $0.font = UIFont(name: "Avenir-Black", size: 18)
    }
    
    
    var titleCellImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    var minuteCellLabel = UILabel().then {
        $0.text = "10분 전"
        $0.font = UIFont(name: "Avenir-Black", size: 10)
    }
    
    var priceCellLabel = UILabel().then {
        $0.text = "30,000 원"
        $0.font = UIFont(name: "Avenir-Black", size: 18)
    }


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleCellImageView)
        contentView.addSubview(titleCellLabel)
//        contentView.addSubview(heartButton)
        contentView.addSubview(minuteCellLabel)
        contentView.addSubview(priceCellLabel)
        
        setUIConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
   
    
    func setUIConstraints() {

        titleCellImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(10)
            make.leading.equalTo(contentView.snp.leading).inset(10)
            make.bottom.equalTo(contentView.snp.bottom).inset(-10)
            make.width.equalTo(100)
        }
        
        titleCellLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleCellImageView.snp.trailing).inset(-20)
            make.top.equalTo(contentView.snp.top).inset(10)
        }
        
        minuteCellLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleCellImageView.snp.trailing).inset(-20)
            make.bottom.equalTo(priceCellLabel.snp.top).inset(-8)
        }
        
        priceCellLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleCellImageView.snp.trailing).inset(-20)
            make.bottom.equalTo(contentView.snp.bottom).inset(13)
        }
        
//        heartButton.snp.makeConstraints { make in
//            make.trailing.equalTo(contentView.snp.trailing).inset(20)
        //            make.centerY.equalTo(priceCellLabel.snp.centerY)
        //            make.width.height.equalTo(40)
        //        }
        
    }
    
    
    
    //ViewModel 에서 포스터 URL값과 포스터 이름을 불러옴
    public func configure(with model: HomeFeedViewModel) {
        guard let url = URL(string:"\(Constants.baseURL)\(model.imageUrl)") else { return }
        print(url)
        titleCellImageView.sd_setImage(with:url, completed: nil)
        titleCellLabel.text = model.title
        minuteCellLabel.text = model.minute
        let commaPrice = numberFormatter(number: model.price)
        priceCellLabel.text = String("\(commaPrice) 원")
        
    }
    
    // 세자리수 컴마찍기
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    
    
}
