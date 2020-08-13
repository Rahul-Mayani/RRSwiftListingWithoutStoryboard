//
//  RRSortEnum.swift
//  RRSwiftListingWithoutStoryboard
//
//  Created by Rahul Mayani on 12/08/20.
//  Copyright © 2020 RR. All rights reserved.
//

import Foundation

enum RRSortEnum: Int {
    case all
    case text
    case image
    case other

    var title: String? {
        switch self {
        case .all:
            return "All"
        case .text:
            return "Text"
        case .image:
            return "Image"
        case .other:
            return "Other"
        }
    }
}
