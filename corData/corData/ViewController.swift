//
//  ViewController.swift
//  corData
//
//  Created by Abrahim MOHAMMED on 24/11/2021.
//

import UIKit
import CoreData

class ViewController: UIViewController{
   

   var arrProduct = [Product]()
    
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var MyTableViwe: UITableView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        MyTableViwe.dataSource = self
        MyTableViwe.delegate = self
        searchBar.delegate = self
        loadData()
    }


   
    
    
    
    @IBAction func AddProduct(_ sender: Any) {
        
        
        var textFiled = UITextField()
        
        let alert = UIAlertController (title: "Alert", message: "Add new product", preferredStyle: .alert)
        
        alert.addTextField { alertTextFiled in
            alertTextFiled.placeholder = "Add new product"
            
            textFiled = alertTextFiled
        }
        
        let action = UIAlertAction(title: "Ok", style: .default) { action in
            
            var newProduct = Product(context: self.contex)
            
            newProduct.name = textFiled.text
            self.arrProduct.append(newProduct)
            
            self.SaveData()
            
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    
    func SaveData(){
        
        do{
            
          try  contex.save()

            
            
        }catch{
            
            print(error)
            
        }
        MyTableViwe.reloadData()
        
        
    }
    
    func loadData(){
        
        let request:NSFetchRequest<Product> = Product.fetchRequest()
        
        do{
            
            
            arrProduct = try contex.fetch(request)

            
            
        }catch{
            
          print(error)
            
        }
        MyTableViwe.reloadData()
        
        
    }
    
    
    
}
    
    
extension ViewController : UISearchBarDelegate {
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        
      
            
            if searchBar.text?.count == 0 {
                        let alert = UIAlertController(title: "Empty", message: "Please enter somthing", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(action)
                        present(alert, animated: true, completion: nil)
            
            
            
        }
            else {
        
        
        let request = Product.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[CD] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do{
            
            arrProduct = try contex.fetch(request)
            
            
        }catch{
           print(error)
            
            
        }
            }
        MyTableViwe.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        loadData()
        
    }
    
    
    
    
    
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete{
            
         
            
            let alert = UIAlertController(title: "", message: "are you sure delete \(arrProduct[indexPath.row].name!) ? ", preferredStyle: .alert)
            
            let action2 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alert.addAction(action2)
            
            let action = UIAlertAction(title: "Ok", style: .default, handler: { action in
               
                self.contex.delete(self.arrProduct[indexPath.row])
               
                self.arrProduct.remove(at: indexPath.row)
                
                self.SaveData()
                
               
                
            })
           
            
            alert.addAction(action)

            
            present(alert, animated: true, completion: nil)
    
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = MyTableViwe.dequeueReusableCell(withIdentifier: "cell")
        as! UITableViewCell
        
        cell.textLabel?.text = arrProduct[indexPath.row].name
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        var textFiled = UITextField()
        
        
        let alert = UIAlertController(title: "Updata product", message: "addd new products", preferredStyle: .alert)
        
        alert.addTextField { alertTextFiled in
            
            alertTextFiled.placeholder = "add new updata"
            textFiled = alertTextFiled
        }
        
        let action = UIAlertAction(title: "Update", style: .default) { action in
            
            self.arrProduct[indexPath.row].setValue(textFiled.text, forKey: "name")
            self.SaveData()
            
        }
                    
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
       
        
    }
    
    
    
    
    
    
    
}



















