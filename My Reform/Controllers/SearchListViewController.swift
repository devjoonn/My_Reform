//
//  SearchListViewController.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/01/23.
//

import UIKit

class SearchListViewController: UIViewController {
    
//    private let searchController = UISearchController(searchResultsController: searchList)
    

//    public var titles: [Title] = [Title]()

    public let searchResultsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        // 스크린의 넓이 기준으로 3으로 나누고 -10을 함 || 다른 핸드폰 기종들 고려
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBlue
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)

        
        
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }

    
    

}

extension SearchListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
//        let title = titles[indexPath.row]
//        cell.configure(with: title.poster_path ?? "")
        
        return cell
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
