//
//  ListingVC.swift
//  RRSwiftListingWithoutStoryboard
//
//  Created by Rahul Mayani on 11/08/20.
//  Copyright © 2020 RR. All rights reserved.
//

import UIKit
import SnapKit

class ListingVC: BaseVC {
        
    // MARK: - Variable -
    private let dataTableView = UITableView()
    
    // interaction between view and model by listing view model
    private let listingVM = ListingVM()
         
    // MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
                
        title = RRViewController.Name.listingVC
        
        view.accessibilityIdentifier = RRViewController.Name.listingVC
        
        addTableView()
        bindTableViewData()
        selectTableViewData()
        
        // Get data from local DB or Server
        listingVM.getDataFromLocalDBOrServer(true)
        
        // add sort button in nav bar
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: Selector(("sortButtonTapped")))
        navigationItem.rightBarButtonItem  = sortButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Sort Button -
    @objc func sortButtonTapped() {
        listingVM.sorting()
    }
}

// MARK: - TableView -
extension ListingVC {
    
    // add / set tableview constraints and register cell
    private func addTableView() {
        view.addSubview(dataTableView)
        dataTableView.translatesAutoresizingMaskIntoConstraints = false
        dataTableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.bottom.equalTo(view)
            make.right.equalTo(view)
        }
        dataTableView.register(ListingCell.self, forCellReuseIdentifier: reuseIdentifierOfListingCell)
    }
    
    // tableview cell for row method performing by rxswift
    private func bindTableViewData() {
        listingVM.dataArray.bind(to: dataTableView.rx.items(cellIdentifier: reuseIdentifierOfListingCell, cellType: ListingCell.self))
        {  (row, data, cell) in
            cell.data = data
        }.disposed(by: rxbag)
    }
    
    // tableview cell row selection performing by rxswift
    private func selectTableViewData() {
        dataTableView.rx.modelSelected(RRDataModel.self)
            .subscribe(onNext: {  [weak self] (data) in
                guard let self = self else { return }
                // MARK: navigate to detail view controller
                let detailVC = DetailsVC()
                detailVC.data = data
                detailVC.title = data.id
                self.navigationController?.pushViewController(detailVC, animated: true)
        }).disposed(by: rxbag)
    }
}