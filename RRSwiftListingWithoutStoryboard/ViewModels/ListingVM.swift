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

protocol RemovedListingData: class {
    func getRemovedListingDataFromDetailsVC(_ data: RRDataModel)
}

// get delegate event while remove data from detailsVC
extension ListingVM: RemovedListingData {
    func getRemovedListingDataFromDetailsVC(_ data: RRDataModel) {
        self.removedDataFromDetailsVC(data)
    }
}

class ListingVM {
    
    // MARK: - Variable -
    // listing data array observe by rxswift
    public var dataArray : PublishSubject<Results<RRDataModel>> = PublishSubject()
    
    // get observe event while remove data from detailsVC
    public var dataRemoved : PublishSubject<RRDataModel> = PublishSubject()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Init -
    init() {
        // code here...
    }
    
    // MARK: - other -
    public func getDataFromLocalDBOrServer(_ isAPICall: Bool = false) {
        var isLoding = true
        let data = appDelegate.realm!.objects(RRDataModel.self)
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
    
    public func removedDataFromDetailsVC(_ data: RRDataModel) {
        UIAlertController.showAlert(title: "Removed: " + data.id, message: data.data)
        RRDataModel.removeDataObject(data)
        self.getDataFromLocalDBOrServer()
    }
}

// MARK: - Sorting -
extension ListingVM {
    public func sorting() {
        UIAlertController.showBottomSheet(title: "", message: "Sort By:") { [weak self] (sort) in
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
        RRAPIManager.shared.setURL(RRAPIEndPoint.Name.axxessTech)
        .showIndicator(isLoading)
        .setDeferredAsObservable()
        .subscribeConcurrentBackgroundToMainThreads()
        .subscribe(onNext: { [weak self] (response) in
            guard let self = self else { return }
            do {
                _ = try RRDataModel.create(from: response as! [[String : Any]])
                self.getDataFromLocalDBOrServer(false)
            } catch {
                UIAlertController.showAlert(title: nil, message: error.localizedDescription)
            }
        }, onError: { (error) in
            UIAlertController.showAlert(title: nil, message: error.localizedDescription)
        }) => disposeBag
    }
}
