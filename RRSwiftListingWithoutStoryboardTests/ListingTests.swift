//
//  ListingTests.swift
//  RRSwiftListingWithoutStoryboardTests
//
//  Created by Rahul Mayani on 13/08/20.
//  Copyright © 2020 RR. All rights reserved.
//

import RxSwift
import RxCocoa

import XCTest
@testable import RRSwiftListingWithoutStoryboard


class ListingTests: XCTestCase {
    
    // MARK: - Variable -
    private let rxbag = DisposeBag()
    private let listingVM = ListingVM()
    
    // MARK: - Testing Cycle -
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test Case -
    func testDataFechingFromServerOrLocalDB() {
        
        // get data from server or local db
        listingVM.getDataFromLocalDBOrServer(true)
        
        // data response handling by rxswift
        listingVM.dataArray.subscribe(onNext: { (data) in
            XCTAssertTrue(!data.isEmpty)
        }).disposed(by: rxbag)
    }
    
    // sorting test case
    func testSorting() {
        let data = RRDataModel.sortBy(RRSortEnum.other)
        XCTAssertTrue(!(data?.isEmpty ?? false))
        XCTAssert((data?.count ?? 0) == 1)
    }
}
