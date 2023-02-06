//
//  CategoryFeedViewController.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/29.
//

import UIKit
import Alamofire


class CategoryFeedViewController: UIViewController {

    var lastBoardId : Int = 5   
    var getCategoryId: Int!
    var categoryName: String = ""
    
// MARK: - 초기 카테고리ID와 Name 저장 값

    var categoryPostModel: [AllPostData] = []{
        didSet {
            self.categoryFeedTable.reloadData()
        }
    }
    
    private let categoryFeedTable: UITableView = {
        
        let table = UITableView(frame: .zero, style: .grouped)
        //Views 에있는 CollectionViewTabelCell 호출
        table.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        return table
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        checkCategory()
        title = categoryName
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        view.addSubview(categoryFeedTable)
        
        categoryFeedTable.delegate = self
        categoryFeedTable.dataSource = self
        
        categoryFeedTable.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("getCategoryId = \(String(describing: getCategoryId))")
        CategoryPostDataManager().categoryPostGet(self, categoryId: getCategoryId)
    }
    
    func successCategoryPostModel(result: [AllPostData]) {
        self.categoryPostModel.append(contentsOf: result)
        print("categoryPostModel.count = \(categoryPostModel.count)")
    }
    
    
    func checkCategory() {
        guard let categoryId = getCategoryId else { return }
        print("categoryId unwrapped - \(categoryId)")
        switch categoryId {
        case 1:
            categoryName = "디지털 기기"
        case 2:
            categoryName = "생활 / 소품"
        case 3:
            categoryName = "스포츠 / 레저"
        case 4:
            categoryName = "가구 / 인테리어"
        case 5:
            categoryName = "여성 의류"
        case 6:
            categoryName = "여성 잡화"
        case 7:
            categoryName = "남성 의류"
        case 8:
            categoryName = "남성 잡화"
        case 9:
            categoryName = "그림"
        case 10:
            categoryName = "기타"
        default:
            return
        }
    }
    
    
    // 데이터 새로고침
    private func fetchingAll(_ lastBoardId: Int) {
        
        print("fetchingAll - lastBoardId = \(lastBoardId)")
        AF.request("\(Constants.baseURL)/boards?&size=20&categoryId=\(String(describing: getCategoryId))&lastBoardId=\(lastBoardId)" ,method: .get, parameters: nil).validate().responseDecodable(of: AllPostModel.self) { response in
            DispatchQueue.main.async {
                self.categoryFeedTable.tableFooterView = nil
            }
            switch(response.result) {
            case .success(let result) :
                print("전체 게시물 추가조회 성공 - \(result)")
                switch(result.status) {
                case 200 :
                    DispatchQueue.main.async {
                        self.categoryFeedTable.tableFooterView = nil
                    }
                    guard let data = result.data else { return }
                    self.successCategoryPostModel(result: data)
                    DispatchQueue.main.async {
                        self.categoryFeedTable.reloadData()
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
    
}


extension CategoryFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryPostModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        let model = categoryPostModel[indexPath.row]
        print("cell 에서 model의 categoryPostModel count 출력 - \(model)")
        guard let price = model.price else { return UITableViewCell() }
        guard let like = model.like else { return UITableViewCell() }
        
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
        
        let model = categoryPostModel[indexPath.row]
        
        //MARK: - 0130 데이터를 detailPostController로 넘기는 dataManager를 생성해야함 [x]
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
        if postion > (categoryFeedTable.contentSize.height-100-scrollView.frame.size.height) {
            //fetch data
            print("데이터 불러오는 중")
                dataFetch()
        }
    }
    
    // 데이터 불러오는 함수
    func dataFetch() {
        print("dataFetch() called - ")
        self.categoryFeedTable.tableFooterView = createSpinnerFooter()
        
        if categoryPostModel.count == 0{
            return
        }
        lastBoardId = categoryPostModel[categoryPostModel.count - 1].boardId!
        print("lastBoardId = \(lastBoardId)")
        // footerview 끄기랑 데이터 새로고침
        fetchingAll(lastBoardId)
    }
    
}
