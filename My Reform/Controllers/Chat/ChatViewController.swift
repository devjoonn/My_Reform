//
//  ChatViewController.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/06.
//

// 채팅방

import UIKit
import SnapKit
import Then

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let senderNickname : String = UserDefaults.standard.object(forKey: "senderNickname") as! String
    
    var detailChatRoomModel: [MessageViewData] = []
    
    var itemView = UIView().then {
        $0.backgroundColor = .orange
    }
    
    var itemimageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
    }
    
    var itemTitleLabel = UILabel().then {
        $0.text = "이름"
        $0.font = UIFont(name: "Pretendard-Medium", size: 13)
    }
    
    
    var itemPriceLabel = UILabel().then {
        $0.text = "30,000 원"
        $0.font = UIFont(name: "Pretendard-Medium", size: 13)
    }
    
    var sectionView = UIView().then {
        $0.backgroundColor = .systemGray
    }
    
    var messageTextField = { () -> UITextField in
        let text = UITextField()
        text.signUpViewAddLeftPadding()
        text.attributedPlaceholder = NSAttributedString(
            string: "메시지 보내기",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        text.font = UIFont(name: "Pretendard-Regular", size: 16)
        text.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 10.0
        return text
    }()
    
    var inputBottomView = UIView()
    
    var tableView = UITableView().then {
        $0.backgroundColor = .green
    }

    // 메시지 담는 배열
    var messages = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        
        let model = messages[indexPath.row]
        
        cell.configure(with: model)
        return cell
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        WebSocket.shared.url = URL(string: "ws://211.176.69.65:8080/ws/chat")
        
        attribute()
        layout()
        
//        WebSocket.shared.
//
//        let userData = SocketInput(type: "ENTER", chatroomId: 1, nickname: "name2", message: "")
//        SocketDataManager.posts(self, userData)
//        
        try? WebSocket.shared.openWebSocket()
        WebSocket.shared.delegate = self
        WebSocket.shared.onReceiveClosure = { (string, data) in
            print(string, data)
            
            
        }

        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // 게시물 정보를 보여주는 상단바에 내용 추가
//        guard let imageUrl = detailChatRoomModel.first.imageUrl else { return } - 이미지 url 추가되면 넣기
//        itemimageView.sd_setImage(with: imageUrl)
        guard let boardTitle = detailChatRoomModel.first?.boardTitle else { return }
//        guard let boardPrice = detailChatRoomModel.first?.price else { return } - 가격 정보도 추가 되어아함
        itemTitleLabel.text = boardTitle
//        itemPriceLabel.text = boardPrice
        // 키보드 노티 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        WebSocket.shared.closeWebSocket()
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        detailChatRoomModel.removeAll()
    }
    
    
}
//MARK: - 1. send messgae
extension ChatViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
    
    func sendMessage() {
        if let message = messageTextField.text {
            if message.trimmingCharacters(in: .whitespaces) != "" {
                // chatroom / senderNickname / message
                let result_message = "2/name2/"+message
                WebSocket.shared.send(message: result_message)
                messageTextField.text = ""
                messages.append(result_message)
                self.updateChat(count: self.messages.count) {
                    print("Send Message")
                }
//                tableView.reloadData()
//                scrollToBottomOfChat()
                
            }
        }
    }
    
    func updateChat(count: Int, completion: @escaping ()->Void) {
        let indexPath = IndexPath(row: count-1, section: 0)
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [indexPath], with: .none)
        self.tableView.endUpdates()
        
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        completion()
    }
}

//MARK: - 2. setting
extension ChatViewController : UITextFieldDelegate {
    func attribute() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        messageTextField.delegate = self
        let tapGuesterShowKeyboard = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        let tapGuesterHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hidKeyboard))
        
        tableView.addGestureRecognizer(tapGuesterHideKeyboard)
        messageTextField.superview?.addGestureRecognizer(tapGuesterShowKeyboard)
        

    }
    func layout() {
        view.addSubview(itemView)
        view.addSubview(sectionView)
        view.addSubview(tableView)
        view.addSubview(inputBottomView)
        
        itemView.addSubview(itemimageView)
        itemView.addSubview(itemTitleLabel)
        itemView.addSubview(itemPriceLabel)
        
        inputBottomView.addSubview(messageTextField)
        
        itemView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(65)
        }
        
        itemimageView.snp.makeConstraints { make in
            make.height.width.equalTo(48)
            make.centerY.equalToSuperview()
            make.leading.equalTo(30)
        }
        
        itemTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(itemimageView.snp.trailing).inset(8)
            make.top.equalToSuperview().inset(15)
        }
        
        itemPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(itemTitleLabel.snp.bottom).inset(-3)
            make.leading.equalTo(itemimageView.snp.trailing).inset(10)
        }
        
        sectionView.snp.makeConstraints { make in
            make.top.equalTo(itemView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(sectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(inputBottomView.snp.top)
        }
        
        inputBottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(37)
            make.height.equalTo(42)
        }
        
        messageTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(inputBottomView.snp.leading).inset(20)
            make.trailing.equalTo(inputBottomView.snp.trailing).inset(16)
            make.bottom.equalTo(inputBottomView.snp.bottom)
            make.height.equalTo(inputBottomView.snp.height)
        }
    }
    
//    func scrollToBottomOfChat(){
//        let indexPath = IndexPath(row: messages.count - 1, section: 0)
//        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
//    }
}

//MARK: - 3 keyboard handler
extension ChatViewController {
    @objc func showKeyboard() {
        messageTextField.becomeFirstResponder()
    }
    @objc func hidKeyboard() {
        messageTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillShowHandle(notification: NSNotification) {
        print("keyboardWillShowHandle() called")
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

                view.frame.origin.y -= (keyboardSize.height+10)
            }
        }
    }
    @objc func keyboardWillHideHandle(notification: NSNotification) {
        print("keyboardWillHide() called")
        view.frame.origin.y = 0
    }
    
    @objc func handleKeyboardOpen(notification: Notification) {
        if let userInfo = notification.userInfo {
            if messageTextField.isEditing {
                let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                if notification.name == UIResponder.keyboardWillShowNotification {
                    inputBottomView.frame.origin.y = 877-keyboardFrame.height
                } else {
                    inputBottomView.frame.origin.y = 847
                }
                
                
                UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
}




extension ChatViewController: URLSessionWebSocketDelegate {
  func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
    print("open")
  }
  func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
    print("close")
  }
}

#if DEBUG
import SwiftUI
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    
func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
}
@available(iOS 13.0.0, *)
func makeUIViewController(context: Context) -> UIViewController{
    ChatViewController()
    }
}
@available(iOS 13.0, *)
struct ViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            ViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        }
        
    }
} #endif
