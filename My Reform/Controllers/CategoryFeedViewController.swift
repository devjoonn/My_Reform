//
//  CategoryFeedViewController.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/29.
//

import UIKit

class CategoryFeedViewController: UIViewController {

// MARK: - 초기 카테고리ID와 Name 저장 값
    var getCategoryId: Int!
    var categoryName: String = ""
    
    var categoryPostModel: [CategoryPostData] = []{
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
        
        categoryFeedTable.delegate = self
        categoryFeedTable.dataSource = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("getCategoryId = \(String(describing: getCategoryId))")
        CategoryPostDataManager().categoryPostGet(self, categoryId: getCategoryId)
    }
    
    func successCategoryPostModel(result: [CategoryPostData]) {
        self.categoryPostModel.append(contentsOf: result)
        print(categoryPostModel.count)
    }
    
    
    func checkCategory() {
        guard let categoryId = getCategoryId else { return }
        print("categoryId unwrapped - \(categoryId)")
        switch categoryId {
        case 0:
            categoryName = "디지털 기기"
        case 1:
            categoryName = "생활 / 소품"
        case 2:
            categoryName = "스포츠 / 레저"
        case 3:
            categoryName = "가구 / 인테리어"
        case 4:
            categoryName = "여성 의류"
        case 5:
            categoryName = "여성 잡화"
        case 6:
            categoryName = "남성 의류"
        case 7:
            categoryName = "남성 잡화"
        case 8:
            categoryName = "그림"
        case 9:
            categoryName = "기타"
        default:
            return
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
        
        let model = categoryPostModel[indexPath.row]
        
        //MARK: - 0130 데이터를 detailPostController로 넘기는 dataManager를 생성해야함 [x]
        // 프론트가 받는 파라미터들은 AllPostModel과 같아야하지만, 요청하는 dataManager는 해당 셀의 indexPath의 boardId를 기준으로 값을 넘겨주어야함
        
        let vc = DetailPostViewController()
//        vc.detailPostModel = [model]
        print("detailPostModel에 data 저장됨")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
