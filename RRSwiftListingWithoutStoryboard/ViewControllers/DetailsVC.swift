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
    
    public weak var delegate: RemovedListingData?
    
    // MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = RRViewController.Name.detailsVC
        setupUI()
        
        // add remove button in nav bar
        let removeButton = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(self.removeButtonTapped))
        navigationItem.rightBarButtonItem  = removeButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDataSource()
    }
    
    override func initialize() {
        super.initialize()
        enableBackButton = true
    }
    
    override func onBack() {
        if navigationController?.presentingViewController != nil {
            navigationService.pop(with: PopOptions(popType: .dismiss, animated: true))
        } else {
            super.onBack()
        }
    }
    
    // MARK: - Remove Button -
    @objc func removeButtonTapped() {
        self.navigationController?.popViewController(animated: true)
        delegate?.getRemovedListingDataFromDetailsVC(data!)
    }
}

// MARK: - UI -
extension DetailsVC {
    fileprivate func setupUI() {
        // MARK: Scrollview
        view.addSubview(dataScrollView)
        
        dataScrollView.autoPinEdgesToSuperviewMargins()
       
        // MARK: Main StackView
        dataScrollView.addSubview(mainStackView)
        
        stackViewDateType.addArrangedSubview(dateLabel)
        stackViewDateType.addArrangedSubview(typeLabel)
        
        mainStackView.addArrangedSubview(dataImage)
        mainStackView.addArrangedSubview(stackViewDateType)
        mainStackView.addArrangedSubview(dataLabel)
        
        // set imageview height
        dataImage.autoMatch(.height, to: .height, of: dataScrollView, withMultiplier: 0.35)
        
        // set type label size
        typeLabel.autoSetDimension(.height, toSize: 20)
             
        // set main StackView Constraints
        mainStackView.autoPinEdgesToSuperviewMargins()
        mainStackView.autoMatch(.width, to: .width, of: dataScrollView, withOffset: -20)
        
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
