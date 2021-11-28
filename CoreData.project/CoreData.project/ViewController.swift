//
//  ViewController.swift
//  CoreData.project
//
//  Created by Badreah Saad on 27/11/2021.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var myAchievements: UITableView!
    @IBOutlet weak var titleField: UITextField!
    
    
    var achievementsArray: [Achievements] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myAchievements.dataSource = self
        myAchievements.delegate = self
        loadData()
        
    }
    
    @IBAction func add(_ sender: Any) {
        
        let achievements = NSEntityDescription.insertNewObject(forEntityName: "Achievements", into: context)
        achievements.setValue(titleField.text!, forKey: "title")
        
        print(achievements)
        self.saveData()

//        achievementsArray.removeAll()
        self.loadData()
    }
    
    
    func saveData() {
        do{
            try  context.save()
        } catch {
            print(error)
        }
        myAchievements.reloadData()
    }
    
    func loadData() {
        let request: NSFetchRequest<Achievements> = Achievements.fetchRequest()
        do {
            achievementsArray = try context.fetch(request)
            
        } catch {
            print(error)
        }
        myAchievements.reloadData()
        
    }
    
}


extension ViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievementsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myAchievements.dequeueReusableCell(withIdentifier: "ach") as! UITableViewCell
        
        cell.textLabel?.text = achievementsArray[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(achievementsArray[indexPath.row])
            achievementsArray.remove(at: indexPath.row)
            self.saveData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Update", message: "", preferredStyle: .alert)
        alert.addTextField { alerttext in
            alerttext.placeholder = "add new"
            textField = alerttext
        }
        
        
        let action = UIAlertAction(title: "save update", style: .default) { action in
            self.achievementsArray[indexPath.row].setValue(textField.text!, forKey: "title")
            self.saveData()
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
}

