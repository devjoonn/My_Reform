//
//  HomeViewController.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/06.
//

import UIKit
import SnapKit
import Alamofire
import SDWebImage

// 0126 메인에서 테이블 뷰가 10개 이후로 무한 스크롤 불러오는 것들 구현해야함 [O]

class HomeViewController: UIViewController {
    
    let senderId : String = UserDefaults.standard.object(forKey: "senderId") as! String
    
    var lastBoardId : Int = 100
    var allPostDataManagerUrl: String = "\(Constants.baseURL)/boards?categoryId=&keyword=&lastBoardId=&loginNickname=&size="
    
//     데이터 모델이 추가될 때 마다 테이블 뷰 갱신
    var allPostModel: [AllPostData] = []{
        didSet {
            self.homeFeedTable.reloadData()
        }
    }

    private let refreshControl = UIRefreshControl()
    private let homeFeedTable: UITableView = {
        
        let table = UITableView(frame: .zero, style: .grouped)
        //Views 에있는 CollectionViewTabelCell 호출
        table.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        
        view.backgroundColor = .white
        view.addSubview(homeFeedTable)
        
        // UserDefault에 저장되는 값 출력
        print("HomeView로 넘어옴 - UserDefault에 저장되는 userNickname - \(senderId))")
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        homeFeedTable.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        refreshControl.addTarget(self, action: #selector(beginRefresh), for: .valueChanged)
        homeFeedTable.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AllPostDataManager().allPostGet(self, senderId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let vc = DetailPostViewController()
        vc.detailPostModel = []
        print(vc.detailPostModel)
    }
        
    // 새로고침
    @objc func beginRefresh(_ sender: UIRefreshControl) {
        print("beginRefresh!")
        sender.endRefreshing()
        allPostModel.removeAll()
        AllPostDataManager().allPostGet(self, senderId)
        print("HomeView로 넘어옴 - UserDefault에 저장되는 userId - \(senderId))")
    }
    
    @objc func categoryBtnClicked() {
        let vc = CategoryViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func uploadBtnClicked() {
        let vc = UploadViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func logoClicked() {
        // 첫번째 셀로 이동하는 함수 [x]
        self.homeFeedTable.reloadData()
    }
    
    
    // 데이터 무한 스크롤
    private func fetchingAll(_ lastBoardId: Int) {
        
        print("fetchingAll - lastBoardId = \(lastBoardId)")
        let userId = senderId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        AF.request("\(allPostDataManagerUrl)\(lastBoardId)&loginId=\(userId)" ,method: .get, parameters: nil).validate().responseDecodable(of: AllPostModel.self) { response in
            DispatchQueue.main.async {
                self.homeFeedTable.tableFooterView = nil
            }
            switch(response.result) {
            case .success(let result) :
//                print("전체 게시물 추가조회 성공 - \(result)")
                switch(result.status) {
                case 200 :
                    DispatchQueue.main.async {
                        self.homeFeedTable.tableFooterView = nil
                    }
                    guard let data = result.data else { return }
                    self.successAllPostModel(result: data)
                    DispatchQueue.main.async {
                        self.homeFeedTable.reloadData()
                    }
                case 404 :
                    print("게시물이 없는 경우입니다 - \(result.message)")
                default:
                    print("데이터베이스 오류")
                }
                
            case .failure(let error) :
                print(error)
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    //상단 네비게이션바
    func configureNavbar() {
        
        // 뒤로가기 버튼 < 만 출력
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
            backBarButtonItem.tintColor = .black
            self.navigationItem.backBarButtonItem = backBarButtonItem
        
        var image = UIImage(named: "logotype")?.resize(newWidth: 150)
        image = image?.withRenderingMode(.alwaysOriginal) //색깔 원래대로
        let imageBtn = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(logoClicked))
        let categoryBtn = UIBarButtonItem(image: UIImage(named: "category")?.resize(newWidth: 30), style: .done, target: self, action: #selector(categoryBtnClicked))
        let uploadBtn = UIBarButtonItem(image: UIImage(named: "upload")?.resize(newWidth: 30), style: .done, target: self, action: #selector(uploadBtnClicked))
            
        self.navigationItem.leftBarButtonItem = imageBtn
        self.navigationItem.rightBarButtonItems = [categoryBtn, uploadBtn]
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .label
    }
    
    // AllPostDataManager 에서 데이터를 불러오는데 성공하면 실행되는 함수
    func successAllPostModel(result: [AllPostData]) {
        // 불러온 값을 위에 전역변수로 저장
//        self.allPostModel = result
        self.allPostModel.append(contentsOf: result)
        print(allPostModel.count)
        
    }
    
}



//MARK: -- TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPostModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }

        
        let model = allPostModel[indexPath.row]
        guard let price = model.price else { return UITableViewCell()}
        guard let like = model.likeOrNot else {return UITableViewCell()}
        
        cell.configure(with: HomeFeedViewModel(imageUrl: model.imageUrl?.first ?? "", title: model.title ?? "", minute: model.time ?? "", price: price, like: like))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀 선택시 회색화면 지우기
        print("cell indexPath = \(indexPath)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = allPostModel[indexPath.row]
        
        let vc = DetailPostViewController()
        vc.detailPostModel = [model]
        print("detailPostModel에 data 저장됨")
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 하단 로딩창
    private func createSpinnerFooter() -> UIView {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
            
            let spinner = UIActivityIndicatorView()
            spinner.center = footerView.center
            footerView.addSubview(spinner)
            spinner.startAnimating()
            
            return footerView
        }
    
    // 하단 셀까지 가면 셀 추가
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let postion = scrollView.contentOffset.y
        if postion > (homeFeedTable.contentSize.height-100-scrollView.frame.size.height) {
            //fetch data
            print("데이터 불러오는 중")
                dataFetch()
        }
    }
    
    // 데이터 불러오는 함수
    func dataFetch() {
        print("dataFetch() called - ")
        self.homeFeedTable.tableFooterView = createSpinnerFooter()
        
        if allPostModel.count == 0{
            return
        }
        lastBoardId = allPostModel[allPostModel.count - 1].boardId!
        print("lastBoardId = \(lastBoardId)")
        // footerview 끄기랑 데이터 새로고침
        fetchingAll(lastBoardId)
    }
}

