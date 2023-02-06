//
//  ChatViewController.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/06.
//

import UIKit

class ChatViewController: UIViewController {

    override func viewDidLoad() {
        func viewDidLoad() {
          super.viewDidLoad()
          
          WebSocket.shared.url = URL(string: "ws://0.0.0.0:8080/echo")
          try? WebSocket.shared.openWebSocket()
          WebSocket.shared.delegate = self
          WebSocket.shared.onReceiveClosure = { (string, data) in
            print(string, data)
          }
          
          WebSocket.shared.send(message: "hello world")
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

