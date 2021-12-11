//
//  FlickrSearchAPITests.swift
//  FlickrSearchTests
//
//  Created by peicheng lee on 12/10/21.
//

import XCTest
@testable import FlickrSearch
class FlickrSearchAPITests: XCTestCase {
    
    
    var sut : FlickrAPI!
    override func setUp() {
        super.setUp()
        sut = FlickrAPI()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // test if requestURL is correctly generated for searching "dog" related flickr photos
    func testBuildRequestURL() {
        let text = "dog"
        let requestURL = FlickrAPI.buildRequestURL(text: text)
        let requestURLString = requestURL.absoluteString
        let correctURLString = "https://api.flickr.com/services/rest?api_key=11ebab0e0173a322ca87cee9c81a349a&method=flickr.photos.search&format=json&text=dog&extras=url_l&nojsoncallback=1&page=1"
        XCTAssertEqual(requestURLString, correctURLString)
    }
    
    
    // a Asynchornous download test. to check if a "cat" related Flickr image can be downloaded
    // "cat" --> requestURL --> downloaded Image
    // test fail when image property is nil
    func testDownloadCatPhoto() {
        
        var image : UIImage?
        let requestURL = FlickrAPI.buildRequestURL(text: "cat")

        let flicrAnswerExpectation = expectation(description: "WaitForFlicrToResponse")

        FlickrAPI.downloadData(with: requestURL) { data, error in
            guard let data = data, let json = try? JSON(data:data) else {
                return
            }
            
            let urls = FlickrAPI.parseJSON_Search(with: "cat", json: json)
            imageURLs = urls
            let url = urls[0]
                FlickrAPI.downloadData(with: url) { data, error in
                    
                    guard let validData = data , error == nil else {
                        print(" fail to download image at url:\(url)")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let downloadedImage = UIImage(data: validData)
                        imageCache.setObject(downloadedImage!, forKey: url as AnyObject)
                        
                        // successfully download image to image
                        image = downloadedImage
                        flicrAnswerExpectation.fulfill()
                    }
                }
        }

        waitForExpectations(timeout: 4, handler:nil)
        XCTAssertNotNil(image)

    }
    
    // how long does it take to download all URLs related to "cat" ?
    // This is aynchronous operation, so it only measure times it took to submit aynchronous tasks.
    func testDownloadMatchingURLs_Performance() {
        
        measure {
            let requestURL = FlickrAPI.buildRequestURL(text: "cat")
            FlickrAPI.downloadData(with: requestURL) { data, error in
                guard let data = data, let json = try? JSON(data:data) else {
                    return
                }
                
                let urls = FlickrAPI.parseJSON_Search(with: "cat", json: json)
                imageURLs = urls
            }
            
        }
    }
    
    
    // how long does it take to download all photos related to "cat" ?
    // This is aynchronous operation, so it only measure times it took to submit aynchronous tasks.
    func testRequestMatchingPhotos_Performance() {
        
        measure {
            let requestURL = FlickrAPI.buildRequestURL(text: "cat")
            FlickrAPI.downloadData(with: requestURL) { data, error in
                guard let data = data, let json = try? JSON(data:data) else {
                    return
                }
                
                let urls = FlickrAPI.parseJSON_Search(with: "cat", json: json)
                imageURLs = urls
                
                for url in imageURLs {
                    
                    
                    FlickrAPI.downloadData(with: url) { data, error in
                        
                        guard let validData = data , error == nil else {
                            print(" fail to download image at url:\(url)")
                            return
                        }
                        
                        DispatchQueue.main.async {
                            let downloadedImage = UIImage(data: validData)
                            imageCache.setObject(downloadedImage!, forKey: url as AnyObject)
                        }
                    }
                    
                }
            }
            
        }
    }

    

}
