//
//  NotificationViewController.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/15.
//

import UIKit
import PhotosUI
import SnapKit

class UploadViewController: UIViewController, UITabBarControllerDelegate {
    
//    private let firebaseDBManager = firebaseDBManager()
//    private let firebaseAuthManager = firebaseAuthManager()
    
    let imagePickerView = UIImageView()
    let cameraIcon = UIImageView().then {
        let logo = UIImage(named: "camera.png")
        $0.image = logo
    }
    let imagePickerButton = UIButton()
    let numberOfSelectedImageLabel = UILabel()
    let titleTextField = UITextField()
    let descriptionTextView = UITextView()
    let separatorView = UIView()
    let separatorView1 = UIView()
    let separatorView2 = UIView()
    let separatorView3 = UIView()
    let separatorView4 = UIView()
    let separatorView5 = UIView()
    let categoryLabel = UILabel()
    let categoryLayout = UICollectionViewFlowLayout()
    let wonLabel = UILabel()
    let priceTextField = UITextField()
    
//    let separatorView = UIView()
//    let optionsTableView = UITableView()
//    let activityIndicatorView = UIActivityIndicatorView()
    
    private var selectedImages = [UIImage]()
    
    let options = [
        "제목",
        "카테고리",
        "가격 입력",
        "상세 내용"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        descriptionTextView.resignFirstResponder()
    }
}

