//
//  ViewController.swift
//  API calling
//  
//  Created by Riley Bowling on 1/31/20.
//  Copyright © 2020 Riley Bowling. All rights reserved.
//

import UIKit

class BrandsViewController: UITableViewController {
    
    var brands = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "makeup brands"
        let query = "https://makeup-api.herokuapp.com/api/v1/products.json"
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
            let name = result["brand"].stringValue
            let brand = ["brand": name]
            if brands.contains(["brand" : name]) {
                continue
            } else {
                brands.append(brand)
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
        return brands.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let brand = brands[indexPath.row]
        cell.textLabel?.text = brand["brand"]
        return cell
    }
    
    @IBAction func onDoneButtonTapped(_ sender: Any) {
        exit(0)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! ProductsViewController
        let index = tableView.indexPathForSelectedRow?.row
        dvc.brand = brands[index!]
    }
}
