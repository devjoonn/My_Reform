//
//  NotificationViewController.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/15.
//

import UIKit
import PhotosUI
import SnapKit

class ModifyViewController: UIViewController, UITabBarControllerDelegate {
    
    let senderNickname : String = UserDefaults.standard.object(forKey: "senderNickname") as! String
    
    var modifyPostModel: [AllPostData] = []
    
    var categorysIndex: [Int] = []
    var categoryString: String = ""
    
    var keyBoardUp: Bool = false
    
    // 서버로 전달한 가격(콤마x)
    var price_value: Int = 0
    let categoryList: [String] = [" ", "디지털기기", "생활/소품", "스포츠/레저", "가구/인테리어", "여성의류", "여성잡화", "남성의류", "남성잡화", "그림", "기타"]
    
    let imagePickerView = UIImageView()
    let cameraIcon = UIImageView().then {
        let logo = UIImage(named: "camera.png")
        $0.image = logo
    }
    let imagePickerButton = UIButton()
    let numberOfSelectedImageLabel = UILabel()
    let titleTextField = UITextField()
    let descriptionTextView = UITextView()
    let descriptionTextCnt = UILabel()
    let separatorView = UIView()
    let separatorView1 = UIView()
    let separatorView2 = UIView()
    let separatorView3 = UIView()
    let separatorView4 = UIView()
    let separatorView5 = UIView()
    let categoryLabel = UILabel()
    let categoryLabel2 = UILabel()
    
    
    // flowLayout 인스턴스
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8.0
        return layout
    }()
    
    // 컬렉션뷰 인스턴스
    lazy var categoryScroll: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.contentInset = .zero
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(UploadViewCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let wonLabel = UILabel()
    let priceTextField = UITextField()
    
    
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
        setKeyboardObserver()
    }
    
    //0206 수정했을 시 데이터가 불러오는지 테스트해야함 [X]
    override func viewWillAppear(_ animated: Bool) {
        titleTextField.text = modifyPostModel.first?.title
        categorysIndex = (modifyPostModel.first?.categoryId!)!
        for i in 0 ..< categorysIndex.count {
            check[categorysIndex[i]] = 1
        }
        clickCnt = categorysIndex.count
        guard let price = modifyPostModel.first?.price else {return}
        
        priceTextField.text = String(describing: price)
        descriptionTextView.text = modifyPostModel.first?.contents
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 뷰가 사라질 때 값 초기화
        clickCnt = 0
        selectedImages.removeAll()
        check = [0,0,0,0,0,0,0,0,0,0,0]
        price_value = 0
        titleTextField.text = ""
        categorysIndex = []
        priceTextField.text = ""
        descriptionTextView.text = ""
        print("작성화면 꺼지고 값들 초기화")
    }
    
    // 수정이 완료되면 실행되는 함수
    func successedModify() {
        ToastService.shared.showToast("게시물 업데이트에 성공했습니다.")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

// 컬랙션뷰의 cell 안의 요소에 맞게 동적으로 사이즈 설정
extension ModifyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let name = self.categoryList[indexPath.row+1]
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        let nameSize = (name as NSString).size(withAttributes: attributes as [NSAttributedString.Key: Any])
        return CGSize(width: (nameSize.width+18), height: 35)
    }
    
}
//컬력센뷰
extension ModifyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.categoryList.count-1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UploadViewCollectionViewCell.id, for: indexPath) as! UploadViewCollectionViewCell
        cell.prepare(l: self.categoryList[indexPath.item+1])
        
        // check 인덱스의 해당 값이 0이면 선택되지 않은 cell이니 해당 값으로 초기화
        if check[indexPath.row+1] == 0 {
            cell.onDeselected()
        } else {
            cell.onSelected()
        }
        
        return cell
    }
}

extension ModifyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 클릭된 셀을 가져옴
        let cell = collectionView.cellForItem(at: indexPath) as! UploadViewCollectionViewCell
        clickCnt += 1
        // 가져온 셀의 clickCount를 판단, 셀이 세개만 클릭되도록 함
        if cell.clickCount == 1 {
            // clickCount가 1이면 이미 선택되어 있는 셀이므로 다시 회색으로 바꿔줘야 함 -> 값을 0으로 변경
            check[indexPath.row+1] = 0
            cell.clickCount = 0
            clickCnt -= 2
        } else if clickCnt > 3 {
            clickCnt -= 1
            return
        } else {
            cell.clickCount += 1
            check[indexPath.row+1] = 1
        }
        print(cell.btn.titleLabel?.text ?? " " , clickCnt)
        print(indexPath)
    }
    
}

