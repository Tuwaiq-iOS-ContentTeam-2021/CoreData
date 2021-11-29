//
//  ViewController.swift
//  coreDatePractice
//
//  Created by Ghada Fahad on 19/04/1443 AH.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
   
    
    
    
    

    
    var arrProduct = [Product]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        loadData()
    }
    func saveData() {
        do{
          try  context.save()

        }
        catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadData() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            arrProduct = try context.fetch(request)

        } catch {
            print(error)
        }
    }

    @IBAction func addProduct(_ sender: Any) {
        var textField = UITextField()
        var alert = UIAlertController(title: "Alert", message: "please add new product", preferredStyle: .alert)
        alert.addTextField{alertTextField in alertTextField.placeholder = "add New product"
            textField = alertTextField
           
        }
        let action = UIAlertAction(title: "ok", style: .default) {action in var newProduct = Product(context: self.context)
            newProduct.name = textField.text
            self.arrProduct.append(newProduct)
            self.saveData()
        
        
//        var action = UIAlertAction(title: "ok", style: .default, handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
        
    }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        self.saveData()
        present(alert, animated: true, completion: nil)
}

}

extension ViewController :  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! UITableViewCell
        cell.textLabel?.text =  arrProduct[indexPath.row].name
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(arrProduct[indexPath.row])
            arrProduct.remove(at: indexPath.row)
            self.saveData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textField = UITextField()
        let alert = UIAlertController(title: "update product", message: "add new product", preferredStyle: .alert)
        alert.addTextField { alertTextField in alertTextField.placeholder = "add new product"
            textField = alertTextField
        }
}
}

    extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            let alert = UIAlertController(title: "Empty", message: "please enter something", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
//            let request : NSFetchRequest<Product> = Product.fetchRequest() ممكن اختصرها
            let request  = Product.fetchRequest()
            request.predicate = NSPredicate(format: "name CONTAINS[cd]%@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            do {
             arrProduct  = try context.fetch(request)
            } catch {
                print(error)
            }
            tableView.reloadData()

        }
//        print(searchBar.text!)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
        }
    }
    
}
    
