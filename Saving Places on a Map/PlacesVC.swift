//
//  PlacesVC.swift
//  Saving Places on a Map
//
//  Created by Jawad Shuaib on 2016-10-20.
//  Copyright © 2016 Jawad Shuaib. All rights reserved.
//

import UIKit

class PlacesVC: UITableViewController {

    @IBOutlet var myTableView: UITableView!
    
    private var locations = [Location]()
    private var index = 0
    
    var filePath: String {
        let manager = FileManager()
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url?.appendingPathComponent("Location").path)!
    }
    
    private func loadData () {
        // Check if we actually have data
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Location] {
            locations = data
        } else {
            let hawaii = Location (placeName: "Hawaii, Honolulu", lat: "21.3281792", long: "-157.869113812")
            locations.append (hawaii)
                saveData()
        }
    }
    
    private func saveData () {
        NSKeyedArchiver.archiveRootObject (locations, toFile: filePath)
    }
    
    // only loads once when app starts
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // called everytime VC appears
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        myTableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = locations[indexPath.row].name
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // trigger segue
        index = indexPath.row
        performSegue(withIdentifier: "MapVC", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            locations.remove (at: indexPath.row)
            // Save the data
            saveData()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }   
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if we are going to MapVC
        if locations.count > 0 {
            if let destination = segue.destination as? MapVC {
                destination.currentLocation = locations[index]
                destination.locations = locations
                destination.filePath = filePath
            }
        }
    }
    

}