extension ModifyViewController {
    // 뒤로가기 버튼
    @objc func didTapLeftBarButton() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.01, execute:{ self.tabBarController?.tabBar.isHidden = false})
        
        dismiss(animated: true)
    }
    
    // 완료버튼 누를 때
    @objc func didTapRightBarButton() {
        var selectedCategory : [Int] = [] // 선택된 categoryID
        
        for i in 1...10 {
            if check[i] == 1{
                selectedCategory.append(i)
            }
        }
        print("selectedCategory :", selectedCategory)
        print("price_value :", price_value)
        // 아이디 카테고리 이미지 남음
        
        let userData = UploadInput(nickname: senderNickname, categoryId: selectedCategory, title: titleTextField.text ?? "", contents: descriptionTextView.text, price: price_value)
        ModifyPostDataManager.Modifyposts(self, userData, selectedImages, (modifyPostModel.first?.boardId)!)
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
    
    // 서버에 게시물 전송이 완료되었을 때 실행되는 함수
    func successPost() {
        print("successPost() called - view pop")
        navigationController?.popViewController(animated: true)
    }
}

extension ModifyViewController : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        // 이미지 다시 선택 시 배열 초기화 작업
        selectedImages.removeSubrange(0..<selectedImages.count)
        
        if !results.isEmpty {
            
            results.forEach { result in
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                        guard let self = self else { return }
                        if let image = image as? UIImage {
                            self.selectedImages.append(image)
                            DispatchQueue.main.async {
                                //                                self.imagePickerView.image = image
                                self.numberOfSelectedImageLabel.text = "사진 업로드 하기 \(self.selectedImages.count) / 5"
                                print(self.selectedImages.count)
                                print(self.selectedImages)
                            }
                        }
                        
                        if let error = error {
                            print("ERROR - UploadFeedViewController - PHPickerViewControllerDelegate - \(error.localizedDescription)")
                        }
                    }
                }
            }
            
        }
        print("results:", results)
        dismiss(animated: true)
        
    }
}

extension ModifyViewController : UITextViewDelegate, UITextFieldDelegate {
    func attribute() {
        title = "마이리폼 등록"
        view.backgroundColor = .systemBackground
        
        //        imagePickerView.backgroundColor = .secondarySystemBackground
        imagePickerView.layer.borderColor = UIColor.gray.cgColor
        imagePickerView.layer.borderWidth = 1.5
        imagePickerButton.addTarget(self, action: #selector(didTapImagePickerButton), for: .touchUpInside)
        imagePickerView.layer.cornerRadius = 25
        numberOfSelectedImageLabel.text = "사진 업로드 하기 \(selectedImages.count) / 5"
        numberOfSelectedImageLabel.font = .systemFont(ofSize: 16.0, weight: .thin)
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
        categoryLabel2.text = "최대 3개"
        categoryLabel2.font = .systemFont(ofSize: 10)
        categoryScroll.delegate = self
        categoryScroll.dataSource = self
        
        
        wonLabel.text = "￦"
        wonLabel.font = .boldSystemFont(ofSize: 22.0)
        
        priceTextField.placeholder = "가격 입력"
        priceTextField.addLeftPaddingMulty()
        priceTextField.delegate = self
        
        descriptionTextView.text = "어떤 상품을 어떻게 리폼했는지, 거래 방법 및 거래 장소 등을 자유롭게 작성해주세요."
        descriptionTextView.delegate = self
        descriptionTextView.textColor = .secondaryLabel
        
        descriptionTextCnt.font = .systemFont(ofSize: 12)
        descriptionTextCnt.textColor = .secondaryLabel
        descriptionTextCnt.text = "\(descriptionTextView.text.count)/1000"
        
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
            categoryLabel2,
            categoryScroll,
            separatorView3,
            wonLabel,
            priceTextField,
            separatorView4,
            descriptionTextView,
            separatorView5,
            descriptionTextCnt
        ].forEach { view.addSubview($0) }
        
        separatorView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(0.5)
        }
        imagePickerView.snp.makeConstraints { (make) in
            make.width.equalTo(219)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.top.equalTo(separatorView.snp.bottom).offset(commonInset)
        }
        imagePickerButton.translatesAutoresizingMaskIntoConstraints = false
        imagePickerButton.widthAnchor.constraint(equalTo: imagePickerView.widthAnchor).isActive = true
        imagePickerButton.heightAnchor.constraint(equalTo: imagePickerView.heightAnchor).isActive = true
        imagePickerButton.centerXAnchor.constraint(equalTo: imagePickerView.centerXAnchor).isActive = true
        imagePickerButton.centerYAnchor.constraint(equalTo: imagePickerView.centerYAnchor).isActive = true
        
