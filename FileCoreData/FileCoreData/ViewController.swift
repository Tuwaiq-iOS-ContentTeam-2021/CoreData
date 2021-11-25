//
//  ViewController.swift
//  FileCoreData
//
//  Created by Abdullah AlRashoudi on 11/24/21.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    let fileManager = FileManager.default
    var directoryUrl: URL?
        var arrayFiles = [Files]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fileName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       directoryUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        reloadDate()
    }
    //IBAction
    @IBAction func createFile(_ sender: Any) {
        let creatFile = directoryUrl?.appendingPathComponent(fileName.text! + ".txt")
        let content = "Hello".data(using: .utf8)
        fileManager.createFile(atPath: creatFile!.path, contents: content, attributes: [:])
        addToCoreData(url: "\(String(describing: creatFile?.path))")
        reloadDate()
        tableView.reloadData()
        print(directoryUrl!.path)
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addToCoreData(url: String) {
        let coreData = Files(context: context)
        coreData.path = "\(url)"
        coreData.name = fileName.text!
        saveData()
    }
    
    func reloadDate() {
        do {
            arrayFiles = try context.fetch(Files.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FileCell
        cell.labelCell.text = arrayFiles[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            context.delete(arrayFiles[indexPath.row])
            arrayFiles.remove(at: indexPath.row)
            self.tableView.reloadData()
            saveData()
        }
    }
}
