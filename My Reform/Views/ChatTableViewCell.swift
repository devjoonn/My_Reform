//
//  ChatTableViewCell.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/12.
//

import UIKit
import Then
import SnapKit

class ChatTableViewCell: UITableViewCell {
    
    static let identifier = "ChatTableViewCell"
    private var padding = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    
    let senderNickname : String = UserDefaults.standard.object(forKey: "senderNickname") as! String

    var messageView = UIView().then {
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .systemBlue
    }
    var messageLabel = UILabel().then {
        $0.text = "서버 연결 먼저"
        $0.textColor = .systemGray
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(messageView)
        messageView.addSubview(messageLabel)
        messageView.layer.cornerRadius = 16
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setting_inner() {
//        messageView.backgroundColor = .blue
        messageLabel.layer.borderWidth = 1
        messageLabel.layer.cornerRadius = 100
        messageLabel.backgroundColor = .mainColor
        messageLabel.textColor = .white
        messageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).inset(5)
            make.bottom.equalTo(contentView.snp.bottom).inset(5)
            
        }
        messageLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(contentView.snp.top).inset(5)
            make.bottom.equalTo(contentView.snp.bottom).inset(5)
            make.trailing.equalTo(contentView.snp.trailing).inset(15)
        }
    }
    
    func setting_outer() {
        messageLabel.layer.borderWidth = 1
        messageLabel.layer.cornerRadius = 100
        messageLabel.backgroundColor = .grayColor
        messageLabel.textColor = .black
        messageLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(contentView.snp.top).inset(5)
            make.bottom.equalTo(contentView.snp.bottom).inset(5)
            make.leading.equalTo(contentView.snp.leading).inset(15)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(with model: String) {
        
        // 데이터 /(슬레시로) 구분 한 걸 배열로 만들어 dataSplit에 담음
        let dataSplit = model.components(separatedBy: "/")
        print("senderNickname = ", senderNickname)
        // 본인이 보낸 메시지면 오른쪽 배치 함수 실행
        if (dataSplit[1] == senderNickname) {
            messageLabel.text = dataSplit[2]
            setting_inner()
        } else {
            messageLabel.text = dataSplit[2]
            setting_outer()
        }
        
    }
    

}
