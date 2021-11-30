
import UIKit

import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
        var listItemArray = [ListItem]()
        @IBOutlet weak var tableView: UITableView!
        

        override func viewDidLoad() {
            super.viewDidLoad()
            
            loadData()
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             return listItemArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
            cell.backgroundColor = .clear
            cell.textLabel?.text = listItemArray[indexPath.row].name
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            
            var textField = UITextField()
            let alert = UIAlertController(title: "Change ListService Name", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Update Service", style: .default) { (action) in
                self.listItemArray[indexPath.row].setValue(textField.text, forKey: "name")
                self.saveData()
            }
            alert.addAction(action)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "New Item Here"
                textField = alertTextField
            }
            present(alert, animated: true, completion: nil)
        }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            context.delete(listItemArray[indexPath.row])
            listItemArray.remove(at: indexPath.row)
            saveData()
        }
    }
        @IBAction func addButtonPressed(_ sender: Any) {
            var textField = UITextField()
            let alert = UIAlertController(title: "Choose a new Service", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Service", style: .default) { (action) in
                let newItem = ListItem(context: self.context)
                
                newItem.name = textField.text
                self.listItemArray.append(newItem)
                self.saveData()
            }
            alert.addAction(action)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "New Service Here"
                textField = alertTextField
            }
            present(alert, animated: true, completion: nil)
            
        }
        
        func saveData() {
            do {
            try context.save()
            } catch {
                print("Error saving context \(error)")
            }
            tableView.reloadData()
        }
        
        func loadData() {
            let request : NSFetchRequest<ListItem> = ListItem.fetchRequest()
            
            do {
                listItemArray = try context.fetch(request)
            } catch {
                print("Error loading data \(error)")
            }
            tableView.reloadData()
        }
    }