        cameraIcon.snp.makeConstraints { (make) in
            make.top.equalTo(imagePickerView.snp.top).offset(10.0)
            make.leading.equalTo(imagePickerView.snp.leading).offset(19.83)
        }
        numberOfSelectedImageLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfSelectedImageLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(imagePickerView.snp.centerY)
            make.leading.equalTo(cameraIcon.snp.trailing).offset(3.17)
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
        categoryLabel2.snp.makeConstraints { (make) in
            make.leading.equalTo(categoryLabel.snp.trailing).offset(5)
            make.bottom.equalTo(categoryLabel.snp.bottom).inset(1)
        }
        categoryScroll.snp.makeConstraints { (make) in
            make.leading.equalTo(categoryLabel.snp.leading)
            make.trailing.equalToSuperview()
            make.top.equalTo(categoryLabel.snp.bottom).offset(5)
            make.height.equalTo(50)
        }
        separatorView3.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(categoryScroll.snp.bottom).inset(5)
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
        descriptionTextCnt.snp.makeConstraints { (make) in
            make.bottom.equalTo(separatorView5.snp.top).offset(-10)
            make.trailing.equalTo(descriptionTextView.snp.trailing).inset(6)
        }
        
        
    }
    
    func setupNavigationBar() {
        navigationItem.title = "마이리폼 등록"
        
        let rightBarButtonItem = UIBarButtonItem(
            title: "완료", style: .plain, target: self, action: #selector(didTapRightBarButton)
        )
        rightBarButtonItem.tintColor = .systemRed
        navigationItem.leftBarButtonItem?.target = self
        navigationItem.leftBarButtonItem?.action = #selector(didTapLeftBarButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        keyBoardUp = true
        if textView.textColor == .secondaryLabel {
            textView.text = ""
            textView.textColor = .label
        }
        descriptionTextCnt.text = "\(descriptionTextView.text.count)/1000"
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = descriptionTextView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {return false}
        let changeText = currentText.replacingCharacters(in: stringRange, with: text)
        descriptionTextCnt.text = "\(changeText.count)/1000"
        
        return true
    }
    
    
    
    // TextField Return 클릭 시
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.titleTextField {
            self.priceTextField.becomeFirstResponder()
        } else if textField == self.priceTextField {
            self.descriptionTextView.becomeFirstResponder()
        } else if textField == self.descriptionTextView {
            self.descriptionTextView.resignFirstResponder()
        }
        return true
    }
}

extension ModifyViewController {
    // price(가격) 세단위 마다 쉼표 표시
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard var text = textField.text else {
            return true
        }
        
        text = text.replacingOccurrences(of: "원", with: "")
        text = text.replacingOccurrences(of: ",", with: "")
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if (string.isEmpty) {
            // delete
            if text.count > 1 {
                guard let price = Int.init("\(text.prefix(text.count - 1))") else {
                    return true
                }
                guard let result = numberFormatter.string(from: NSNumber(value:price)) else {
                    return true
                }
                
                textField.text = "\(result)원"
            }
            else {
                textField.text = ""
            }
        }
        else {
            guard let price = Int.init("\(text)\(string)") else {
                return true
            }
            guard let result = numberFormatter.string(from: NSNumber(value:price)) else {
                return true
            }
            textField.text = "\(result)"
        }
        
        
        // 콤마 제거 후
        guard let number: NSNumber = numberFormatter.number(from: textField.text ?? "") else {return true}
        // price_value에 값 저장
        price_value = Int(number.stringValue) ?? 0
        
        return false
    }
    
    //MARK: - 키보드 처리
    
    // 노티피케이션을 추가하는 메서드
    func setKeyboardObserver() {
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object:nil)
    }
    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyBoardUp == false {
            return
        }
        // 키보드의 높이만큼 화면을 올려준다.
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 1) {
                self.view.window?.frame.origin.y -= keyboardHeight
            }
            
        }
        keyBoardUp = false
        
        
    }
    
    // 화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.descriptionTextView.resignFirstResponder()
        self.titleTextField.resignFirstResponder()
        self.priceTextField.resignFirstResponder()
    }
    
    
    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(notification: NSNotification) {
        
        // 키보드의 높이만큼 화면을 내려준다.
        if self.view.window?.frame.origin.y != 0 {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                
                UIView.animate(withDuration: 1) {
                    self.view.window?.frame.origin.y = 0
                }
            }
        }
    }
}
