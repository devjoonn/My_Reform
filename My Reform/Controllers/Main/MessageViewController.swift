//
//  MessageViewController.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/06.
//

import UIKit
import SnapKit
import Alamofire

class MessageViewController: UIViewController {
    
    let senderNickname : String = UserDefaults.standard.object(forKey: "senderNickname") as! String

    
    var postDataUrl: String = "\(Constants.baseURL)/chats"
    var chatRoomModel: [MessageViewData] = [] {
        didSet {
            self.FeedTable.reloadData()
        }
    }
    
    private let refreshControl = UIRefreshControl()
            
    var btn = UIButton()
                                      
    private let FeedTable: UITableView = {
        let table = UITableView()
        table.register(MessageViewTableViewCell.self, forCellReuseIdentifier: MessageViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        setAttribute()
        setLayout()
        
        view.addSubview(btn)
        btn.backgroundColor = .green
        btn.snp.makeConstraints { (make) in
            make.width.height.equalTo(200)
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }

        btn.addTarget(self, action: #selector(moveChat), for: .touchUpInside)
//        refreshControl.addTarget(self, action: #selector(beginRefresh), for: .valueChanged)
        
        
    }
    @objc func moveChat() {
        print(1)
        let vc = ChatViewController()
        vc.navigationItem.title = "name2"
        vc.hidesBottomBarWhenPushed = true
        let userData = ChatInput(senderNickname: senderNickname, boardId: 1)
        ChatDataManager.posts(ChatViewController.init(), userData)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: 1.Setting 함수
extension MessageViewController {
    func setAttribute() {
        view.backgroundColor = .white
        view.addSubview(FeedTable)
        
        FeedTable.delegate = self
        FeedTable.dataSource = self
    }
    func setLayout() {
        FeedTable.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    func setupNavigationBar() {
        navigationItem.title = "채팅"
        navigationController?.navigationBar.backgroundColor = .white
    }
}

//MARK: 2. TableView
extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageViewTableViewCell.identifier, for: indexPath) as? MessageViewTableViewCell else {return UITableViewCell()}
        
        let model = chatRoomModel[indexPath.row]
        
        cell.configure(with: MessageFeedViewModel(ownerNickname: model.ownerNickname ?? "", senderNickname: model.senderNickname ?? "", title: model.boardTitle ?? "", lastMessage: model.lastMessage ?? ""))

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀 선택시 회색화면 지우기
        print("cell indexPath = \(indexPath)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = chatRoomModel[indexPath.row]
        
        let vc = ChatViewController()
        vc.detailChatRoomModel = [model]
        vc.hidesBottomBarWhenPushed = true
//        vc.detailPostModel = [model]
//        print("detailPostModel에 data 저장됨")
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
        
        vc.navigationItem.title = model.senderNickname
        let userData = ChatInput(senderNickname: model.senderNickname ?? "", boardId: model.boardId ?? -1)
        ChatDataManager.posts(ChatViewController.init(), userData)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: 3. server 연결
extension MessageViewController {
    override func viewWillAppear(_ animated: Bool) {
//        let userData = MessageViewInput(nickname: senderNickname)
//        print("userData: ",senderNickname)
        let userData = MessageViewInput(nickname: senderNickname)

        MessageViewDataManager().ChatListGet(self, userData)
    }
    
    func successAllPostModel(result: [MessageViewData]) {
        // 불러온 값을 위에 전역변수로 저장
        self.chatRoomModel.append(contentsOf: result)
        print(chatRoomModel.count)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        chatRoomModel = []
    }
}
