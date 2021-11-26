//
//  ViewController.swift
//  CoreDataEx
//
//  Created by nouf on 24/11/2021.
//

import UIKit
import CoreData

class ViewController: UIViewController  {
    
    var arrayTasks  = [Tasky]()
    let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    
    @IBOutlet weak var tabelViwe: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    
    
    
    @IBAction func addTasks(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "اضافة" , message: "اضافة مهامك ", preferredStyle: .alert)
        alert.addTextField { alertTextFild in
            alertTextFild.placeholder = "اسم المهمة"
            textField = alertTextFild
        }
        let action = UIAlertAction(title: "حفظ", style: .default) { action in
            let newTask = Tasky(context: self.context)
            newTask.name = textField.text
            self.arrayTasks.append(newTask)
            self.saveData()
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "الغاء", style: .cancel , handler: nil ))
        present(alert, animated: true , completion: nil)
    }
    
    
    func saveData(){
        do {
            
            try    context.save()
        } catch {
            print(error.localizedDescription)
        }
        tabelViwe.reloadData()
    }
    
    func loadData() {
        let request : NSFetchRequest<Tasky> = Tasky.fetchRequest()
        do {
            arrayTasks = try context.fetch(request)
            
        } catch {
            print(error)
        }
        tabelViwe.reloadData()
    }
        

   
}

//MARK: -TableView

extension ViewController:  UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabelViwe.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.textLabel?.text = arrayTasks[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textField = UITextField()
        let alert = UIAlertController(title: " تعديل" , message: "اضافة مهامك ", preferredStyle: .alert)
        alert.addTextField { alertTextFild in
            alertTextFild.placeholder = "اسم المهمة"
            textField = alertTextFild
        }
        let action = UIAlertAction(title: "حفظ", style: .default) { action in
            
            self.arrayTasks[indexPath.row].setValue(textField.text, forKey: "name")
            self.saveData()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "الغاء", style: .cancel , handler: nil ))
        present(alert, animated: true , completion: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(arrayTasks[indexPath.row])
            arrayTasks.remove(at: indexPath.row)
            
            saveData()
            
        }
    }
    

    
}


//MARK: -SearchBar


extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        if searchBar.text?.count == 0 {
//            let alert = UIAlertController(title: "تنبية" , message: "ادخل اسم المهمة", preferredStyle: .alert)
//            let action = UIAlertAction(title: "حفظ" , style: .default, handler: nil)
//            alert.addAction(action)
//            present(alert, animated: true , completion: nil)
          
        } else {
    
        let request : NSFetchRequest<Tasky> = Tasky.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@",  searchBar.text! )
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            arrayTasks = try context.fetch(request)
            
        } catch {
            print(error)
        }
        tabelViwe.reloadData()
    }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

      loadData()
    }
    
}
