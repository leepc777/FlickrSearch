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
    
    var ulrString = String() {
        
        didSet {
            
            setupUI()
        }
        
    }
    
    
    func setupUI() {
        
        aSpinner.startAnimating()
        
        print("PhotoCell received URL from tableView")
        
    }
}
