
//
//  APICaller.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/15.
//

import Foundation

struct Constants {
        static let API_KEY = "" //서버에서 가져온 값 추가 []
        static let baseURL = "http://175.210.229.95:9721"
    
    
    enum APIError: Error {
        case failedToGetData
    }
    
    class APICaller {
        static let shared = APICaller()
        
        
    }
}
