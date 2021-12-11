//
//  PhotoViewController.swift
//  FlickrSearch
//
//  Created by Patrick lee on 12/8/21.
//

/*
 
 PhotoViewController : a TableView controller
 SearchBar:
    - Take user's input
    - Trigger actions to build requestURL and download photo urls to TableView's Data Source: imageURLs
 TableView:
    - pass url to TableView Cell : PhotoTableViewCell
    - TableView Cell is the one doing the hardwork ( request and display Flicr image when download is completed )
    - Tap a row will transit to DetailViewController to display and scroll that image in full size.
    - TableView only transit to DetailViewController when image exist in imageCache. This is to insure users can only open a image after image is downloaded.
 
 
 */
import UIKit

class PhotoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        searchBarSetup()
    }

    

    func tableViewSetup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = self.view.frame.size.height/3
        tableView.keyboardDismissMode = .onDrag
    }
    
    func searchBarSetup() {
        
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        
    }
    
    //MARK: tableView DataSource and Delegae methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoTableViewCell
        
        cell.url = imageURLs[indexPath.row]
        title = cell.url?.absoluteString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(" you tapped tableView cell at indexPath:\(indexPath)")
        
        let url = imageURLs[indexPath.row]
        guard let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage else {return}
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        nextVC.url = url
        nextVC.image = cachedImage
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension PhotoViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search button clicked to search :\(String(describing: searchBar.searchTextField.text))")
        
        guard let searchText = searchBar.text else {return}
        
        if searchText == "" {
            
        } else {
            let requestURL = FlickrAPI.buildRequestURL(text: searchText)
            FlickrAPI.downloadData(with: requestURL) { data, error in
                guard let data = data, let json = try? JSON(data:data) else {
                    print("failed to download data from Flickr, error:\(String(describing: error?.localizedDescription))")
                    return
                }
                
                let urls = FlickrAPI.parseJSON_Search(with: searchText, json: json)
                imageURLs = urls
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
//                print(" ===> imageURLs:\(imageURLs)")
            }

        }
        
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
