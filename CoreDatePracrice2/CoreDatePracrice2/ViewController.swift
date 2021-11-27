
import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var arrayWord = [Word]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        loadData()
    }
    
    func saveData(){
        do{
            try context.save()
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadData(){
        let request: NSFetchRequest <Word> = Word.fetchRequest()
        do{
            arrayWord = try context.fetch(request)
        }
        catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    @IBAction func addWord(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Word", message: nil, preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add New Word"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Done", style: .default){ action in
            let newWord = Word(context: self.context)
            newWord.name = textField.text
            self.arrayWord.append(newWord)
            self.saveData() // becus im outside cluser,
        }
        // load استرجع
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayWord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        cell.label?.text = arrayWord[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Update Word", message: nil, preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add updated word"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Update", style: .default) { action in
            self.arrayWord[indexPath.row].setValue(textField.text!, forKey: "name")
            self.saveData()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            context.delete(arrayWord[indexPath.row])
            arrayWord.remove(at: indexPath.row)
            self.saveData()
        }
    }
}


extension ViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 { // if no word entered
            print(searchBar.text)
            let alert = UIAlertController(title: "Empty", message: "please enter word name", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default, handler:  nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            let request = Word.fetchRequest()
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!) //match يقارن السيرش مع الكور داتا اذا تطابق جبها لي
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            do{
                arrayWord = try context.fetch(request)
            } catch {
                print(error)
            }
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
        }
    }
}
