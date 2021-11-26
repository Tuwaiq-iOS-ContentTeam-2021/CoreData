//
//  ViewController.swift
//  CoreDataStoryboard
//
//  Created by loujain on 24/11/2021.
//

import UIKit
import CoreData
class ViewController: UIViewController{
    
    var arrayProduct = [Product]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        searchBar.delegate = self
        loadData()
    }
    
    @IBAction func buttonAdd(_ sender: Any) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Alert", message: "add new product", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "add new product"
            textField = alertTextField
        }

        let action = UIAlertAction(title: "ok", style: .default) { action in
            let newProduct = Product(context: self.context)
            newProduct.name = textField.text
            self.arrayProduct.append(newProduct)
            self.saveData()
        }

        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
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
        let request: NSFetchRequest <Product> = Product.fetchRequest()

        do {
        arrayProduct = try context.fetch(request)
    } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
}
   
    ///
    extension ViewController:UITableViewDelegate,UITableViewDataSource{
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrayProduct.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
            cell.textLabel?.text = arrayProduct[indexPath.row].name
            return cell
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                context.delete(arrayProduct[indexPath.row])
                arrayProduct.remove(at: indexPath.row)
                self.saveData()
            }
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            var texField = UITextField()
            let alert = UIAlertController(title: "Update Prouct", message: "add new product", preferredStyle: .alert)
            alert.addTextField{ (alertTextFiels) in
                               alertTextFiels.placeholder = "add a new product"
                               texField = alertTextFiels
            }
            let action = UIAlertAction(title: "Update", style: .default) {
                action in
                self.arrayProduct[indexPath.row].setValue(texField.text, forKey: "name")
                self.saveData()
            }
            alert.addAction(action)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
       
    }
//
extension ViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == true {
          let alert = UIAlertController(title: "Note", message: "Please enter something", preferredStyle: .alert)
          let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
          alert.addAction(action)
          present(alert, animated: true, completion: nil)
            loadData()
        }
        else{
          print(searchBar.text!)
          let request = Product.fetchRequest()
          request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
          request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
          do {
              arrayProduct = try context.fetch(request)
          } catch {
            print("Error loading data \(error)")
          }
          tableView.reloadData()
        }
      }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadData()
    }
}


