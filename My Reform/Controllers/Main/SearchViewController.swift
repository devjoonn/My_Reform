//
//  SearchViewController.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/06.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController,  UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    var allPostModel: [AllPostData] = [] {
        didSet {
            self.exploreCollectionView.reloadData()
        }
    }
    
    private let searchController : UISearchController = {
      let controller = UISearchController(searchResultsController: SearchListViewController())
        controller.searchBar.placeholder = "검색"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private let refreshControl = UIRefreshControl()
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private lazy var exploreCollectionView : UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        return collection
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("- requestFunc 실행")
        requestFunc()
    }
}

extension SearchViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 3
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPostModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        
        let model = allPostModel[indexPath.row]
        
//        guard let image = model.imageUrl?[0] else { return cell }
        
        cell.SearchConfig(with: SearchFeedViewModel(boardId: model.boardId ?? -1, imageUrl: model.imageUrl?.first ?? ""))
        
        
//        cell.backgroundColor = [.systemGray, .systemGray2, .systemGray3, .systemGray4, .systemGray5, .systemGray6].randomElement()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell indexPath = \(indexPath)")
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let model = allPostModel[indexPath.row]
        
        let vc = DetailPostViewController()
        vc.detailPostModel = [model]
        print("detailPostModel에 data 저장됨")
        
    }
}

extension SearchViewController {
    // 새로고침
    @objc func beginRefresh(_ sender: UIRefreshControl) {
        print("beginRefresh!")
        sender.endRefreshing()
        requestFunc()
    }
    
    // 키보드 search 버튼 클릭시 데이터 전달
//    @objc func searchBtnClicked() {
//        let vc = SearchListViewController()
//        navigationController?.pushViewController(vc, animated: true)
//
//
//        vc.vcTitle = searchController.searchBar.text ?? ""
//    }
}

extension SearchViewController : UISearchResultsUpdating{
    func attribute() {
        view.backgroundColor = .systemBackground
        
        navigationController?.hidesBarsOnSwipe = true
        
        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchResultsUpdater = self
        navigationItem.titleView?.isHidden = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
//        navigationItem.titleView = searchController.searchBar
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self

        refreshControl.addTarget(self, action: #selector(beginRefresh(_:)), for: .valueChanged)
        exploreCollectionView.refreshControl = refreshControl
        
        exploreCollectionView.dataSource = self
        exploreCollectionView.delegate = self
        exploreCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        
        
    }
    func layout() {
        view.addSubview(exploreCollectionView)
        exploreCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension SearchViewController : UISearchControllerDelegate  {

    func updateSearchResults(for searchController: UISearchController) {
//        let vc = SearchListViewController()
//        navigationController?.pushViewController(vc, animated: false)
        
        let searchBar = searchController.searchBar
        
        guard let text = searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty, let resultController = searchController.searchResultsController as? SearchListViewController  else{return}
//        guard let text = searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty, text.trimmingCharacters(in: .whitespaces).count >= 3, let resultController = searchController.searchResultsController as? SearchListViewController  else{return}
        
        print(resultController)
    }
//
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        let vc = SearchListViewController()
//        navigationController?.pushViewController(vc, animated: false)
//
//        return true
//    }

    // when clicked searchButton in keyboard
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        guard let text = searchController.searchBar.text else { return }
//        searchBtnClicked()
//
//
//        print("search result : ", text)
//    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        // 검색값이 비어있을 때 자동적으로 포커싱 해제(키보드 내려감)
//        if(searchText.isEmpty) {
//            // 검색바에 x를 누를 때는 포커싱해제가 안되서 아래를 이용하여 딜레이를 줌
//            DispatchQueue.main.asyncAfter(deadline: .now()+0.01, execute:{ searchBar.resignFirstResponder()})
//             // 포커싱 해제
//        }
//
//    }
}


extension SearchViewController  {
    
    
    func successSearchViewPostModel(result: [AllPostData]) {
        self.allPostModel = result
        print(allPostModel.count)
        
    }
    
    func requestFunc() {
        AF.request("\(Constants.baseURL)/boards?lastBoardId=100&size=30&keyword=",method: .get, parameters: nil ).validate().responseDecodable(of: AllPostModel.self) { response in
            debugPrint(response)
            switch(response.result) {
            case .success(let result) :
                print("검색 UI 서버 통신 성공 - \(result)")
                switch(result.status) {
                case 200:
                    guard let data = result.data else {return}
                    self.successSearchViewPostModel(result: data)
//                    print("result data count = \(result.data?.count)")
                case 404:
                    print("데이터가 없는 경우입니다. - \(result.message)")
                default:
                    print("데이터베이스 오류")
                    return
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
}



#if DEBUG
import SwiftUI
struct SearchViewControllerRepresentable: UIViewControllerRepresentable {
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
  }
  @available(iOS 13.0.0, *)
  func makeUIViewController(context: Context) -> some UIViewController {
      SearchViewController()
  }
}
@available(iOS 13.0, *)
struct SearchViewControllerRepresentable_PreviewProvider: PreviewProvider {
  static var previews: some View {
    Group {
        SearchViewControllerRepresentable()
        .ignoresSafeArea()
        .previewDisplayName("Preview")
        .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
    }
  }
} #endif
