//
//  ToastService.swift
//  My Reform
//
//  Created by 박현준 on 2023/02/02.
//

import Foundation
import SnapKit
import UIKit

class ToastService {
    
    static let shared = ToastService()
    
    var toastViews = [UIView?]()
    
    func showToast(_ msg:String){
        let toastView = UIView()
        self.toastViews.append(toastView)
        if let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            toastView.alpha = 0.0
            toastView.backgroundColor = .black.withAlphaComponent(0.5)
            window.addSubview(toastView)
            window.bringSubviewToFront(toastView)
            toastView.layer.cornerRadius = 15
            toastView.snp.makeConstraints({
                $0.width.equalTo(140)
                $0.height.equalTo(40)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-60)
            })
            let lbMsg = UILabel()
            toastView.addSubview(lbMsg)
            lbMsg.text = msg
            lbMsg.textColor = .white
            lbMsg.font = .systemFont(ofSize: 14)
            lbMsg.snp.makeConstraints({
                $0.centerX.centerY.equalToSuperview()
            })
            UIView.animate(withDuration: 1.0, delay: 0.0,options:[.curveEaseOut], animations: {
                toastView.alpha = 1.0
            })
            UIView.animate(withDuration: 1.0, delay: 0.0,options:[.curveEaseIn], animations: {
                toastView.alpha = 0.0
            },completion: { _ in
                toastView.removeFromSuperview()
                self.toastViews.removeFirst()
            })
        }
    }
}
