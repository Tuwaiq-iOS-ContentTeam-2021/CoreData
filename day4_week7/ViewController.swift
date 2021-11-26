//
//  ViewController.swift
//  day4_week7
//
//  Created by AlDanah Aldohayan on 24/11/2021.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    let dataDelegate = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var wordArray: [Words] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchSorting: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchSorting.delegate = self
        loadData()
    }
    
    
    @IBAction func addNewWord(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a pretty word", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Words(context: self.dataDelegate)
            
            newItem.singleWord = textField.text
            self.wordArray.append(newItem)
            self.saveData()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New word"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        do {
            try dataDelegate.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }

    func loadData() {
        let request : NSFetchRequest <Words> = Words.fetchRequest()
        do {
            wordArray = try dataDelegate.fetch(request)
        }catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    
}
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = wordArray[indexPath.row].singleWord
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Change word", message: "add a new word", preferredStyle: .alert)
        let action = UIAlertAction(title: "Update", style: .default) { (action) in
            self.wordArray[indexPath.row].setValue(textField.text, forKey: "singleWord")
            self.saveData()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New word here"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            dataDelegate.delete(wordArray[indexPath.row])
            wordArray.remove(at: indexPath.row)
            saveData()
        }
    }
}


extension ViewController: UISearchBarDelegate{
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
          let request = Words.fetchRequest()
          request.predicate = NSPredicate(format: "singleWord CONTAINS [cd] %@", searchBar.text!)
          request.sortDescriptors = [NSSortDescriptor(key: "singleWord", ascending: true)]
          do {
            wordArray = try dataDelegate.fetch(request)
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