extension UploadViewController {
    @objc func didTapLeftBarButton() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.01, execute:{ self.tabBarController?.tabBar.isHidden = false})

                dismiss(animated: true)
    }
    
    // 완료버튼 누를 때
    @objc func didTapRightBarButton() {
        // 아이디 카테고리 이미지 남음
        let userData = UploadInput(id: "2", categoryId: [1], title: titleTextField.text ?? "", contents: descriptionTextView.text, price: Int(priceTextField.text!) ?? -1)
//        , images:  "camera.png"
        UploadDataManager.posts(self, userData)
        dismiss(animated: true)
        print("didTapRightBarButton is Called")
        
    }
    @objc func didTapImagePickerButton() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selection = .ordered
        config.selectionLimit = 5
        let imagePickerViewController = PHPickerViewController(configuration: config)
        imagePickerViewController.delegate = self
        present(imagePickerViewController, animated: true)
    }
}
extension UploadViewController : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
            if !results.isEmpty {
            selectedImages = []
            results.forEach { result in
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                        guard let self = self else { return }
                        if let image = image as? UIImage {
                            self.selectedImages.append(image)
                            DispatchQueue.main.async {
                                self.imagePickerView.image = image
                                self.numberOfSelectedImageLabel.text = "\(self.selectedImages.count)"
                                print(self.selectedImages.count)
                            }
                        }
                        if let error = error {
                            print("ERROR - UploadFeedViewController - PHPickerViewControllerDelegate - \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        dismiss(animated: true)
    }
}

extension UploadViewController : UITextViewDelegate {
    func attribute() {
        title = "마이리폼 등록"
        view.backgroundColor = .systemBackground
        
        imagePickerView.backgroundColor = .secondarySystemBackground
        imagePickerButton.addTarget(self, action: #selector(didTapImagePickerButton), for: .touchUpInside)
        numberOfSelectedImageLabel.text = "\(selectedImages.count)/5"
        numberOfSelectedImageLabel.font = .systemFont(ofSize: 16.0, weight: .semibold)
        numberOfSelectedImageLabel.textAlignment = .center
        
        descriptionTextView.font = .systemFont(ofSize: 16.0, weight: .regular)
        descriptionTextView.text = "어떤 상품을 어떻게 리폼했는지, 거래 방법 및 거래 장소 등을 자유롭게 작성해주세요"
        descriptionTextView.textColor = .secondaryLabel
        descriptionTextView.delegate = self
        
        separatorView.backgroundColor = .separator
        separatorView1.backgroundColor = .separator
        separatorView2.backgroundColor = .separator
        separatorView3.backgroundColor = .separator
        separatorView4.backgroundColor = .separator
        separatorView5.backgroundColor = .separator
        
        titleTextField.placeholder = "제목"
        titleTextField.addLeftPadding()
        
        categoryLabel.text = "카테고리"
        categoryLabel.font = .boldSystemFont(ofSize: 16.0)
        
        /*
            카테고리 버튼 넣는 곳
        */
        
        wonLabel.text = "￦"
        wonLabel.font = .boldSystemFont(ofSize: 22.0)
        
        priceTextField.placeholder = "가격 입력"
        priceTextField.addLeftPaddingMulty()
        
        descriptionTextView.text = "어떤 상품을 어떻게 리폼했는지, 거래 방법 및 거래 장소 등을 자유롭게 작성해주세요."
        descriptionTextView.delegate = self
        descriptionTextView.textColor = .secondaryLabel
        
    }
    func layout() {
        let commonInset: CGFloat = 16.0
        
        [
            separatorView,
            imagePickerView,
            imagePickerButton,
            numberOfSelectedImageLabel,
            descriptionTextView,
            separatorView1,
            cameraIcon,
            titleTextField,
            separatorView2,
            categoryLabel,
            separatorView3,
            wonLabel,
            priceTextField,
            separatorView4,
            descriptionTextView,
            separatorView5
        ].forEach { view.addSubview($0) }
        
        separatorView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(0.5)
        }
        
        imagePickerView.snp.makeConstraints { (make) in
            make.width.height.equalTo(100.0)
            make.leading.equalToSuperview().inset(commonInset)
            make.top.equalTo(separatorView.snp.bottom).offset(commonInset)
        }
        
        imagePickerButton.translatesAutoresizingMaskIntoConstraints = false
        imagePickerButton.widthAnchor.constraint(equalTo: imagePickerView.widthAnchor).isActive = true
        imagePickerButton.heightAnchor.constraint(equalTo: imagePickerView.heightAnchor).isActive = true
        imagePickerButton.centerXAnchor.constraint(equalTo: imagePickerView.centerXAnchor).isActive = true
        imagePickerButton.centerYAnchor.constraint(equalTo: imagePickerView.centerYAnchor).isActive = true
        
        cameraIcon.snp.makeConstraints { (make) in
            make.top.equalTo(imagePickerView.snp.top).offset(14.0)
            make.centerX.equalTo(imagePickerView.snp.centerX)
        }
        
        numberOfSelectedImageLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfSelectedImageLabel.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(24)
            make.top.equalTo(cameraIcon.snp.bottom).offset(10)
            make.centerX.equalTo(imagePickerView.snp.centerX)
        }
        
        separatorView1.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(imagePickerView.snp.bottom).offset(commonInset)
            make.height.equalTo(0.5)
        }
        titleTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(separatorView1.snp.bottom).offset(commonInset)
            make.height.equalTo(30)
        }
        separatorView2.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(titleTextField.snp.bottom).offset(commonInset)
            make.height.equalTo(0.5)
        }
        categoryLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleTextField.snp.leading).offset(10)
            make.top.equalTo(separatorView2.snp.bottom).offset(commonInset)
        }
        
        /*
         
         카테코리 종류 넣는 곳
         
        */
        
        separatorView3.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(categoryLabel.snp.bottom).offset(commonInset)
            make.height.equalTo(0.5)
        }
        wonLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(categoryLabel.snp.leading)
            make.top.equalTo(separatorView3.snp.bottom).offset(commonInset+2)
        }
        priceTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(separatorView3.snp.bottom).offset(commonInset)
            make.height.equalTo(30)
        }
        separatorView4.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(priceTextField.snp.bottom).offset(commonInset)
            make.height.equalTo(0.5)
        }
        descriptionTextView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(separatorView4.snp.bottom).offset(commonInset)
            make.bottom.equalTo(separatorView5.snp.top).offset(commonInset)
        }
        separatorView5.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(commonInset)
            make.height.equalTo(0.5)
        }
        
        
        
//        numberOfSelectedImageLabel.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
//        numberOfSelectedImageLabel.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
//        numberOfSelectedImageLabel.bottomAnchor.constraint(equalTo: imagePickerView.bottomAnchor, constant: -8.0).isActive = true
//        numberOfSelectedImageLabel.centerXAnchor.constraint(equalTo: imagePickerView.centerXAnchor, constant: 0).isActive = true
        
        
        
    }
    
    func setupNavigationBar() {
        navigationItem.title = "마이리폼 등록"
//        let leftBarButtonItem = UIBarButtonItem()
//        leftBarButtonItem.action = #selector(didTapLeftBarButton)
        
        let rightBarButtonItem = UIBarButtonItem(
            title: "완료", style: .plain, target: self, action: #selector(didTapRightBarButton)
        )
        rightBarButtonItem.tintColor = .systemRed
        navigationItem.leftBarButtonItem?.target = self
        navigationItem.leftBarButtonItem?.action = #selector(didTapLeftBarButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.text = ""
            textView.textColor = .label
        }
    }
}

//extension UploadViewController : UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return options.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsTableViewCell", for: indexPath)
//
//    }
//
//
//}
