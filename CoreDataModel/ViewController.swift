//
//  ViewController.swift
//  CoreDataModel
//
//  Created by Nora on 20/04/1443 AH.
//

import UIKit
import CoreData
import QuartzCore

class ViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {

    @IBOutlet weak var habitlebel: UILabel!
    
   
    @IBOutlet weak var habitbutton: UIButton!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var listHabits = [Habits]()
    
    
    func loadingData() {
        let request : NSFetchRequest<Habits> = Habits.fetchRequest()
        
        do{
            listHabits = try context.fetch(request)
            
        } catch {
            print("Error handling data\(error)")
        }
        tableView.reloadData()
    }
    
    
    
    func saveData() {
        do {
            try context.save()
        }catch {
            print("Error saving context\(error)")
        }
        tableView.reloadData()
        
    }
    @IBAction func addingHabit(_ sender: Any) {
        
        var textFeild = UITextField()
        let alert = UIAlertController(title: "Add new healthy habit", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "save", style: .default) { (action) in
            
            let newHabit = Habits(context: self.context)
            newHabit.name = textFeild.text
            self.listHabits.append(newHabit)
            self.saveData()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "Add new habit"
            
            textFeild = alertTextFeild
        }
        
        present(alert,animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        habitlebel.layer.cornerRadius = 20
        habitlebel.layer.masksToBounds = true
        habitbutton.layer.cornerRadius = 10
    }

    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listHabits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = listHabits[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var textFeild = UITextField()
        let alert = UIAlertController(title: "new habit", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "edit", style: .default) { (action) in
            
            self.listHabits[indexPath.row].setValue(textFeild.text, forKey: "name")
            self.saveData()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "Add new habit"
            
            textFeild = alertTextFeild
        }
        
        present(alert,animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            context.delete(listHabits[indexPath.row])
            listHabits.remove(at: indexPath.row)
            saveData()
        }
    }

    }
 



