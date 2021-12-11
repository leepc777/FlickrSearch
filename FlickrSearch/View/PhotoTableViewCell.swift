//
//  PhotoTableViewCell.swift
//  FlickrSearch
//
//  Created by peicheng lee on 12/9/21.
//

/*
 
 PhotoTableViewCell : a TableView Cell
  - not only a simple view, it is responsible to download image after receiving url from tableView controller.
 
  - NSCache
    * Cache write: store key(url) - value(imageData) for every downloaed Flicr image.
    * Cache read : Check if cache contains the image that tableView controller request, before submit the requestURL to Flickr.
 
 
 */

import UIKit

class PhotoTableViewCell : UITableViewCell {
    
    @IBOutlet weak var aImageView: UIImageView!
    @IBOutlet weak var aSpinner: UIActivityIndicatorView!
    
    var url = URL(string: "") {
        
        didSet {
            
            setupUI()
        }
        
    }
    
    
    func setupUI() {
        aImageView.contentMode = .scaleAspectFill
        guard let url = url else {return}
        
        aSpinner.style = .large
        aSpinner.hidesWhenStopped = true
        aSpinner.startAnimating()
        
        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            aImageView.image = cachedImage
            aSpinner.stopAnimating()
            print(" ==> found image in imageCache")
        } else  {
            
            FlickrAPI.downloadData(with: url) { data, error in
                
                guard let validData = data , error == nil else {
                    print(" fail to download image at url:\(url)")
                    return
                }
                
                DispatchQueue.main.async {
                    let downloadedImage = UIImage(data: validData)
                    self.aImageView.image = downloadedImage
                    self.aSpinner.stopAnimating()
                    imageCache.setObject(downloadedImage!, forKey: url as AnyObject)
                }
            }
            
        }
        
    }
}
