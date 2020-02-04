//
//  ViewController.swift
//  API calling
//  
//  Created by Riley Bowling on 1/31/20.
//  Copyright © 2020 Riley Bowling. All rights reserved.
//

import UIKit

class BrandViewController: UITableViewController {
    
    var brands = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "brands"
        let query = "http://makeup-api.herokuapp.com/api/v1/products.json?product_type=blush"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                if json["status"] == "ok" {
                    parse(json: json)
                    return
                }
            }
        }
        loadError()
    }
    
    func parse(json: JSON) {
        for result in json["brands"].arrayValue {
            let name = result["brand"].stringValue
            let brand = ["name": name]
            brands.append(brand)
        }
        tableView.reloadData()
    }
    
    func loadError() {
        let alert = UIAlertController(title: "Loading Error",
                                      message: "There was a problem loading the news feed",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil) }
}

