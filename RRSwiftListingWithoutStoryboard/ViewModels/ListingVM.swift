//
//  ListingVM.swift
//  RRSwiftListingWithoutStoryboard
//
//  Created by Rahul Mayani on 13/08/20.
//  Copyright © 2020 RR. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class ListingVM {
    
    // MARK: - Variable -
    // listing data array observe by rxswift
    public var dataArray : PublishSubject<Results<RRDataModel>> = PublishSubject()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Init -
    init() {
        // do something
    }
    
    // MARK: - other -
    public func getDataFromLocalDBOrServer(_ isAPICall: Bool = false) {
        var isLoding = true
        let data = appDelegate.realm.objects(RRDataModel.self)
        if data.count > 0 {
            // refresh table view and bind data
            dataArray.onNext(data)
            isLoding = false
        }
        // Get data from server
        if isAPICall {
            getDataFromServer(isLoding)
        }
    }
}

// MARK: - Sorting -
extension ListingVM {
    public func sorting() {
        UIAlertController.showBottomSheet(title: "Sort By:", message: "") { [weak self] (sort) in
            guard let self = self else { return }
            // MARK: data sorting handling
            let data = RRDataModel.sortBy(sort)
            if (data?.count ?? 0) > 0 {
                self.dataArray.onNext(data!)
            }
        }
    }
}

// MARK: - API -
extension ListingVM {
    // get data from server by rxswift with alamofire
    fileprivate func getDataFromServer(_ isLoading: Bool = false) {
        RRAPIManager.rxCall(apiUrl: RRAPIEndPoint.Name.axxessTech, showingIndicator: isLoading)
        .subscribeConcurrentBackgroundToMainThreads()
        .subscribe(onNext: { [weak self] (response) in
            guard let self = self else { return }
            do {
                _ = try RRDataModel.create(from: response)
                self.getDataFromLocalDBOrServer(false)
            } catch {
                UIAlertController.showAlert(title: nil, message: error.localizedDescription)
            }
        }, onError: { (error) in
            UIAlertController.showAlert(title: nil, message: error.localizedDescription)
        }).disposed(by: disposeBag)
    }
}
