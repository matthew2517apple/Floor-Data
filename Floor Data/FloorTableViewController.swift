//
//  FloorTableViewController.swift
//  Floor Data
//
//  Created by Matthew Curran on 4/16/19.
//  Copyright © 2019 Matthew. All rights reserved.
//

import UIKit
import CoreData

class FloorTableViewController: UITableViewController {
    
    var floors: [Floor] = []
    
    var managedContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate!.persistentContainer.viewContext
        
        refreshTable()
    }
    
    @IBAction func addFloor(_ sender: Any) {
        addFloor()
        refreshTable()
    }
    
    @IBAction func increasePrice(_ sender: Any) {
        increasePriceForSelectedFloor()
        refreshTable()  
    }
    
    @IBAction func deleteFloor(_ sender: Any) {
        deleteSelectedFloor()
        refreshTable()
    }
    
    func addFloor() {
        
        let floor = Floor(context: managedContext!)
        
        let prices = [20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
        let types = ["Carpet", "Wood", "Tile"]
        
        var randomIndex = Int(arc4random_uniform(UInt32(prices.count)))
        let price = prices[randomIndex]
        randomIndex = Int(arc4random_uniform(UInt32(types.count)))
        let type = types[randomIndex]
        
        floor.type = type
        floor.price = Float(price)
        
        do {
            try managedContext!.save()
        } catch {
            print("Error saving, \(error)")
        }
    }
    
    func deleteSelectedFloor() {
        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
        let row = selectedPath.row
        
        let floor = floors[row]
        
        managedContext!.delete(floor)
        
        do {
            try managedContext!.save()
        } catch {
            print("Error deleting \(error)")
        }
    }
    
    func increasePriceForSelectedFloor() {
        
        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
        let row = selectedPath.row
        
        let floor = floors[row]
        floor.price += 1
        
        do {
            try managedContext!.save()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func loadFloors() {
        let fetchRequest = NSFetchRequest<Floor>(entityName: "Floor")
        
        do {
            floors = try managedContext!.fetch(fetchRequest)
        } catch {
            print("Error fetching data because \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FloorCell")!
        let floor = floors[indexPath.row]
        cell.textLabel?.text = floor.type
        cell.detailTextLabel?.text = "$\(floor.price) per square foot"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return floors.count
    }
    
    func refreshTable() {
        loadFloors()
        tableView.reloadData()
    }
    
}




