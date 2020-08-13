//
//  RRStructs.swift
//  RRSwiftListingWithoutStoryboard
//
//  Created by Rahul Mayani on 11/08/20.
//  Copyright © 2020 RR. All rights reserved.
//

import Foundation
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

public struct RRAPIEndPoint {
    
    static let endPointURL = Environment.production.rawValue
    
    private enum Environment:String {
        case develop = "local host"
        case staging = "stage"
        case production = "https://raw.githubusercontent.com/"
    }
    
    struct Name {
        static let axxessTech = endPointURL + "AxxessTech/Mobile-Projects/master/challenge.json"
    }
}

public struct RRViewController {
    
    struct Name {
        static let listingVC = "Data Listing"
        static let detailsVC = "Details"
    }
}
