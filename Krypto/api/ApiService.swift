//
//  ApiService.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/5/30.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import Alamofire
import RxSwift

class ApiService {
    
    static func getCurrentRate(base: Currency, quote: Currency) -> Observable<Rate> {
        let url = "https://rest.coinapi.io/v1/exchangerate/\(base.rawValue)/\(quote.rawValue)"
        return request(url)
    }
    
    private static func request<T: Codable>(_ urlConvertible: String) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = AF.request(urlConvertible).responseDecodable { (response: AFDataResponse<T>) in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case.failure(let error):
                    observer.onError(error)
                }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
