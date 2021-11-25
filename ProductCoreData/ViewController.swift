//
//  ViewController.swift
//  ProductCoreData
//
//  Created by Lola M on 11/24/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var arrOfProducts = [Product]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchTextField.textColor = UIColor.systemPink
        navigationItem.title = "List of Products"
        loadData()
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        myTableView.reloadData()
    }
    
    func loadData() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            arrOfProducts = try context.fetch(request)
        } catch {
            print(error)
        }
        myTableView.reloadData()
    }
    
    
    @IBAction func addProductBtn(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New", message: "Enter Product Name", preferredStyle: .alert)
        alert.addTextField { alertTextFiled in
            alertTextFiled.placeholder = "New Product"
            textField = alertTextFiled
        }
        let action = UIAlertAction(title: "Ok", style: .default) { action in
            let newProduct = Product(context: self.context)
            newProduct.name = textField.text
            let actionCanel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            self.arrOfProducts.append(newProduct)
            self.saveData()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


//SearchBar Extension
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "Search bar should'nt be empty!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            let request = Product.fetchRequest()
            request.predicate = NSPredicate(format: "name contains[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            do {
                arrOfProducts = try context.fetch(request)
            } catch {
                print(error)
            }
            myTableView.reloadData()
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
        }
    }
}



//TableView Extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrOfProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = arrOfProducts[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(arrOfProducts[indexPath.row])
            arrOfProducts.remove(at: indexPath.row)
            self.saveData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textFiled = UITextField()
        let alert = UIAlertController(title: "Update", message: "Edit Product Name", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Product Name"
            textFiled = alertTextField
        }
        let action = UIAlertAction(title: "Update", style: .default) { action in
            self.arrOfProducts[indexPath.row].setValue(textFiled.text, forKey: "name")
            self.saveData()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
