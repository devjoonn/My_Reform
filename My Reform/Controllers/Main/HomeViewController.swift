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
        self.homeFeedTable.reloadData()
    }
    
    
    // 데이터 새로고침
//    private func fetchUpcoming() {
//        APICaller.shared.메소드이름 { [weak self] result in
//            switch result {
//            case .success(let titles):
//                self?.titles = titles
//                DispatchQueue.main.async {
//                    self?.homeFeedTable.reloadData()
//                }
//            case.failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    
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
        self.allPostModel = result
        print(allPostModel.count)
        
    }
    
}



//MARK: -- TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPostModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }

        
        let model = allPostModel[indexPath.row]
//        guard let model = allPostModel[indexPath.row] else { return UITableViewCell() } //현재 model 은 옵셔널 스트링 값
        guard let price = model.price else { return UITableViewCell()}
//        cell.titleCellImageView =
        cell.configure(with: HomeFeedViewModel(imageUrl: model.imageUrl?[0] ?? "", title: model.title ?? "", minute: model.updateAt ?? "", price: price))
        
        
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
    
    //상단 네비게이션바가  스크롤하면 같이 올라가게 만듬
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let defaultOffset = view.safeAreaInsets.top
//        let offset = scrollView.contentOffset.y + defaultOffset
//
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
//    }
}

