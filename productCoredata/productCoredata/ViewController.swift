//
//  ViewController.swift
//  productCoredata
//
//  Created by Najla Talal on 11/24/21.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    
    var arrayproduct = [Product1]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        loadData()
    }
  
}
extension ViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayproduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MyCell")as! UITableViewCell
        cell.textLabel?.text = arrayproduct[indexPath.row].name
       
        cell.textLabel?.textColor = UIColor.brown
       
        return cell
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(arrayproduct[indexPath.row])
            arrayproduct.remove(at: indexPath.row)
            tableView.reloadData()
            self.saveData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Ubdate product", message: "Add a new product", preferredStyle: .alert)
        alert.addTextField{alertTextField in
            alertTextField.placeholder = "add a new product"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Ubdate", style: .default){ action in
            self.arrayproduct[indexPath.row].setValue(textField.text, forKey: "name")
            self.saveData()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
        
    }
    func saveData() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    func loadData() {
        let request: NSFetchRequest<Product1> = Product1.fetchRequest()
        do {
            arrayproduct = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    //IBActions
    @IBAction func addProduct(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Alert", message: "Add new Product", preferredStyle: .alert)
        alert.addTextField { alertTextField in alertTextField.placeholder = "add new product"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "ok", style: .default){ action in
            let newProduct = Product1(context: self.context)
            newProduct.name = textField.text
            self.arrayproduct .append(newProduct)
            self.saveData()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


extension ViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            let alert = UIAlertController(title: "Empty", message: "Please enter product name", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        }else{
            
            let request = Product1.fetchRequest()
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
            
            do {
                arrayproduct = try context.fetch(request)
            } catch {
                print(error)
            }
            tableView.reloadData()
        }
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
 
            loadData()
    }

    }

