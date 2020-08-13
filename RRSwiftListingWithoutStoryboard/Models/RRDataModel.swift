//
//  RRDataModel.swift
//  RRSwiftListingWithoutStoryboard
//
//  Created by Rahul Mayani on 11/08/20.
//  Copyright © 2020 RR. All rights reserved.
//

import Foundation
import RealmSwift

class RRDataModel: Object {

    @objc dynamic var data: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var type: String = ""
}

extension RRDataModel {
    // save data into local DB
    class func create(from jsonResponse: [[String: Any]]) throws {
        do {
            // Delete all objects from the realm
            try appDelegate.realm.write {
                appDelegate.realm.deleteAll()
            }
            
            // Add new objects list in the realm
            appDelegate.realm.beginWrite()
            for json in jsonResponse {
                appDelegate.realm.create(RRDataModel.self, value: json, update: .error)
            }
            try appDelegate.realm.commitWrite()
           
        } catch { throw error }
    }
    
    // sorting by data type (text, image & other)
    class func sortBy(_ sort: RRSortEnum) -> Results<RRDataModel>? {
        var data: Results<RRDataModel>? = nil
        // MARK: data sorting handling
        switch sort {
        case .all:
            data = appDelegate.realm.objects(RRDataModel.self)
        case .text:
            data = appDelegate.realm.objects(RRDataModel.self).filter("type contains 'text'")
        case .image:
            data = appDelegate.realm.objects(RRDataModel.self).filter("type contains 'image'")
        case .other:
            data = appDelegate.realm.objects(RRDataModel.self).filter("type contains 'other'")
        }
        return data
    }
}
