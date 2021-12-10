//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Patrick lee on 12/8/21.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var imageURLStrings = ["a","b","c","d","e"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.reloadData()
        
        tableViewSetup()
        searchBarSetup()
    }

    

    func tableViewSetup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = self.view.frame.size.height/4
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
        return imageURLStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell", for: indexPath)
        
        cell.textLabel?.text = imageURLStrings[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(" you tapped tableView cell at indexPath:\(indexPath)")
    }
    
}

extension ViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search button clicked to search :\(searchBar.searchTextField.text)")
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
