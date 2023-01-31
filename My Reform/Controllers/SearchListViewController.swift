//
//  SearchListViewController.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/01/23.
//

import UIKit
import Alamofire

class SearchListViewController: UIViewController {
    
    var allPostModel: [AllPostData] = [] {
        didSet {
            self.searchFeedTable.reloadData()
        }
    }
    
    public let searchFeedTable: UITableView = {
        
        let table = UITableView(frame: .zero, style: .grouped)
        //Views 에있는 CollectionViewTabelCell 호출
        table.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        return table
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let vc: String  = SearchViewController().searchController.searchBar.text else {return}
        self.searchFeedTable.reloadData()
    }
    

}

extension SearchListViewController {
    func attribute() {
        view.backgroundColor = .systemBackground
        view.addSubview(searchFeedTable)
        
        
        searchFeedTable.delegate = self
        searchFeedTable.dataSource = self
    }
    func layout() {
        searchFeedTable.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchFeedTable.frame = view.bounds
    }
}

extension SearchListViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPostModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }

        
        let model = allPostModel[indexPath.row]
//        guard let model = allPostModel[indexPath.row] else { return UITableViewCell() } //현재 model 은 옵셔널 스트링 값
//        guard let price = model.price else { return UITableViewCell()}
//        cell.titleCellImageView =
        cell.configure(with: HomeFeedViewModel(imageUrl: model.imageUrl?.first ?? "", title: model.title ?? "", minute: model.updateAt ?? "", price: model.price ?? 0))
        cell.backgroundColor = .systemBlue
        
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
}

extension SearchListViewController {
    
    func successSearchViewPostModel(result: [AllPostData]) {
        self.allPostModel.append(contentsOf: result)
        print(allPostModel.count)
        print("allPostModel----------------------------------------",allPostModel)
    }
    
    
}























//extension SearchListViewController : UISearchBarDelegate {
//    func attribute() {
//        navigationController?.hidesBarsOnSwipe = true
//
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchBar.placeholder = "검색"
//        searchController.searchResultsUpdater = self
//        navigationItem.titleView = searchController.searchBar
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.delegate = self
//
//        // CancelButton 없애기
//        searchController.searchBar.showsCancelButton = false
//        // 서치바 생성하는 게 상대적으로 오래거렬서 딜레이를 줌으로써 서치바가 생성되고 서치바에 포커싱이 되도록 함
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.01, execute:{ self.searchController.searchBar.becomeFirstResponder()})
//
//    }
//}
//extension SearchListViewController : UISearchResultsUpdating, UISearchControllerDelegate {
//    // when typing on keyboard
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else{return}
//        print(text)
//    }
//
//    // when clicked searchButton in keyboard
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        guard let text = searchController.searchBar.text else { return }
//        print("search result :", text)
//    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        // 검색값이 비어있을 때 자동적으로 포커싱 해제(키보드 내려감)
//        if(searchText.isEmpty) {
//            // 검색바에 x를 누를 때는 포커싱해제가 안되서 아래를 이용하여 딜레이를 줌
//            DispatchQueue.main.asyncAfter(deadline: .now()+0.01, execute:{ searchBar.resignFirstResponder()})
//             // 포커싱 해제
//        }
//    }
//
//}
