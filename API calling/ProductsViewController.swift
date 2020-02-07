//
//  ViewController.swift
//  API calling
//
//  Created by Riley Bowling on 1/31/20.
//  Copyright © 2020 Riley Bowling. All rights reserved.
//

import UIKit

class ProductsViewController: UITableViewController {
    
    var brand = [String: String]()
    var products = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "brand products"
        let query = "https://http://makeup-api.herokuapp.com/api/v1/products.json?brand=\(brand)"
        DispatchQueue.global(qos: .userInitiated).async {
            [unowned self] in
            if let url = URL(string: query) {
                if let data = try? Data(contentsOf: url) {
                    let json = try! JSON(data: data)
                    self.parse(json: json)
                    return
                }
            }
            self.loadError()
        }
    }
    
    func parse(json: JSON) {
        for result in json.arrayValue {
            let productName = result["name"].stringValue
            let productType = result["product_type"].stringValue
            let price = result["price"].stringValue
            let product = ["name": productName, "product_type": productType, "price": price]
            if products.contains(["name": productName, "product_type": productType, "price": price]) {
                continue
            } else {
                products.append(product)
            }
        }
        DispatchQueue.main.async {
            [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    func loadError() {
        DispatchQueue.main.async {
            [unowned self] in
            let alert = UIAlertController(title: "Loading Error", message: "There was a problem loading the makeup brands", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let product = products[indexPath.row]
        cell.textLabel?.text = product["product"]
        return cell
    }
}
