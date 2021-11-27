//
//  ViewController.swift
//  GroceryApp_CoreData
//
//  Created by Rayan Taj on 24/11/2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
   
    @IBOutlet weak var tableView: UITableView!
    
    var groceryArray : [Grocery] = [Grocery]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    

    
    @IBAction func addGroceryItemButtonClick(_ sender: Any) {
   
    myCustomAlert(title: "Grocery Alert", message:  "Add a new Grocery item", textFieldPlaceolder: "Add new Grocery", isAdd: true , index: -1)
    
    }
    
    func reloadData()  {
        let request : NSFetchRequest<Grocery> = Grocery.fetchRequest()
        
        do {
            try    groceryArray = context.fetch(request)

            tableView.reloadData()
        } catch  {
            
        }
    }

    
    func myCustomAlert(title :String , message : String , textFieldPlaceolder : String , isAdd: Bool , index : Int) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
      
        
        if isAdd{
            
            alert.addTextField { alertTextField in
                alertTextField.placeholder = textFieldPlaceolder
                textField = alertTextField
            }
            
            let action = UIAlertAction(title: "OK", style: .default) { action in
                
                let newGrocery = Grocery(context: self.context)
                
                newGrocery.item = textField.text
                self.groceryArray.append(newGrocery)
                do {
                    try  self.context.save()

                    self.reloadData()
                } catch  {
                    
                }
            }
            alert.addAction(action)
        }else{
            alert.addTextField { alertTextField in
                alertTextField.text = textFieldPlaceolder
                textField = alertTextField
            }
            
            let action = UIAlertAction(title: "Update", style: .default) { action in
                
                let groceryItem = self.groceryArray[index]
                groceryItem.item = textField.text
                
              
                do {
                    try  self.context.save()

                    self.reloadData()
                } catch  {
                    
                }
            }
            
            
            alert.addAction(action)
        }
      
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

reloadData()
        
    }


}


extension ViewController:UISearchBarDelegate {

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
  
    
        if searchBar.text?.count == 0 {
            
            reloadData()
            
        }else{
            let request = Grocery.fetchRequest()
          
            request.predicate = NSPredicate(format: "item CONTAINS[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "item", ascending: true)]
            
            do {
                
                try    groceryArray = context.fetch(request)

                tableView.reloadData()
                
            } catch  {
                
            }
        }
        
    }

    
}



extension ViewController:   UITableViewDelegate , UITableViewDataSource  {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groceryArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryTableViewCell") as! GroceryTableViewCell
        
        cell.namelabel.text = groceryArray[indexPath.row].item
    
        return cell
        
    }
    

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        do {
            
             context.delete(groceryArray[indexPath.row])
            try context.save()
            
        } catch  {
            
        }
       
        reloadData()
    
    }

  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        myCustomAlert(title: "Update", message:  "Update your grocery", textFieldPlaceolder: "\(groceryArray[indexPath.row].item!)", isAdd: false , index: indexPath.row)
        
        
        
        
    }
    
    
    
    
    
    
    
}
