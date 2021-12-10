//
//  PhotoData.swift
//  FlickrSearch
//
//  Created by peicheng lee on 12/9/21.
//

import UIKit

//var imageURLStrings = ["a","b","c","d","e"]
var imageURLStrings = [String]()
var imageURLs = [URL]()
var imageCache: NSCache<AnyObject, AnyObject> = NSCache()


class FlickrAPI {
    
    
    //Generate request URL based on searchBar input text
    class func buildRequestURL(text:String) -> URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest"
        components.queryItems = [URLQueryItem]()
        
        let queryKey = URLQueryItem(name: "api_key", value: "11ebab0e0173a322ca87cee9c81a349a")
        let queryMethod = URLQueryItem(name: "method", value: "flickr.photos.search")
        let queryFormat = URLQueryItem(name: "format", value: "json")
        let queryText = URLQueryItem(name: "text", value: text)
        let queryExtra = URLQueryItem(name: "extras", value: "url_l")
        let queryNojsoncallback = URLQueryItem(name: "nojsoncallback", value: "1")
        let queryPage = URLQueryItem(name: "page", value: "1")
        
        components.queryItems!.append(queryKey)
        components.queryItems!.append(queryMethod)
        components.queryItems!.append(queryFormat)
        components.queryItems!.append(queryText)
        components.queryItems!.append(queryExtra)
        components.queryItems!.append(queryNojsoncallback)
        components.queryItems!.append(queryPage)
        
        
        return components.url!
    }
    
//    static func downloadData(with urlString:String,completion:@escaping (_ data:Data?,_ error:Error?)->Void) {
    static func downloadData(with url:URL,completion:@escaping (_ data:Data?,_ error:Error?)->Void) {

//        guard let url =  URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let validData = data, error == nil else {
                completion(nil,error!)
                return
            }
            
            completion(validData,nil)
        }
        
        task.resume()
        
    }
    
    
    //Use SwiftyJSON to parse response json :  photos.photo[0].url_l
    // Filter URLs, only return URLs that have matching title
    class func parseJSON_Search(with text:String, json:JSON) -> [URL] {
        
        var imageURLs = [URL]()
        let photoArray = json["photos"]["photo"].arrayValue
        
        for i in 0 ..< photoArray.count where imageURLs.count < 25 {
            
            let title = photoArray[i]["title"].stringValue
            let urlString = photoArray[i]["url_l"].stringValue
            
            if title.lowercased().contains(text.lowercased()) {
                if let url = URL(string: urlString) {
                    imageURLs.append(url)
                }
            }
            
        }
        
        return imageURLs
    }
    
    
}