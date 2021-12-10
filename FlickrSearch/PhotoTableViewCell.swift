//
//  PhotoTableViewCell.swift
//  FlickrSearch
//
//  Created by peicheng lee on 12/9/21.
//

import UIKit

class PhotoTableViewCell : UITableViewCell {
    
    @IBOutlet weak var aImageView: UIImageView!
    @IBOutlet weak var aSpinner: UIActivityIndicatorView!
    
    var urlString = String() {
        
        didSet {
            
            setupUI()
        }
        
    }
    
    var url = URL(string: "") {
        
        didSet {
            
            setupUI()
        }
        
    }

    
    func setupUI() {
        aImageView.contentMode = .scaleAspectFill
        guard let url = url else {return}
        
        aSpinner.style = .whiteLarge
        aSpinner.hidesWhenStopped = true
        aSpinner.startAnimating()
        
        
        print("PhotoCell received URL from tableView :\(urlString)")
        
        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            aImageView.image = cachedImage
            aSpinner.stopAnimating()
            print(" ==> found image in imageCache")
        } else  {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let validData = data , error == nil else {
                    print(" fail to download image at url:\(url)")
                    return
                }
                
                DispatchQueue.main.async {
                    let downloadedImage = UIImage(data: data!)
                    self.aImageView.image = downloadedImage
                    self.aSpinner.stopAnimating()
                    imageCache.setObject(downloadedImage!, forKey: url as AnyObject)
                }
                
            }.resume()
            
        }
        
    }
}
