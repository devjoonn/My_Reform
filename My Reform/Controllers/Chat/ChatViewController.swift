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
    
    // 메시지 담는 배열
    static var messages = [String]()
    
    var itemView = UIView().then {
        $0.backgroundColor = .systemBackground
        
    }
    
    var itemimageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
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
    

    var tableView : UITableView =  {
        let table = UITableView(frame: .zero, style: .grouped)
        //Views 에있는 CollectionViewTabelCell 호출
        table.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        return table
    }()
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableview numberOfrows called", ChatViewController.messages.count)
        print(ChatViewController.messages)
        return ChatViewController.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("----tableview cellForRowAt 실행")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        
        let model = ChatViewController.messages[indexPath.row]
        
        print("----tableview cellForRowAt 실행2")
        
        
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chat = ChatViewController.messages[indexPath.row]
        let dataSplit = chat.components(separatedBy: "/")

        //좌우마진 122, 40이 최대값이므로 최댓값 가로길이는 아래와같음
        let widthOfText = view.frame.width - 122 - 40
        let size = CGSize(width: widthOfText, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        let estimatedFrame = NSString(string: dataSplit[2]).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        print("------heightForRowAt func called")

        // 위아래마진 14,14 + 여유공간 4
        return estimatedFrame.height + 20
        
    }


    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        WebSocket.shared.url = URL(string: "ws://211.176.69.65:8080/ws/chat")

        navigationItem.title = "백살 먹은 리포머"
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
        guard let imageUrl = URL(string: "https://images.unsplash.com/photo-1613896640137-bb5b31496315?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80") else { return }
        itemimageView.sd_setImage(with: imageUrl)
        guard let boardTitle = detailChatRoomModel.first?.boardTitle else { return }
//        guard let boardPrice = detailChatRoomModel.first?.price else { return } - 가격 정보도 추가 되어아함
        itemTitleLabel.text = "레트로 파우치"
//        itemPriceLabel.text = boardPrice

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
                let result_message = "2/\(senderNickname)/"+message
                WebSocket.shared.send(message: result_message)
                messageTextField.text = ""
                ChatViewController.messages.append(result_message)
                self.updateChat(count: ChatViewController.messages.count) {
                    print("Send Message")
                    print(ChatViewController.messages)
                }
//                scrollToBottomOfChat()
                
            }
        }
    }
    
    
    func updateChat(count: Int, completion: @escaping ()->Void) {
        print("---- count : ", count)
        let indexPath = IndexPath(row: count-1, section: 0)
        
        DispatchQueue.main.async{
            print("-------updateChat called")
    //        tableView.reloadData()
            print("-------updateChat called2")
            self.tableView.beginUpdates()
            print("-------updateChat called3")
            self.tableView.insertRows(at: [indexPath], with: .none)
            print("-------updateChat called4")
            
            self.tableView.endUpdates()
            print("-------updateChat called5")
    //        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            print("-------updateChat called6")
            self.tableView.rowHeight = UITableView.automaticDimension
            print("-------updateChat called7")
            
            self.tableView.reloadData()
            print("-------updateChat called8")
        }
        

//        completion()
    }
    
    
    // 함수 실행 문제 X
    func receiveMessage(_ message: String) {
        if message.trimmingCharacters(in: .whitespaces) != "" {
            let dataSplit = message.components(separatedBy: "/")
            if dataSplit[1] == senderNickname { return }
            
            
            ChatViewController.messages.append(message)
            self.updateChat(count: ChatViewController.messages.count) {
                print("receiveMessage")
                print(ChatViewController.messages)
            }
        }
    }
}

//MARK: - 2. setting
extension ChatViewController : UITextFieldDelegate {
    func attribute() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        
        messageTextField.delegate = self
        let tapGuesterShowKeyboard = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        let tapGuesterHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hidKeyboard))
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardOpen), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardOpen), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableView.addGestureRecognizer(tapGuesterHideKeyboard)
        messageTextField.superview?.addGestureRecognizer(tapGuesterShowKeyboard)
        
        inputBottomView.backgroundColor = .systemBackground
        

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
            make.leading.equalTo(20)
        }
        
        itemTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(itemimageView.snp.trailing).offset(8)
            make.top.equalToSuperview().inset(15)
        }
        
        itemPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(itemTitleLabel.snp.bottom).inset(-3)
            make.leading.equalTo(itemimageView.snp.trailing).offset(10)
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
    
//    @objc func keyboardWillShowHandle(notification: NSNotification) {
//
//        print(inputBottomView.frame.origin.y)
//        print("keyboardWillShowHandle() called")
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            inputBottomView.frame.origin.y -= keyboardSize.height
//        }
//
//    }
//    @objc func keyboardWillHideHandle(notification: NSNotification) {
//        print("keyboardWillHide() called")
//
//        inputBottomView.frame.origin.y = 0
//
//    }

    @objc func handleKeyboardOpen(notification: Notification) {
        print(inputBottomView.frame.origin.y)
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


