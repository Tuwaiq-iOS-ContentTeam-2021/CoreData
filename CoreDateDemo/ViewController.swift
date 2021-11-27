//
//  ViewController.swift
//  CoreDateDemo
//
//  Created by Ebtesam Alahmari on 24/11/2021.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    var arrayProdect = [Product]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBer: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBer.delegate = self
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    
    
    @IBAction func addProduct(_ sender: UIBarButtonItem) {
        
        var textFieldName = UITextField()
        var textFieldDetails = UITextField()
        let alert = UIAlertController(title: "New", message: "Please add new product", preferredStyle: .alert)
        alert.addTextField { alartTextField in
            alartTextField.placeholder = "add new product"
            textFieldName = alartTextField
        }
        alert.addTextField { alartTextField in
            alartTextField.placeholder = "Details of product"
            textFieldDetails = alartTextField
        }
        let OkBtu = UIAlertAction(title: "OK", style: .default) { action in
            if textFieldName.text != "" && textFieldDetails.text != "" {
                var newProduct = Product(context: self.context)
                newProduct.name = textFieldName.text
                newProduct.details = textFieldDetails.text
                self.arrayProdect.append(newProduct)
                self.saveData()
            }
        }
        alert.addAction(OkBtu)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveData() {
        do {
            try context.save()
        }catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadData() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            arrayProdect = try context.fetch(request)
        }catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    
}


//MARK: -UITableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayProdect.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProductCell
        cell.productNameLbl.text = arrayProdect[indexPath.row].name
        cell.productDescriptionLbl.text = arrayProdect[indexPath.row].details
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var textFieldName = UITextField()
        var textFieldDetails = UITextField()
        let alert = UIAlertController(title: "Update product", message: "add a new product", preferredStyle: .alert)
        alert.addTextField { alartTextField in
            alartTextField.placeholder = "add new product"
            textFieldName = alartTextField
        }
        alert.addTextField { alartTextField in
            alartTextField.placeholder = "Details of product"
            textFieldDetails = alartTextField
        }
        
        let OkBtu = UIAlertAction(title: "Update", style: .default) { action in
            if textFieldName.text != "" && textFieldDetails.text != "" {
                self.arrayProdect[indexPath.row].setValue(textFieldName.text, forKey: "name")
                self.arrayProdect[indexPath.row].setValue(textFieldDetails.text, forKey: "details")
                self.saveData()
            }
        }
        alert.addAction(OkBtu)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(arrayProdect[indexPath.row])
            arrayProdect.remove(at: indexPath.row)
            self.saveData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

//MARK: -UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "Please enter product", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }else {
            let request = Product.fetchRequest()
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@ ", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
            do {
                arrayProdect =  try context.fetch(request)
            }catch {
                print("Error")
            }
            tableView.reloadData()
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadData()
    }
}
