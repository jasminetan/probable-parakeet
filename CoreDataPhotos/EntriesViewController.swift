//
//  EntriesViewController.swift
//  CoreDataPhotos
//
//  Created by Jasmine Tan on 4/10/20.
//  Copyright © 2020 Jasmine Tan. All rights reserved.
//

import UIKit
import CoreData

class EntriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var entriesTableView: UITableView!
    
    
    var entries = [Entry]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = entriesTableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        cell.textLabel?.text = entries[indexPath.row].title
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            entries = [Entry]()
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        do {
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            entries = try managedContext.fetch(fetchRequest)
        } catch {
            print( "Fetch for notes failed.")
        }
        
        entriesTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? EntryViewController else{
            return
        }
        
        if let segueIdentifier = segue.identifier, segueIdentifier == "entry", let indexPathForSelectedRow = entriesTableView.indexPathForSelectedRow {
            destination.entry = entries[indexPathForSelectedRow.row]
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRecipe(at: indexPath)
        }
    }
    
    
    func deleteRecipe(at indexPath: IndexPath){
        let entry = entries[indexPath.row]
        
        if let managedObjectContext = entry.managedObjectContext {
            managedObjectContext.delete(entry)
            
            do {
                try managedObjectContext.save()
                self.entries.remove(at: indexPath.row)
                entriesTableView.reloadData()
            } catch {
                print("Delete failed.")
                entriesTableView.reloadData()
            }
        }
        
    }
}
    
    
