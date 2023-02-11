//
//  ChatViewController.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/06.
//

// 채팅방

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let senderNickname : String = UserDefaults.standard.object(forKey: "senderNickname") as! String
    
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
    
    var tableView = UITableView()
    
    // 메시지 담는 배열
    var messages = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        
        let model = messages[indexPath.row]
        
        cell.configure(with: model)
        
        // 데이터 /(슬레시로) 구분 한 걸 배열로 만들어 dataSplit에 담음
//        let dataSplit = messages[indexPath.row].components(separatedBy: "/")
        
        // 본인이 보낸 메시지가 맞으면 오른쪽에 배치
//        if dataSplit[1] == senderNickname {
//            cell = tableView.dequeueReusableCell(withIdentifier: "outgoingCell") as! ChatTableViewCell
//        } else {
//            cell = tableView.dequeueReusableCell(withIdentifier: "incomingCell") as! ChatTableViewCell
//        }
//        cell.configureCell(message: messages[indexPath.row])
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
        // 키보드 노티 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        WebSocket.shared.closeWebSocket()
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
                tableView.reloadData()
                scrollToBottomOfChat()
                
            }
        }
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
        view.addSubview(inputBottomView)
        inputBottomView.addSubview(messageTextField)
        
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
    
    func scrollToBottomOfChat(){
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
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

