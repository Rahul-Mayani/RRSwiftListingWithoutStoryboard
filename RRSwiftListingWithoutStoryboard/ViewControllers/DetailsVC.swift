//
//  DetailsVC.swift
//  RRSwiftListingWithoutStoryboard
//
//  Created by Rahul Mayani on 11/08/20.
//  Copyright © 2020 RR. All rights reserved.
//

import UIKit

class DetailsVC: BaseVC {
        
    // MARK: - Variable -
    let dataImage:UIImageView = {
        return RRCustomViews.getImageView()
    }()
        
    let dataLabel:UILabel = {
        return RRCustomViews.getLabel(font: UIFont.systemFont(ofSize: 16, weight: .regular), numberOfLines: 0, textColor: UIColor.darkBlackColor())
    }()
    
    let dateLabel:UILabel = {
        return RRCustomViews.getLabel(font: UIFont.systemFont(ofSize: 15, weight: .medium), textColor: UIColor.lightBlackColor())
    }()
    
    let typeLabel:UILabel = {
        return RRCustomViews.getLabel(font: UIFont.systemFont(ofSize: 15, weight: .semibold), textColor: UIColor.redColor(), textAlignment: .right)
    }()
    
    // merge date label and type label
    let stackViewDateType: UIStackView = {
        return RRCustomViews.getStackView()
    }()
    
    // merge data imageview, stackView of DateType and data label
    let mainStackView: UIStackView = {
        return RRCustomViews.getStackView(spacing: 15.0, axis: .vertical)
    }()
    
    // all views add into scroll view
    let dataScrollView: UIScrollView = {
        return RRCustomViews.getScrollView()
    }()
    
    // get selected data from listing view
    public var data: RRDataModel?
    
    // MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = RRViewController.Name.detailsVC
        setupUI()
        
        // add remove button in nav bar
        let removeButton = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: Selector(("removeButtonTapped")))
        navigationItem.rightBarButtonItem  = removeButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDataSource()
    }
    
    // MARK: - Remove Button -
    @objc func removeButtonTapped() {
        // get listing VC from all navigation VC hierarchy
        guard let listingVC = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count ?? 2) - 2] as? ListingVC else { return }
        self.navigationController?.popViewController(animated: true)
        listingVC.listingVM.dataRemoved.onNext(data!)
    }
}

// MARK: - UI -
extension DetailsVC {
    fileprivate func setupUI() {
        // MARK: Scrollview
        view.addSubview(dataScrollView)
        
        dataScrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(20)
            make.left.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-20)
        }
        
        // MARK: Main StackView
        dataScrollView.addSubview(mainStackView)
        
        stackViewDateType.addArrangedSubview(dateLabel)
        stackViewDateType.addArrangedSubview(typeLabel)
        
        mainStackView.addArrangedSubview(dataImage)
        mainStackView.addArrangedSubview(stackViewDateType)
        mainStackView.addArrangedSubview(dataLabel)
        
        // set imageview height
        dataImage.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(200)
        }
        
        // set type label size
        typeLabel.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
             
        // set main StackView Constraints
        mainStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dataScrollView).offset(20)
            make.leading.equalTo(dataScrollView)
            make.trailing.equalTo(dataScrollView)
            make.bottom.equalTo(dataScrollView).offset(-20)
            make.width.equalTo(dataScrollView.snp.width)
        }
        
        // MARK: UI hiding
        dateLabel.isHidden = true
        dataImage.isHidden = true
        dataLabel.isHidden = true
        
        view.layoutIfNeeded()
    }
}

// MARK: - DataSource -
extension DetailsVC {
    // MARK: bind data source into all views
    fileprivate func setupDataSource() {
        typeLabel.text = (data?.type ?? "").capitalized
        
        // image / text data type handling
        if data?.type == "image" {
            dataImage.setKingfisherImageView(image: data?.data ?? "", placeholder: "")
            //dataImage.setZoomInZoomOut(disposeBag: rxbag)
            dataImage.isHidden = false
        } else {
            dataLabel.isHidden = false
            dataLabel.text = data?.data ?? ""
        }
        
        // date handling
        if !(data?.date ?? "").isEmpty {
            dateLabel.text = data?.date ?? ""
            dateLabel.isHidden = false
        }
        
        view.layoutIfNeeded()
    }
}
