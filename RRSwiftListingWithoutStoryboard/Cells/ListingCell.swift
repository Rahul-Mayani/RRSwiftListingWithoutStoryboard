//
//  ListingCell.swift
//  RRSwiftListingWithoutStoryboard
//
//  Created by Rahul Mayani on 11/08/20.
//  Copyright © 2020 RR. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

let reuseIdentifierOfListingCell = "ListingCell"

class ListingCell: UITableViewCell {

    // MARK: - Variable -
    let spacerView:UIView = {
        return RRCustomViews.getSpacerView()
    }()
    
    let dataImage:UIImageView = {
        return RRCustomViews.getImageView()
    }()
    
    let idLabel:UILabel = {
        let label = RRCustomViews.getLabel(font: UIFont.systemFont(ofSize: 16, weight: .semibold), textColor: UIColor.blackColor())
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let dataLabel:UILabel = {
        return RRCustomViews.getLabel(numberOfLines: 2, textColor: UIColor.darkBlackColor())
    }()
    
    let dateLabel:UILabel = {
        return RRCustomViews.getLabel(font: UIFont.systemFont(ofSize: 12, weight: .medium), textColor: UIColor.lightBlackColor(), textAlignment: .right)
    }()
    
    let typeLabel:UILabel = {
        return RRCustomViews.getLabel(font: UIFont.systemFont(ofSize: 15, weight: .semibold), textColor: UIColor.redColor(), textAlignment: .right)
    }()
    
    // merge id label and type label
    let stackViewIdType: UIStackView = {
        return RRCustomViews.getStackView()
    }()
    
    // merge stackViewIdType, data label and date label
    let stackViewTextData: UIStackView = {
        return RRCustomViews.getStackView(spacing: 5.0, axis: .vertical)
    }()
    
    // merge dataImage and spacer view
    let stackViewImageSpacer: UIStackView = {
        return RRCustomViews.getStackView(spacing: 0.0)
    }()
    
    // merge stackView of ImageSpacer and stackView of TextData
    let mainStackView: UIStackView = {
        return RRCustomViews.getStackView()
    }()
    
    private let rxbag = DisposeBag()
    
    public var data: RRDataModel? = nil {
        didSet {
            
            idLabel.text = data?.id ?? ""
            typeLabel.text = (data?.type ?? "").capitalized
            
            // image / text data type handling
            if data?.type == "image" {
                dataImage.setKingfisherImageView(image: data?.data ?? "", placeholder: "")
                stackViewImageSpacer.isHidden = false
            } else {
                dataLabel.isHidden = false
                dataLabel.text = data?.data ?? ""
            }
            
            // date handling
            if !(data?.date ?? "").isEmpty {
                dateLabel.text = data?.date ?? ""
                dateLabel.isHidden = false
            }
        }
    }
    
    // MARK: - Cell Life Cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(mainStackView)
        
        stackViewIdType.addArrangedSubview(idLabel)
        stackViewIdType.addArrangedSubview(typeLabel)
        
        stackViewTextData.addArrangedSubview(stackViewIdType)
        stackViewTextData.addArrangedSubview(dataLabel)
        stackViewTextData.addArrangedSubview(dateLabel)
        
        stackViewImageSpacer.addArrangedSubview(dataImage)
        stackViewImageSpacer.addArrangedSubview(spacerView)
        
        mainStackView.addArrangedSubview(stackViewImageSpacer)
        mainStackView.addArrangedSubview(stackViewTextData)
        
        dataImage.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(60)
            //make.height.equalTo(10)
        }
        
        idLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
        }
        
        typeLabel.snp.makeConstraints { (make) in
            make.width.equalTo(80)
        }
        
        dataLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for:.vertical)
        dateLabel.snp.makeConstraints { (make) in
            make.height.equalTo(15)
        }
        
        mainStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(10)
            make.trailing.equalTo(contentView).offset(-10)
            make.bottom.equalTo(contentView).offset(-10)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.isHidden = true
        stackViewImageSpacer.isHidden = true
        dataLabel.isHidden = true
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

