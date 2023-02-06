//
//  AppDelegate.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/06.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    var navigationController : UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        moveSplashViewController()
        sleep(2)
        // Override point for customization after application launch.
        if (UserDefaults.standard.string(forKey: "senderNickname") != nil){
            print("UserDefault 값이 있음")
            moveHomeViewController()
        }else {
            print("UserDefault 값이 없음")
            moveLoginViewController()
        }
        
        func moveHomeViewController(){
            self.window = UIWindow(frame: UIScreen.main.bounds)
            navigationController = UINavigationController(rootViewController: MainTabBarViewController())
            self.window?.rootViewController = navigationController
            self.navigationController?.navigationBar.isHidden = true
            self.window?.makeKeyAndVisible()
            self.window?.backgroundColor = .white
        }
        
        func moveLoginViewController(){
            self.window = UIWindow(frame: UIScreen.main.bounds)
            navigationController = UINavigationController(rootViewController: LoginViewController())
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
            self.window?.backgroundColor = .white
        }
        
        func moveSplashViewController() {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = SplashViewController()
            self.window?.makeKeyAndVisible()
            self.window?.backgroundColor = .white
        }
        
        func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return UIInterfaceOrientationMask.portrait
        }
        
        
        let NATIVE_APP_KEY = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        
        //KAKAOSDK 초기화
        KakaoSDK.initSDK(appKey: NATIVE_APP_KEY as! String) // NATIVE_APP_KEY
                
        return true
    }
    
    // 카카오 
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                return AuthController.handleOpenUrl(url: url)
            }

            return false
        }
    
}


// 키보드 내리기
extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
