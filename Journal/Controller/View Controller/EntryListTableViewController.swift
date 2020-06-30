//
//  EntryListTableViewController.swift
//  Journal
//
//  Created by Victor Monteiro on 6/29/20.
//  Copyright © 2020 Atomuz. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEntries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    //MARk: Helper Methods
    func loadEntries() {
        EntryController.shared.fetchEntries { (result) in
            switch result {
            case .success(_):
                self.reloadView()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func reloadView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryController.shared.entries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        let entries = EntryController.shared.entries[indexPath.row]
        
        cell.textLabel?.text = entries.title
        cell.detailTextLabel?.text = entries.timeStamp.dateToString()
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailVC" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let detailVC = segue.destination as? EntryDetailViewController else { return }
            let entry = EntryController.shared.entries[indexPath.row]
            
            detailVC.entry = entry
        }
    }
    
    
}
