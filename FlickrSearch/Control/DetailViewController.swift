//
//  DetailViewController.swift
//  FlickrSearch
//
//  Created by Patrick Lee on 12/9/21.
//

/*
 
 DetailViewController : a viewController with Scroll View
    - Triggered and recieve the image sent by TableView controller
    
 
 
 */
import UIKit

class DetailViewController: UIViewController {

    var scrollView=UIScrollView()
    var imageView=UIImageView()
    var url : URL! {
        didSet {
            title = url.absoluteString
        }
    }
    var image = UIImage() {
        didSet {
            print("===== received downloaded image from tableViewVC ",image)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollViewSetup()

    }
    
    func scrollViewSetup() {
        
        imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        imageView.backgroundColor = .white
        
        scrollView = UIScrollView(frame: self.view.frame)
        scrollView.contentSize = imageView.bounds.size
//        scrollView.contentMode = .center
        scrollView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 4
        
    }
    
}

extension DetailViewController : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    //scale image to fit scrollView
    func setZoomScale() {
        
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size

        //get the ratio between image and scroll view, this determind how small you want to scale the scrollview's content
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height

        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
         
        
        imageView.center = scrollView.center
         

    }
    
    // MARK: layout ScrollView
    override func viewWillLayoutSubviews() {
        setZoomScale()
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        imageView.center = scrollView.center
    }
}
