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

// 0126 메인에서 테이블 뷰가 10개 이후로 무한 스크롤 불러오는 것들 구현해야함 [x]

class HomeViewController: UIViewController {
    
    var lastBoardId : Int = 100
    var allPostDataManagerUrl: String = "\(Constants.baseURL)/boards?size=20&lastBoardId="
    
//     데이터 모델이 추가될 때 마다 테이블 뷰 갱신
    var allPostModel: [AllPostData] = []{
        didSet {
            self.homeFeedTable.reloadData()
        }
    }


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
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        
        homeFeedTable.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AllPostDataManager().allPostGet(self)
    }
        
    
    
    @objc func categoryBtnClicked() {
        let vc = CategoryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func uploadBtnClicked() {
        let vc = UploadViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func logoClicked() {
        
    }
    
    
    // 데이터 새로고침
    private func fetchingAll(_ lastBoardId: Int) {
        
        print("fetchingAll - lastBoardId = \(lastBoardId)")
        AF.request("\(allPostDataManagerUrl)\(lastBoardId)" ,method: .get, parameters: nil).validate().responseDecodable(of: AllPostModel.self) { response in
            DispatchQueue.main.async {
                self.homeFeedTable.tableFooterView = nil
            }
            switch(response.result) {
            case .success(let result) :
                print("전체 게시물 추가조회 성공 - \(result)")
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
        
        var image = UIImage(named: "logotype")?.resize(newWidth: 150)
        image = image?.withRenderingMode(.alwaysOriginal) //색깔 원래대로
        let imageBtn = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(logoClicked))
        let categoryBtn = UIBarButtonItem(image: UIImage(named: "category")?.resize(newWidth: 25), style: .done, target: self, action: #selector(categoryBtnClicked))
        let uploadBtn = UIBarButtonItem(image: UIImage(named: "upload")?.resize(newWidth: 25), style: .done, target: self, action: #selector(uploadBtnClicked))
            
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
//        guard let model = allPostModel[indexPath.row] else { return UITableViewCell() } //현재 model 은 옵셔널 스트링 값
        guard let price = model.price else { return UITableViewCell()}
//        cell.titleCellImageView =
        cell.configure(with: HomeFeedViewModel(imageUrl: model.imageUrl?.first ?? "", title: model.title ?? "", minute: model.updateAt ?? "", price: price))
        
        
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

