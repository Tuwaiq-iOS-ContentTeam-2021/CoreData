//
//  ViewController.swift
//  coreDataPractice
//
//  Created by mac on 24/11/2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var arrProduct = [Product]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var themeBtnOutlet: UIButton!
    @IBOutlet weak var searchOutlet: UISearchBar!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var tableView01: UITableView!
    
    let defaults = UserDefaults.standard
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonOutlet.layer.cornerRadius = 15
        themeBtnOutlet.layer.cornerRadius = 15
        
        loadData()
        
        flag = defaults.bool(forKey: "theme")
        if flag {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light

        }

    }
    
    func saveData() {
        do {
           try context.save()
        }catch {
            print(error.localizedDescription)
        }
        
        tableView01.reloadData()
    }
    
    func loadData() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            arrProduct = try context.fetch(request)
        }catch{
            print(error)
        }
        
        tableView01.reloadData()
    }


    @IBAction func buttonClicked(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "", message: "please add new product", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "new product"
            textField = alertTextField
        }
        
         let action = UIAlertAction(title: "Ok", style: .default) { action in
            let newProduct = Product(context: self.context)
            newProduct.name = textField.text
            self.arrProduct.append(newProduct)
            self.saveData()
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func themeBtnClicked(_ sender: Any) {
        flag.toggle()
        UserDefaults.standard.set(flag,forKey: "theme")
        if flag {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = arrProduct[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "", message: "Update your product", preferredStyle: .alert)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Write new name"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Update", style: .default) { action in
            self.arrProduct[indexPath.row].setValue(textField.text, forKey: "name")
            
            self.saveData()
        }
        alert.addAction(action)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            context.delete(arrProduct[indexPath.row])
        
            let alert = UIAlertController(title: "", message: "Are you sure to delete \"\(arrProduct[indexPath.row].name!)\"?", preferredStyle: .alert)
            
            let action2 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alert.addAction(action2)
            
            let action = UIAlertAction(title: "Ok", style: .default, handler: { action in
                            
                self.arrProduct.remove(at: indexPath.row)
                self.saveData()
            })
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        
        }
    }

    
    
   
    
    
}
extension ViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count == 0 {
            
            let alert = UIAlertController(title: "Empty", message: "Please enter somthing", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        }else {
        print(searchBar.text!)
        let request = Product.fetchRequest()
            
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            arrProduct = try context.fetch(request)
        }catch {
            print(error)
        }
        tableView01.reloadData()
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()

        }
    }
}
