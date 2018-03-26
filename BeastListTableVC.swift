//
//  BeastListTableVC.swift
//  beastListExam
//
//  Created by Josh Harsono on 3/23/18.
//  Copyright © 2018 Josh Harsono. All rights reserved.
//

import UIKit
import CoreData

class BeastListTableVC: UITableViewController {
    
    
    var items: [BeastListItem] = []

    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate) //access the AppDelegate.swift file
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    
    //define the rows:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    //what goes in each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create the cell with the identifier's contents for an indexpath
        let cell = tableView.dequeueReusableCell(withIdentifier: "beastListCell") as! CustomCell //OF TYPE CUSTOM CELL
        if let text = items[indexPath.row].text {
            cell.taskLabel.text = text
                    }
        return cell
    }
    
    
    
    //FETCH INCOMPLETE TASKS
    
    func fetchIncomplete() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BeastListItem")
        request.predicate = NSPredicate(format: "completed == %@", NSNumber(value: false))
        
        do {
            let result = try managedObjectContext.fetch(request)
            items = result as! [BeastListItem]
        } catch {
            print("\(error)")
        }
    }
    
    
    //PREPARE FOR SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let addItemViewController = navigationController.topViewController as! AddItemVC
        addItemViewController.delegate = self
        
        if let indexPath = sender as? NSIndexPath {
            let item = items[indexPath.row]
            
            addItemViewController.taskTitle = item.text
            addItemViewController.indexPath = indexPath
            
            
        }
    }
    
    
    //BEAST IT

    @IBAction func beastTest(_ sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
                
        if let ip = indexPath {
            let item = items[ip.row]
            item.completed = true
            item.completionDate = Date()
            self.items.remove(at: ip.row)

        }
        appDelegate.saveContext()
        
        tableView.reloadData()
        
    }
    

    //DELETING
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let item = self.items[indexPath.row]
            self.managedObjectContext.delete(item)
            self.appDelegate.saveContext()
            
            self.items.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
        
        return [delete]
    }
    
    //EDITING
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         self.performSegue(withIdentifier: "addItemSegue", sender: indexPath)
        
            }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchIncomplete()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

extension BeastListTableVC: AddItemVCDelegate {
    func itemSaved(by controller: AddItemVC, with text: String, at indexPath: NSIndexPath?) {
        if let ip = indexPath {
            
            let item = items[ip.row] //look at the item, then update the text
            item.text = text
            
        } else {
            let item = NSEntityDescription.insertNewObject(forEntityName: "BeastListItem", into: managedObjectContext) as! BeastListItem
            item.text = text
            item.completed = false
            items.append(item)
        }
        
        appDelegate.saveContext()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonPressed(by controller: AddItemVC) {
        dismiss(animated: true, completion: nil)

    }

}
