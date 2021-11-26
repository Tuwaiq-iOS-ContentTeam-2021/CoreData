//
//  ViewController.swift
//  CoreDeta
//
//  Created by Wejdan Alkhaldi on 19/04/1443 AH.
//

import UIKit
import CoreData
class ViewController: UIViewController{
    var arrProduct = [Product]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //يحفظ البيانات ويعدل من الداتا بيس
    @IBOutlet weak var tableViews: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        loaddata()
        
    }
    
    
    func savedata() {
        
        do{
            try context.save()
        }catch {
            print(error)
        }
        tableViews.reloadData() // ubdate data
    }
    
    func loaddata() {
        let requst : NSFetchRequest<Product> = Product.fetchRequest()
        do {
            arrProduct = try context.fetch(requst)
        }catch{
            print(error)
        }
        tableViews.reloadData()
    }
    //IBAction
    
    @IBAction func addProduct(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Alert", message: "please Add new Product", preferredStyle: .alert)
        alert.addTextField{ alertTextField in
            alertTextField.placeholder = "add new product"
            textField = alertTextField
            
        }
        let action = UIAlertAction(title: "OK", style: .default) {action in
            var newProduct = Product(context: self.context)
            newProduct.name = textField.text
            self.arrProduct.append(newProduct)
            self.savedata()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
}


extension ViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViews.dequeueReusableCell(withIdentifier: "Cell" ) as! UITableViewCell
        cell.textLabel?.text = arrProduct[indexPath.row].name
        cell.backgroundColor = .systemGray3
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(arrProduct[indexPath.row])
            arrProduct.remove(at: indexPath.row)
            self.savedata()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Update product", message: "Enter new product", preferredStyle: .alert)
        
        alert.addTextField{alertTextField in
            alertTextField.placeholder = "add a new product"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Update", style:.default) {action in
            self.arrProduct[indexPath.row].setValue(textField.text!, forKey: "name")
            self.savedata()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            let alert = UIAlertController(title: "Empty", message: "please Enter product", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            let request = Product.fetchRequest()
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            do {
                arrProduct = try context.fetch(request)
            }catch {
                print(error)
            }
            tableViews.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loaddata()
        }
        
    }
}
