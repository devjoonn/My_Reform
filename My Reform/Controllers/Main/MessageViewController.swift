//
//  MessageViewController.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/06.
//

import UIKit

class MessageViewController: UIViewController {
    
    var postDataUrl: String = "\(Constants.baseURL)/    "
    var postModel: [MessagePostData] = [] {
        didSet {
            self.FeedTable.reloadData()
        }
    }
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
        return postModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageViewTableViewCell.identifier, for: indexPath) as? MessageViewTableViewCell else {return UITableViewCell()}
        
        let model = postModel[indexPath.row]
        
//        guard let price = model.price else { return UITableViewCell() }
//        cell.configure(with: feedMo)
        return cell
    }
    
    
}
