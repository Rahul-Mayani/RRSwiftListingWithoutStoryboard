//
//  RRAPIManager.swift
//  RRSwiftListingWithoutStoryboard
//
//  Created by Rahul Mayani on 11/08/20.
//  Copyright © 2020 RR. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Alamofire

public struct RRAPIManager: ObservableType {
    
    public typealias Element = [[String: Any]]    // The response of data type.
    
    var apiUrl: String                      // The URL.
    var httpMethod: HTTPMethod              // The HTTP method.
    var param: [String:Any]?                // The parameters.
    var showingIndicator: Bool = false      // The custom indicator.
    
    // Responsible for creating and managing `Request` objects, as well as their underlying `NSURLSession`.
    static var manager : Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 1200.0
        return Alamofire.Session(configuration: configuration)
    }()
    
    // The HTTP headers. `nil` by default.
    static private func header(url: String = "") -> HTTPHeaders {
        var header = HTTPHeaders()
        header["Content-Type"] = "application/json"
        /*
        // API
        if let token = Preference.fetch(.accessToken) as? String{
            header["Authorization"] = "Bearer" + " " + token
        }*/
        return header
    }
    
    // The parameter encoding. `URLEncoding.default` by default.
    static private func encoding(_ httpMethod: HTTPMethod) -> ParameterEncoding {
        var encoding : ParameterEncoding = JSONEncoding.default
        if httpMethod == .get{
            encoding = URLEncoding.default
        }
        return encoding
    }
    
    public func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, RRAPIManager.Element == Observer.Element {
        
        if showingIndicator {
            RRLoader.startLoaderToAnimating()
        }
        
        let url = apiUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let task = RRAPIManager.manager.request(url,
                                            method: httpMethod,
                                            parameters: param,
                                            encoding: RRAPIManager.encoding(httpMethod),
                                            headers: RRAPIManager.header(url: url))
            .responseJSON { (response) in
            
            if self.showingIndicator {
                RRLoader.stopLoaderToAnimating()
            }
                
            if response.response?.statusCode == RRHTTPStatusCode.unauthorized.rawValue {
                //RRLogout.logout()
                observer.onError(RRError.unauthorized)
                //observer.onCompleted()
                return
            }
                
            switch response.result {
            case .success :
                observer.onNext(response.value as! RRAPIManager.Element)
                observer.onCompleted()
                break
            case .failure(let error):
                if error.isSessionTaskError {
                    observer.onError(RRError.noInternetConnection)
                } else {
                    observer.onError(error)
                }
                break
            }
        }
        
        task.resume()
        
        // cURL Request Output
        debugPrint(" cURL Request ")
        debugPrint(task)
        debugPrint("")
        
        return Disposables.create { task.cancel() }
    }
}

extension RRAPIManager {
    
    public static func rxCall(apiUrl: String, httpMethod: HTTPMethod = .get, param: [String:Any]? = nil, showingIndicator: Bool = false) -> Observable<Element> {
        return Observable.deferred {
            return RRAPIManager(apiUrl: apiUrl,
                             httpMethod: httpMethod,
                             param: param,
                             showingIndicator: showingIndicator)
                  .asObservable()
        }
    }
}
