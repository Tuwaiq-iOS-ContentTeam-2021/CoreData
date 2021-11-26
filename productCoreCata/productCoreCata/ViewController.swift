//
//  ViewController.swift
//  productCoreCata
//
//  Created by TAGHREED on 19/04/1443 AH.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    
    @IBOutlet weak var addbutton: UIButton!
    @IBOutlet weak var searchBarr: UISearchBar!
    @IBOutlet weak var tv: UITableView!
    var arrProduct = [Product]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        addbutton.layer.cornerRadius = 10
        tv.layer.cornerRadius = 10
        // searchBarr.delegate = self
   }
    
    /// Functions  ///
    //to save data
    func saveData(){
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
        tv.reloadData()
    }
    
    //to bring data back from coredata
    func loadData(){
        
        
        let request:NSFetchRequest<Product> = Product.fetchRequest()
        do{
            arrProduct = try  context.fetch(request)
        }catch{
            print(error.localizedDescription)
        }
        
        tv.reloadData()
        
    }
    
    ///IBAction  ///
    
    @IBAction func add(_ sender: Any) {
        var textF = UITextField()
        var alert = UIAlertController (title: "Alert", message: "Please add new product", preferredStyle: .alert)
        
        alert.addTextField { alertTF in
            alertTF.placeholder = "add here"
            textF = alertTF
        }
        
        let action = UIAlertAction(title: "ok", style: .default) { action in
            var newProduct = Product(context: self.context)
            newProduct.name = textF.text
            self.arrProduct.append(newProduct)//add new to the array
            self.saveData()//save the new product
        }
        
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
}



extension ViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = arrProduct[indexPath.row].name
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            context.delete(arrProduct[indexPath.row])//delete c coredata
            arrProduct.remove(at: indexPath.row)//delete delete TV
            self.saveData()
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var tf = UITextField()
        let alert = UIAlertController(title: "Update Product", message: "Add a new product", preferredStyle: .alert) // alert obj
        
        alert.addTextField { alertTF in
            alertTF.placeholder = "add here"
            tf = alertTF
        }// add TextField to the alert obj
        
        let action = UIAlertAction(title: "Update", style: .default) { action in
            self.arrProduct[indexPath.row].setValue(tf.text, forKey: "name")
            self.saveData()
        }// declare a custom action
        
        alert.addAction(action) // addAction to the alert obj
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) // add a Cancel Action
        present(alert, animated: true, completion: nil) // to show/present the alert when i click
    }
    
    
}



extension ViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {// show alert when searchBar empty
            
            let alert = UIAlertController(title: "empty", message: "Please enter  product name", preferredStyle: .alert)
            let action = UIAlertAction (title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }else{
            print(searchBar.text)
            let req = Product.fetchRequest()
            req.predicate = NSPredicate(format: "name CONTAINS[CD] %@", searchBar .text!)//فنكشن للمطابقه
            req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]//sort for the same letter
            
            // this is a loadData() function
            do{
                arrProduct = try context.fetch(req)
            }catch{
                print(error)
            }
            tv.reloadData()
        }
    }
    //this func to return to the main veiw after a search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
        }
    }
    
    
}





































//alert function
//    override func viewDidAppear(_ animated: Bool) {
//        let alert = UIAlertController(title: "Alert", message: "Please add new product", preferredStyle: .alert)
//        let action = UIAlertAction (title: "Ok", style: .default, handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }
