//
//  HomeViewController.swift
//  Project 4
//
//  Created by Avinash Muralidharan on 31/08/23.
//

import UIKit

class HomeViewController: UITableViewController{
    
    @IBOutlet var heading: UILabel!
    var bookmarks = ["apple.com","hackingwithswift.com","google.com","wikipedia.org"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        heading.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        heading.font = UIFont.systemFont(ofSize: 50)
      
        heading.textAlignment = .center
        heading.text = "Welcome"
    
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "site", for: indexPath)
        cell.textLabel?.text = bookmarks[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "webView") as? ViewController{
            vc.bookmarks = bookmarks
            vc.initialSite = bookmarks[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


