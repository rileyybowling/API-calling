//
//  ViewController.swift
//  API calling
//
//  Created by Riley Bowling on 1/31/20.
//  Copyright © 2020 Riley Bowling. All rights reserved.
//

import UIKit

class ProductsViewController: UITableViewController {
    
    var products = [[String: String]]()
    var brand = [String: String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "brand products"
        let formattedBrand = (brand["brand"]!).replacingOccurrences(of: " ", with: "%20")
        let query = "https://makeup-api.herokuapp.com/api/v1/products.json?brand=\(formattedBrand)"
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
            let price = result["price"].stringValue
            let url = result["product_link"].stringValue
            let product = ["name": productName, "price": price, "product_link": url]
                products.append(product)
        }
        DispatchQueue.main.async {
            [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    func loadError() {
        DispatchQueue.main.async {
            [unowned self] in
            let alert = UIAlertController(title: "Loading Error", message: "There was a problem loading the makeup products", preferredStyle: .actionSheet)
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
        cell.textLabel?.text = product["name"]
        if product["price"] != "0.0" {
        cell.detailTextLabel?.text = "$ \(product["price"]!)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: products[indexPath.row]["product_link"]!)
        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
    }
}
