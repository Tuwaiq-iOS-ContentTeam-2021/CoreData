//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Sahab Alharbi on 19/04/1443 AH.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var productArr = [Product]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.textLabel?.text = productArr[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            content.delete(productArr[indexPath.row])
            productArr.remove(at: indexPath.row)
            
            self.saveData()
        }
    }
    func saveData() {
        
        do {
            try content.save()
        }catch {
            print(error)
        }
        tableView.reloadData()
    }
    func loadData(){
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
        productArr = try content.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.dataSource = self
        loadData()
        //تنبيه اشعار يظهر بالشاشة
//        var alert = UIAlertController(title: "Alert", message: "Please add new product ", preferredStyle: .alert)
//        var action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }

    @IBAction func addProduct(_ sender: Any) {
        var textField = UITextField()
        var alert = UIAlertController(title: "Alert", message: "Please add new product ", preferredStyle: .alert)
//
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add new product"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "OK", style: .default) { action in
            var newProduct = Product(context: self.content)
            newProduct.name = textField.text
            self.productArr.append(newProduct)
            self.saveData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

