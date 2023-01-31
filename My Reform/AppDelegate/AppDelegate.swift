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
        
        sleep(1)
        // Override point for customization after application launch.
        
        if (UserDefaults.standard.string(forKey: "refreshToken") != nil){
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
//            if UserDefaults.standard.bool(forKey: "appPasswordCheck") == true {
//                navigationController = UINavigationController(rootViewController: AppPasswordViewController())
//                self.window?.rootViewController = navigationController
//                self.window?.makeKeyAndVisible()
//            }else {
                moveHomeViewController()
//            }
            self.window?.backgroundColor = .white
        }else {
            moveLoginViewController()
//            moveSplashViewController()
            
//            sleep(3)
            
//            moveHomeViewController()
        }
        
        func moveSplashViewController() {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = SplashViewController()
            self.window?.makeKeyAndVisible()
            self.window?.backgroundColor = .white
        }
        
        func moveHomeViewController(){
            self.window = UIWindow(frame: UIScreen.main.bounds)
            // MainTabBarViewController 자체가 Navigation Controller로 되어있음
            self.window?.rootViewController = MainTabBarViewController()
            self.window?.makeKeyAndVisible()
            self.window?.backgroundColor = .white
        }
        
        func moveLoginViewController(){
            self.window = UIWindow(frame: UIScreen.main.bounds)
            navigationController = UINavigationController(rootViewController: LoginViewController())
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
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

