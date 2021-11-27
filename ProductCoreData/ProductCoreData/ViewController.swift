//
//  ViewController.swift
//  ProductCoreData
//
//  Created by Taraf Bin suhaim on 19/04/1443 AH.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var arrayproduct = [Product]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.delegate = self
        tabelView.dataSource = self
        searchBar.delegate = self
        loadData()
    }
    
    func saveData(){
        do {
            try context.save()
        } catch{
            print(error)
        }
        tabelView.reloadData()
    }
    
    func loadData(){
        let request : NSFetchRequest<Product> = Product.fetchRequest()
        do {
            arrayproduct = try context.fetch(request)
        } catch {
            print(error)
        }
        tabelView.reloadData()
    }
    
    @IBAction func addProduct(_ sender: Any) {
        
        var textField = UITextField()
        
        let alart = UIAlertController(title: "Alart", message: "Add new product", preferredStyle: .alert)
        alart.addTextField { alartTextField in
            alartTextField.placeholder = "Add new product"
            textField = alartTextField
        }
        let action = UIAlertAction(title: "OK", style: .default){ action in
            let newProduct = Product(context: self.context)
            newProduct.name = textField.text
            self.arrayproduct.append(newProduct)
            self.saveData()
        }
        alart.addAction(action)
        alart.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alart, animated: true, completion: nil)
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayproduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabelView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.textLabel?.text = arrayproduct[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textField = UITextField()
        let alart = UIAlertController(title: "Update Product", message: "update product", preferredStyle: .alert)
        alart.addTextField{ alartTextField  in
            alartTextField.placeholder  = "update vlaue of product"
            textField = alartTextField
        }
        let action = UIAlertAction(title: "Update", style: .default) { action in
            self.arrayproduct[indexPath.row].setValue(textField.text, forKey: "name")
            self.saveData()
        }
        alart.addAction(action)
        alart.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alart, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(arrayproduct[indexPath.row])
            arrayproduct.remove(at: indexPath.row)
            saveData()
        }
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text == "" {
            let alart = UIAlertController(title: "Empty", message: "enter product", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alart.addAction(action)
            present(alart, animated: true, completion: nil)
        } else {
            let request =  Product.fetchRequest()
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            do {
                arrayproduct = try context.fetch(request)
            } catch {
                print(error)
            }
            tabelView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadData()
    }
}
