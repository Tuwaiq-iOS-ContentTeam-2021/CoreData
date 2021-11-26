//
//  ViewController.swift
//  CoreDataPractice
//
//  Created by Areej Mohammad on 19/04/1443 AH.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate {
    
    var arrayNames :[Names] = []
    var context = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        loadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "MyCell") as! MyCell
        cell.textLabel?.text = arrayNames[indexPath.row].name
        return cell
    }
    func saveData(){
        do {
            try context.save()
        } catch {
            print(error)
        }
        tableview.reloadData()
    }
    func loadData(){
        let request : NSFetchRequest <Names> = Names.fetchRequest()
        do {
            arrayNames = try context.fetch(request)
        }catch {
            print(error)
        }
        tableview.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        var textField = UITextField()
        let alert = UIAlertController(title: "Change Name", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Update Name", style: .default) { (action) in
            self.arrayNames[indexPath.row].setValue(textField.text, forKey: "name")
            self.saveData()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Name Here"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            context.delete(arrayNames[indexPath.row])
            arrayNames.remove(at: indexPath.row)
            saveData()
        }
    }
    
    @IBAction func addProducts(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Create New Name", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Name", style: .default) { (action) in
            let newName = Names(context: self.context)
            
            newName.name = textField.text
            self.arrayNames.append(newName)
            self.saveData()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Name Here"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == true {
            let alert = UIAlertController(title: "Note", message: "Please Enter something", preferredStyle: .alert)
            let ation = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(ation)
            present(alert, animated: true, completion: nil)
            loadData()
        } else {
            print(searchBar.text!)
            let request = Names.fetchRequest()
            request.predicate = NSPredicate(format: "name CONTAINS[CD] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            do {
                arrayNames = try context.fetch(request)
            }catch  {
                print("Error loading data \(error)")
            }
            tableview.reloadData()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadData()
    }
}


