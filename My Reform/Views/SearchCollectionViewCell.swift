//
//  SearchCollectionViewCell.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/01/26.
//


import UIKit
import SDWebImage
import Then


class SearchCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchCollectionViewCell"
    
//    var image = UIImage().then {
//        $0.images = nil
//    }
    
    private let imageView = UIImageView()
    
    var titleCellImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleCellImageView)
//        self.setupView()
        setUIConstraints()
    }
    
//    private func setupView() {
//        self.addSubview(self.imageView)
//        self.imageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
//            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
//        ])
////        self.imageView.backgroundColor = [.systemGray, .systemGray2, .systemGray3, .systemGray4, .systemGray5, .systemGray6].randomElement()
//        self.imageView.contentMode = .scaleToFill
//    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func SearchConfig(with model: SearchFeedViewModel) {
//        print(model.imageUrl)
        guard let url = URL(string: "\(Constants.baseURL)\(model.imageUrl)") else { return }
        
        print(url)
        
        titleCellImageView.sd_setImage(with: url, completed: nil)
 
    
        
    }
    func setUIConstraints() {
        titleCellImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.trailing.equalTo(contentView)
        }
    }
    
//    override init(style: UICollectionViewCell, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(titleCellImageView)
//        contentView.addSubview(titleCellLabel)
////        contentView.addSubview(heartButton)
//        contentView.addSubview(minuteCellLabel)
//        contentView.addSubview(priceCellLabel)
//
//        setUIConstraints()
//    }
}
