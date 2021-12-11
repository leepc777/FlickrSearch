//
//  FlickrSearchViewControllerTests.swift
//  FlickrSearchTests
//
//  Created by peicheng lee on 12/10/21.
//

import XCTest
@testable import FlickrSearch

class FlickrSearchViewControllerTests: XCTestCase {

    var sut : PhotoViewController!
    override func setUp() {
        super.setUp()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyBoard.instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        print(" ===> tear down is called")
        super.tearDown()
    }
    
    func testSearchBar() {
        sut.searchBar.setValue("cat", forKey: "text")
        let searchText = sut.searchBar.text
        XCTAssertEqual(searchText, "cat")
    }

}
