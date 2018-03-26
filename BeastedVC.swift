//
//  BeastedVC.swift
//  beastListExam
//
//  Created by Josh Harsono on 3/23/18.
//  Copyright © 2018 Josh Harsono. All rights reserved.
//

import UIKit
import CoreData

class BeastedVC: UITableViewController {
    
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "completedCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].text!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM d"
        if let beastedDate = items[indexPath.row].completionDate {
        let formattedDate = dateFormatter.string(from: beastedDate)
        cell.detailTextLabel?.text = formattedDate
        }
        return cell
    }

    
    //FETCH BEASTED
    
    func fetchCompleted() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BeastListItem")
        request.predicate = NSPredicate(format: "completed == %@", NSNumber(value: true))
        
        do {
            let result = try managedObjectContext.fetch(request)
            items = result as! [BeastListItem]
        } catch {
            print("\(error)")
        }
    }
    
    //DELETE
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        fetchCompleted()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchCompleted()
        tableView.reloadData()

    }
}
