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

    let senderNickname : String = UserDefaults.standard.object(forKey: "senderNickname") as! String

    var messageView = UIView().then {
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .systemBlue
    }
    var messageLabel = BasePaddingLabel(padding: UIEdgeInsets(top: 8, left: 22, bottom: 8, right: 22)).then {
        $0.text = "서버 연결 먼저"
        $0.textColor = .systemGray
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(messageView)
        messageView.addSubview(messageLabel)
        messageView.layer.cornerRadius = 16
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setting_inner() {
//        messageView.backgroundColor = .blue
        
        // label cornerRadius 사용하기 위해 masksToBounds true 설정
        messageLabel.layer.masksToBounds = true
        messageLabel.layer.cornerRadius = 17
        messageLabel.font = UIFont(name: "Pretendard-Medium", size: 16)
        messageLabel.backgroundColor = .mainColor
        messageLabel.textColor = .white
        messageLabel.snp.makeConstraints{ (make) in
//            make.top.equalTo(contentView.snp.top).inset(5)
            make.bottom.equalTo(contentView.snp.bottom)
            make.trailing.equalTo(contentView.snp.trailing).inset(15)
        }
    }
    
    func setting_outer() {
        messageLabel.layer.masksToBounds = true
        messageLabel.layer.cornerRadius = 17
        messageLabel.backgroundColor = .grayColor
        messageLabel.font = UIFont(name: "Pretendard-Medium", size: 16)
        messageLabel.textColor = .black
        messageLabel.snp.makeConstraints{ (make) in
//            make.top.equalTo(contentView.snp.top).inset(5)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading).inset(15)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        messageView.layer.cornerRadius = 16
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
            
//            messageLabel.drawText(in: CGRect())
            setting_inner()
        } else {
            messageLabel.text = dataSplit[3]
//            messageLabel.drawText(in: CGRect())
            setting_outer()
        }
        
    }
    

}

class BasePaddingLabel: UILabel {
    
    private var padding = UIEdgeInsets(top: 2.0, left: 4.0, bottom: 2.0, right: 4.0)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    //안의 내재되어있는 콘텐트의 사이즈에 따라 height와 width에 padding값을 더해줌
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}
