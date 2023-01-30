//
//  SettingViewController.swift
//  My Reform
//
//  Created by 최성우 on 2023/01/30.
//

import UIKit
import SnapKit
import Alamofire
import Then
import SDWebImage

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        // Do any additional setup after loading the view.
    }
    

    func configureNavbar() {
        var image = UIImage(named: "settingLabel")?.resize(newWidth: 29)
        image = image?.withRenderingMode(.alwaysOriginal)
        
//        var image2 = UIImage(named: "backButton")?.resize(newWidth: 10.02)
//        image2 = image2?.withRenderingMode(.alwaysOriginal)
        
//        let settingBtn = UIBarButtonItem(image: image2, style: .done, target:self, action: #selector(settingClicked))
        
        self.navigationItem.titleView = UIImageView(image: image)
//        self.navigationItem.rightBarButtonItem = settingBtn
        
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .label
    }

}
