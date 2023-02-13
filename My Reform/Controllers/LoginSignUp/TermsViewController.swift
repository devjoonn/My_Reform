//
//  TermsViewController.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/09.
//

import UIKit
import SnapKit
import Then

class TermsViewController: UIViewController {

    // 다음 버튼 활성화 변수
    var isnextBtnEnabled = false{
        didSet{
            self.nextBtnEnabled()
        }
    }
    
    private let serviceLabel = UILabel().then {
        $0.text = "서비스 이용동의"
        $0.font = UIFont(name: "Pretendard-Bold", size: 28)
    }
    
    private let checkBoxAll = UIButton().then{
        $0.setImage(UIImage(named: "check_fill"), for: .selected)
        $0.setImage(UIImage(named: "check"), for: .normal)
    }
    
    private let TermAllLabel = UILabel().then {
        $0.text = "약관 전체동의"
        $0.font = UIFont(name: "Pretendard-Bold", size: 21)
    }
    
    private let checkBox1 = UIButton().then{
        $0.setImage(UIImage(named: "check_fill"), for: .selected)
        $0.setImage(UIImage(named: "check"), for: .normal)
    }
    
    private let Label1 = UILabel().then {
        $0.text = "만 14세 이상입니다."
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
    
    private let checkBox2 = UIButton().then{
        $0.setImage(UIImage(named: "check_fill"), for: .selected)
        $0.setImage(UIImage(named: "check"), for: .normal)
    }
    
    private let Label2 = UILabel().then {
        $0.text = "(필수) 서비스 이용 약관"
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
    
    private let termBtn1 = UIButton().then{
        $0.tintColor = .black
        $0.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
    }
    
    private let checkBox3 = UIButton().then{
        $0.setImage(UIImage(named: "check_fill"), for: .selected)
        $0.setImage(UIImage(named: "check"), for: .normal)
    }
    
    private let Label3 = UILabel().then {
        $0.text = "(필수) 개인정보 처리방침"
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
    
    private let termBtn2 = UIButton().then{
        $0.tintColor = .black
        $0.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
    }
    
    private let checkBox4 = UIButton().then{
        $0.setImage(UIImage(named: "check_fill"), for: .selected)
        $0.setImage(UIImage(named: "check"), for: .normal)
    }
    
    private let Label4 = UILabel().then {
        $0.text = "(선택) 마케팅 정보 수신동의"
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
    
    private let nextButton = UIButton().then{
        $0.backgroundColor = UIColor.mainColor.withAlphaComponent(0.4)
        $0.titleLabel?.font = UIFont(name: "Pretendard-bold", size: 16)
        $0.layer.cornerRadius = 8
        $0.setTitle("다음", for: .normal)
        $0.isEnabled = false
    }
    
    
    private let sectionLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
    
        self.navigationController?.navigationBar.isHidden = false
        
        // 뒤로가기 버튼 < 만 출력
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
            backBarButtonItem.tintColor = .black
            self.navigationItem.backBarButtonItem = backBarButtonItem
        
        
        setUIView()
        setUIConstraints()
        addTargets()
    }

    
    
    func setUIView() {
        view.addSubview(serviceLabel)
        view.addSubview(checkBoxAll)
        view.addSubview(TermAllLabel)
        view.addSubview(nextButton)
        view.addSubview(sectionLine)
        view.addSubview(Label1)
        view.addSubview(Label2)
        view.addSubview(Label3)
        view.addSubview(Label4)
        view.addSubview(checkBox1)
        view.addSubview(checkBox2)
        view.addSubview(checkBox3)
        view.addSubview(checkBox4)
        view.addSubview(termBtn1)
        view.addSubview(termBtn2)
    }
    
    func setUIConstraints() {
        serviceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(25)
            make.leading.equalToSuperview().inset(32)
        }
        
        checkBoxAll.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalTo(serviceLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(35)
        }
        
        TermAllLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkBoxAll.snp.trailing).offset(12)
            make.top.equalTo(serviceLabel.snp.bottom).offset(30)
            make.centerY.equalTo(checkBoxAll.snp.centerY)
        }
        
        sectionLine.snp.makeConstraints { make in
            make.top.equalTo(TermAllLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
            make.height.equalTo(1)
            
        }
        
        checkBox1.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalTo(sectionLine.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(35)
        }
        
        Label1.snp.makeConstraints { make in
            make.leading.equalTo(checkBox1.snp.trailing).offset(12)
            make.top.equalTo(sectionLine.snp.bottom).offset(30)
            make.centerY.equalTo(checkBox1.snp.centerY)
        }
        
        checkBox2.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalTo(checkBox1.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(35)
        }
        
        Label2.snp.makeConstraints { make in
            make.leading.equalTo(checkBox2.snp.trailing).offset(12)
            make.top.equalTo(Label1.snp.bottom).offset(30)
            make.centerY.equalTo(checkBox2.snp.centerY)
        }
        
        termBtn1.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.centerY.equalTo(Label2.snp.centerY)
            
        }
        
        checkBox3.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalTo(checkBox2.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(35)
        }
        
        Label3.snp.makeConstraints { make in
            make.leading.equalTo(checkBox3.snp.trailing).offset(12)
            make.top.equalTo(Label2.snp.bottom).offset(30)
            make.centerY.equalTo(checkBox3.snp.centerY)
        }
        
        termBtn2.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.centerY.equalTo(Label3.snp.centerY)
            
        }
        
