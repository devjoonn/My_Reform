//
//  ChatViewController.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/06.
//

// 채팅방

import UIKit

class ChatViewController: UIViewController {
    
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
//MARK: - 1. send  messgae
extension ChatViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = messageTextField.text else {return false}
        
//        let data = text
//        let dataAsString = data.base64EncodeString()
//        let dic : NSDictionary = ["type" : "ENTER", "chatroomId" : 1, "nickname" : "name2", "message" : text]
//        let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: [])
//        WebSocket.shared.send(data: jsonData!)
//        let jsonString = String(data: jsonData!, encoding: .utf8)
//        self!.
        
        let result_text = "2/name2/"+text
        WebSocket.shared.send(message: result_text)

        return true
    }
    
    func sendMessage() {
        
    }
}

//MARK: - 2. setting
extension ChatViewController : UITextFieldDelegate {
    func attribute() {
        
        
        messageTextField.delegate = self
        let tapGuesterShowKeyboard = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
//        let tapGuesterHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
//        view.addGestureRecognizer(tapGuesterHideKeyboard)
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
}

//MARK: - 3 keyboard handler
extension ChatViewController {
    @objc func showKeyboard() {
        messageTextField.becomeFirstResponder()
    }
//    @objc func hideKeyboard() {
//        messageTextField.resignFirstResponder()
//    }
    
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

