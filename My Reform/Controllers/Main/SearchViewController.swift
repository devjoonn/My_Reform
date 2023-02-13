///
//  SearchViewController.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/06.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController,  UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    let senderNickname : String = UserDefaults.standard.object(forKey: "senderNickname") as! String
    
    var allPostModel: [AllPostData] = [] {
        didSet {
            self.exploreCollectionView.reloadData()
        }
    }
    
    let searchController : UISearchController = {
      let controller = UISearchController(searchResultsController: SearchListViewController())
        controller.searchBar.placeholder = "검색"
//        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
//    lazy var searchController : UISearchController = {
//        let controller = UISearchController(searchResultsController: UINavigationController(rootViewController: SearchListViewController(navigationController: self.navigationController!)))
//        controller.searchBar.placeholder = "검색"
// //        controller.searchBar.searchBarStyle = .minimal
//         return controller
//     }()
    
//    let searchController : UISearchController = {
//          let controller = UISearchController(searchResultsController: UINavigationController(rootViewController: SearchListViewController()))
//            controller.searchBar.placeholder = "검색"
//    //        controller.searchBar.searchBarStyle = .minimal
//            return controller
//        }()
    
    private let refreshControl = UIRefreshControl()
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private lazy var exploreCollectionView : UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 뒤로가기 버튼 < 만 출력
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
        attribute()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("- requestFunc 실행")
        requestFunc()
    }
    
    func successSearchViewPostModel(result: [AllPostData]) {
        self.allPostModel = result
        print(allPostModel.count)
        
    }
    
    func requestFunc() {
        
        AF.request("\(Constants.baseURL)/boards?lastBoardId=100&size=20&loginNickname=\(senderNickname)&keyword=".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",method: .get, parameters: nil ).validate(statusCode: 200..<500).responseDecodable(of: AllPostModel.self) { response in
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

extension SearchViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 3
        return CGSize(width: width-1, height: width-1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPostModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        
        let model = allPostModel[indexPath.row]
        cell.SearchConfig(with: SearchFeedViewModel(boardId: model.boardId ?? -1, imageUrl: model.imageUrl?.first ?? ""))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell indexPath = \(indexPath)")
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let model = allPostModel[indexPath.row]
        
        let vc = DetailPostViewController()
        vc.detailPostModel = [model]
        vc.hidesBottomBarWhenPushed = true
        print("detailPostModel에 data 저장됨")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController {
    // 새로고침
    @objc func beginRefresh(_ sender: UIRefreshControl) {
        print("beginRefresh!")
        sender.endRefreshing()
//        requestFunc()
    }
}

extension SearchViewController : UISearchResultsUpdating{
    func attribute() {
        view.backgroundColor = .systemBackground
        
        navigationController?.hidesBarsOnSwipe = true
        
//        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
//        navigationItem.titleView?.isHidden = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
//        navigationItem.titleView = searchController.searchBar
        self.navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .black
        searchController.searchResultsUpdater = self

        refreshControl.addTarget(self, action: #selector(beginRefresh(_:)), for: .valueChanged)
        exploreCollectionView.refreshControl = refreshControl
        
        exploreCollectionView.dataSource = self
        exploreCollectionView.delegate = self
        exploreCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        
        
    }
    func layout() {
        view.addSubview(exploreCollectionView)
        exploreCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension SearchViewController : UISearchControllerDelegate  {
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        guard let text = searchBar.text,
              !text.trimmingCharacters(in: .whitespaces).isEmpty,
              text.trimmingCharacters(in: .whitespaces).count >= 0,
              // resultController는 입력한 결과값이 나오는 searchResultViewController
              let resultController = searchController.searchResultsController as? SearchListViewController else {return}
        
        print(resultController)
        
        AF.request("\(Constants.baseURL)/boards?lastBoardId=100&size=20&keyword=\(text)&loginNickname=\(senderNickname)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" ,method: .get, parameters: nil ).validate().responseDecodable(of: AllPostModel.self) { response in
            DispatchQueue.main.async {
                print(text)
                debugPrint(response)
                switch(response.result) {
                case .success(let result) :
                    print("검색 UI 서버 통신 성공 - \(result)")
                    print(text)
                    switch(result.status) {
                    case 200:
                        guard let data = result.data else {return}
                        resultController.successSearchViewPostModel(result: data)
                        resultController.searchFeedTable.reloadData()
                    case 404:
                        print("데이터가 없는 경우입니다. - \(result.message)")
                        
                        // 검색 결과가 없을 때
                        resultController.successSearchViewPostModel(result: [])
                        resultController.searchFeedTable.reloadData()
                    default:
                        print("데이터베이스 오류")
                        return
                    }
                case .failure(let error):
                    // 검색이 실패했을 때도 검색 AlPostData에 nill을 넣어줌
                    resultController.successSearchViewPostModel(result: [])
                    resultController.searchFeedTable.reloadData()
                    print(error)
                }
                
            }
        }
        
        
    }


    // when clicked searchButton in keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchController.searchBar.text else { return }
//        searchBtnClicked()
//        SearchListViewController().viewWillAppear(true)
        print("search result : ", text)
    }
    
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
