//
//  ViewController.swift
//  CorePro
//
//  Created by Qahtani's MacBook Pro on 11/24/21.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewData.dequeueReusableCell(withIdentifier: "cell-id")
        cell?.textLabel?.text = listArry[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var textFeild = UITextField()
        let alert = UIAlertController(title: "تغيير الكلمة ", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "حفظ", style: .default){ (action) in
            self.listArry[indexPath.row].setValue(textFeild.text, forKey: "name")
            self.saveData()
            
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "أدخل الكلمة المحدثة"
            textFeild = alertTextFeild
            
        }
        present(alert, animated: true, completion: nil)
    }
       
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty == true {
            loadData()
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        if searchBar.text?.count == 0 {
        let alert = UIAlertController(title: "Empty", message: "please enter product name", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(action)
    present(alert, animated: true, completion: nil)

    }else{
        let request = Listtem.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key:"name", ascending: true)]
        do{
            listArry = try context.fetch(request)
        }catch{
            print(error)
        }
        tableViewData.reloadData()
    }
}
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            context.delete(listArry[indexPath.row])
            listArry.remove(at: indexPath.row)
            saveData()
            
        }
            
    }
    
  
    
    

    @IBOutlet weak var labeltext: UILabel!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var listArry = [Listtem]()
    
    
    @IBOutlet weak var tableViewData: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        searchBar.delegate = self
        tableViewData.delegate = self
        tableViewData.dataSource = self
    }
    
    
    func saveData() {
        do{
            try context.save()
        }catch{
            print(error)
        }
        self.tableViewData.reloadData()
    }
    
    
    func loadData(){
        let request: NSFetchRequest<Listtem> = Listtem.fetchRequest()
        do{
            listArry = try context.fetch(request)
            
        }catch{
            print(error)
        }
        tableViewData.reloadData()
    }


    @IBAction func okAction(_ sender: Any) {
        
        var textFeild = UITextField()
        let alert = UIAlertController(title: "إنشاء كلمة جديدة", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "حفظ", style: .default){ (action) in
            let newWord = Listtem(context: self.context)
            newWord.name = textFeild.text
            self.listArry.append(newWord)
            
            self.saveData()
            
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
        
        
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "أدخل كلمة جديدة"
            textFeild = alertTextFeild
            
        }
        
        present(alert, animated: true, completion: nil)
                
    }
    
}