        checkBox4.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalTo(checkBox3.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(35)
        }
        
        Label4.snp.makeConstraints { make in
            make.leading.equalTo(checkBox4.snp.trailing).offset(12)
            make.top.equalTo(Label3.snp.bottom).offset(30)
            make.centerY.equalTo(checkBox4.snp.centerY)
        }
        
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(33)
            make.leading.trailing.equalToSuperview().inset(26.5)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func addTargets() {
        // 서비스 이용약관 자세히 보기
        termBtn1.addTarget(self, action: #selector(moveUserServiceAllow), for: .touchUpInside)
        // 개인정보 처리방침 자세히 보기
        termBtn2.addTarget(self, action: #selector(moveUserPrivacyAllow), for: .touchUpInside)
        // 약관 전체동의 클릭 시
        checkBoxAll.addTarget(self, action: #selector(AllCheck), for: .touchUpInside)
        checkBoxAll.addTarget(self, action: #selector(checkBoxAllClicked), for: .touchUpInside)
        checkBoxAll.addTarget(self, action: #selector(essentialCheckBtnDidClicked), for: .touchUpInside)
        // 15세 이상 클릭 시
        checkBox1.addTarget(self, action: #selector(overagedidCheck), for: .touchUpInside)
        checkBox1.addTarget(self, action: #selector(essentialCheckBtnDidClicked), for: .touchUpInside)
        // 서비스 이용 동의 클릭 시
        checkBox2.addTarget(self, action: #selector(privacydidCheck), for: .touchUpInside)
        checkBox2.addTarget(self, action: #selector(essentialCheckBtnDidClicked), for: .touchUpInside)
        // 개인정보 동의 클릭 시
        checkBox3.addTarget(self, action: #selector(useServicedidCheck), for: .touchUpInside)
        checkBox3.addTarget(self, action: #selector(allCheckBoxDidClicked), for: .touchUpInside)
        checkBox3.addTarget(self, action: #selector(essentialCheckBtnDidClicked), for: .touchUpInside)
        // 마케팅 동의 클릭 시
        checkBox4.addTarget(self, action: #selector(marketingdidCheck), for: .touchUpInside)
        checkBox4.addTarget(self, action: #selector(allCheckBoxDidClicked), for: .touchUpInside)
        checkBox4.addTarget(self, action: #selector(essentialCheckBtnDidClicked), for: .touchUpInside)
        // 다음 버튼 클릭 시
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        
    }
    
    @objc func moveUserServiceAllow() {
        let vc = UserServiceAllowViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func moveUserPrivacyAllow() {
        let vc = UserPrivacyAllowViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - 핋수적 다음버튼
    @objc func nextBtnEnabled() {
        if isnextBtnEnabled{
            self.nextButton.isEnabled = true
            nextButton.backgroundColor = UIColor.mainColor
        }else{
            self.nextButton.isEnabled = false
            nextButton.backgroundColor = UIColor.mainColor.withAlphaComponent(0.4)
        }
    }
    
    //MARK: - 각각의 체크 버튼 클릭 시
    @objc func AllCheck() {
        if checkBoxAll.isSelected{
            checkBoxAll.isSelected = false
        } else {checkBoxAll.isSelected = true}
    }
    
    @objc func overagedidCheck() {
        if checkBox1.isSelected{
            checkBox1.isSelected = false
        } else {checkBox1.isSelected = true}
    }
    
    @objc func privacydidCheck() {
        if checkBox2.isSelected{
            checkBox2.isSelected = false
        } else {checkBox2.isSelected = true}
    }
    
    @objc func useServicedidCheck() {
        if checkBox3.isSelected{
            checkBox3.isSelected = false
        } else {checkBox3.isSelected = true}
    }
    
    @objc func marketingdidCheck() {
        if checkBox4.isSelected{
            checkBox4.isSelected = false
        } else {checkBox4.isSelected = true}
    }
    
    //MARK: - 모두 체크 버튼 클릭 시
    @objc private func checkBoxAllClicked() {
        
        if checkBoxAll.isSelected == true {
            checkBox1.isSelected = true
            checkBox2.isSelected = true
            checkBox3.isSelected = true
            checkBox4.isSelected = true
        }
         else {
            checkBox1.isSelected = false
            checkBox2.isSelected = false
            checkBox3.isSelected = false
            checkBox4.isSelected = false
        }
    }

    @objc func allCheckBoxDidClicked() {
        if  checkBox1.isSelected == true && checkBox2.isSelected == true
            && checkBox3.isSelected == true && checkBox4.isSelected == true {
            checkBoxAll.isSelected = true
        } else {
            checkBoxAll.isSelected = false
        }
    }
    
    
    //MARK: - 다음 버튼 클릭 시 마케팅동의 SignUpViewController 로 넘김
    @objc private func nextButtonClicked() {
        let vc = SignUpViewController()
        vc.marketingAllow = checkBox4.isSelected
        self.navigationController?.pushViewController(vc, animated: true)
        print("해당 유저 마케팅 동의 확인 - \(checkBox4.isSelected)")
    }
    
    //MARK: - 필수항목 2개가 되었을 시 버튼 활성화
    @objc private func essentialCheckBtnDidClicked() {
        if checkBox2.isSelected == false || checkBox3.isSelected == false {
            isnextBtnEnabled = false
            
        } else {
            isnextBtnEnabled = true
        }
    }
    
    

}


