//
//  ViewController.swift
//  CoreDataPractice
//
//  Created by Ahmad MacBook on 24/11/2021.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonOutlet: UIButton!
    
    @IBOutlet weak var searchOutlet: UISearchBar!
    
    
    
    
    var arrayProduct = [Product]()
    
    // this is a way to get data from core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchOutlet.delegate = self
        
        loadData()
        buttonOutlet.layer.cornerRadius = buttonOutlet.frame.width / 2
        buttonOutlet.layer.masksToBounds = true
    }
    
    //Save Data
    func saveData(){
        do {
            try context.save()
            
        } catch  {
            print("Error in Save Data")
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    //Reload Data
    func loadData(){
        let request : NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            arrayProduct = try context.fetch(request)
            
        } catch  {
            print("Error in load Data")
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    
    
    @IBAction func addButton(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "To Do", message: "Do you want to do something?", preferredStyle: .alert)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "To do name"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            
            let newProduct = Product(context: self.context)
            newProduct.nameOfProduct = textField.text
            self.arrayProduct.append(newProduct)
            self.saveData()
        }
        let dissmiss = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(dissmiss)
        present(alert, animated: true, completion: nil)
        
    }
}


extension ViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayProduct.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = arrayProduct[indexPath.row].nameOfProduct
        
        return cell
    }
    
    
    // Delete item
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            context.delete(arrayProduct[indexPath.row])
            arrayProduct.remove(at: indexPath.row)
            self.saveData()
            
        }
    }
    
    
    //Update
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Update To Do", message: "Change the name", preferredStyle: .alert)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Change Name"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Update", style: .default) { action in
            self.arrayProduct[indexPath.row].setValue(textField.text!, forKey: "nameOfProduct" )
            self.saveData()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
}

extension ViewController : UISearchBarDelegate {
    
    //search Automatic
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadData()
            
        } else {
            
            let request : NSFetchRequest<Product> = Product.fetchRequest()
            request.predicate = NSPredicate(format: "nameOfProduct CONTAINS [cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "nameOfProduct", ascending: true)]
            
            do {
                
                arrayProduct = try context.fetch(request)
                
            } catch  {
                
                print("Error with SearcBar")
                print(error.localizedDescription)
                
            }
            
            tableView.reloadData()
            
        }
    }
    /// this func we need to click on search to search : |
    
    
    //    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //        print(searchBar.text!)
    //        let request : NSFetchRequest<Product> = Product.fetchRequest()
    //        request.predicate = NSPredicate(format: "nameOfProduct CONTAINS [cd] %@", searchBar.text!)
    //        request.sortDescriptors = [NSSortDescriptor(key: "nameOfProduct", ascending: true)]
    //
    //        do {
    //
    //            arrayProduct = try context.fetch(request)
    //
    //        } catch  {
    //            print("Error with SearcBar")
    //            print(error.localizedDescription)
    //        }
    //
    //        tableView.reloadData()
    //    }
    
}
