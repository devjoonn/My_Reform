//
//  SocketManger.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/02/06.
//

import Foundation


enum WebSocketError: Error {
  case invalidURL
}

class WebSocket: NSObject {
  static let shared = WebSocket()
  
  var url: URL?
  var onReceiveClosure: ((String?, Data?) -> ())?
  weak var delegate: URLSessionWebSocketDelegate?
  
  private var webSocketTask: URLSessionWebSocketTask? {
    didSet { oldValue?.cancel(with: .goingAway, reason: nil) }
  }
  private var timer: Timer?
  
  private override init() {}
  
  func openWebSocket() throws {
    guard let url = url else { throw WebSocketError.invalidURL }
    
    let urlSession = URLSession(
      configuration: .default,
      delegate: self,
      delegateQueue: OperationQueue()
    )
    let webSocketTask = urlSession.webSocketTask(with: url)
    webSocketTask.resume()
    
    self.webSocketTask = webSocketTask
    
    self.startPing()
  }
  
  func send(message: String) {
    self.send(message: message, data: nil)
  }
  
  func send(data: Data) {
    self.send(message: nil, data: data)
  }
  
  private func send(message: String?, data: Data?) {
    let taskMessage: URLSessionWebSocketTask.Message
    if let string = message {
      taskMessage = URLSessionWebSocketTask.Message.string(string)
    } else if let data = data {
      taskMessage = URLSessionWebSocketTask.Message.data(data)
    } else {
      return
    }
    
    print("Send message \(taskMessage)")
    self.webSocketTask?.send(taskMessage, completionHandler: { error in
      guard let error = error else { return }
      print("WebSOcket sending error: \(error)")
    })
  }
  
  func closeWebSocket() {
    self.webSocketTask = nil
    self.timer?.invalidate()
    self.onReceiveClosure = nil
    self.delegate = nil
  }
  
    func receive() {
        print("receive method called")
      self.webSocketTask?.receive(completionHandler: { [weak self] result in
          debugPrint("디버그:", result)
        switch result {
        case let .success(message):
          switch message {
          case let .string(string):
              print("Got string: \(string)")
              ChatViewController().receiveMessage(string)
          case let .data(data):
              print("Got Data: \(data)")
          @unknown default:
              break
          }
        case let .failure(error):
          print("Received error \(error)")
        }

          self?.receive()
      })
    }
    
    
    
    
  
  private func startPing() {
    self.timer?.invalidate()
    self.timer = Timer.scheduledTimer(
      withTimeInterval: 10,
      repeats: true,
      block: { [weak self] _ in self?.ping() }
    )
  }
  private func ping() {
    self.webSocketTask?.sendPing(pongReceiveHandler: { [weak self] error in
      guard let error = error else { return }
      print("Ping failed \(error)")
      self?.startPing()
    })
  }
}

extension WebSocket: URLSessionWebSocketDelegate {
  func urlSession(
    _ session: URLSession,
    webSocketTask: URLSessionWebSocketTask,
    didOpenWithProtocol protocol: String?
  ) {
      print("did connect")
      ping()
      receive()
      self.delegate?.urlSession?(
      session,
      webSocketTask: webSocketTask,
      didOpenWithProtocol: `protocol`
    )
  }
  
  func urlSession(
    _ session: URLSession,
    webSocketTask: URLSessionWebSocketTask,
    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
    reason: Data?
  ) {
      print("did close")
    self.delegate?.urlSession?(
      session,
      webSocketTask: webSocketTask,
      didCloseWith: closeCode,
      reason: reason
    )
  }
}



//func receive() {
//  self.webSocketTask?.receive(completionHandler: { [weak self] result in
//    switch result {
//    case let .success(message):
//      switch message {
//      case let .string(string):
//          print("Got Data: \(string)")
//      case let .data(data):
//          print("Got Data: \(data)")
//      @unknown default:
//          break
//      }
//    case let .failure(error):
//      print("Received error \(error)")
//    }
//  self?.receive()
//  })
//}
