//
//  MapListTableViewController.swift
//  OnTheMap
//
//  Created by stephen on 8/30/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import UIKit

class MapListTableViewController: UITableViewController {
    let tableCellIdentifier = "MapListTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Client.sharedInstance().getStudentLocationsFromParse { (success) in
            if (!success) {
                print("Error Getting Locations from PARSE: MapListTableview VC")
            }
        }
    }

    
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (Client.sharedInstance().mapPins?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath)
        
        cell.imageView?.image = UIImage.init(named: "icon_pin")
        let index = indexPath.row
        let mapPin = Client.sharedInstance().mapPins?[index]
        cell.textLabel?.text = (mapPin?.firstName)! + " " + (mapPin?.lastName)!
        // Configure the cell...

        return cell
    }
    
    // Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let app = UIApplication.shared
        if let toOpen = Client.sharedInstance().mapPins?[indexPath.row].mediaURL {
            app.open(URL.init(string: toOpen)!, options: [:], completionHandler: { (success) in
                if (success) {
                    print("Successfully open url")
                } else {
                    print("Failed to open url")
                }
            })
        }
    }
    
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
