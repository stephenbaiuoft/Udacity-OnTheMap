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
    let gotoAddLocationIdentifier = "gotoAddLocationIdentifierTableVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Client.sharedInstance().getStudentLocationsFromParse { (success) in
            if (!success) {
                print("Error Getting Locations from PARSE: MapListTableview VC")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // reload data!
        tableView.reloadData()
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
            if let url = URL.init(string: toOpen) {
                app.open(url, options: [:], completionHandler: { (success) in
                    if (success) {
                        print("Successfully open url")
                    } else {
                        print("Failed to open url")
                    }
                })
            }
        }
    }
    
 
    // Outlet Section
    @IBAction func createLocation(sender: Any) {
        // check if previous submission exists
        Client.sharedInstance().checkSubmit { (existed, error) in
            
            if existed == nil {
                print("Error in Processing Get Location")
            }
            else {
                DispatchQueue.main.async {
                    if existed! {
                        // set existed as true
                        self.showAlert()
                        
                    }
                    else {
                        self.performSegue(withIdentifier: self.gotoAddLocationIdentifier, sender: self)
                    }
                }
            }
            
        }
        
    }
    
    @IBAction func logOut(sender: Any) {
        
        Client.sharedInstance().udacityLogOut { (success, nsError) in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Problem Logging Out")
                }
            }
            
        }
    }
    
    // Show Alert UI
    func showAlert() {
        let alertController = UIAlertController(title: "", message: "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location?", preferredStyle: UIAlertControllerStyle.alert)
        let overWriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            // MARK: Overwrite Section on MapViewController
            print("Overwrite Pressed")
            // let mapViewController know/listen to mapPin is added event
            Client.sharedInstance().subscribeToAddLocationViewController(chosenViewController: self, type: 1)
            self.performSegue(withIdentifier: self.gotoAddLocationIdentifier, sender: self)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel Pressed")
        }
        
        alertController.addAction(overWriteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // NS notification
    func reloadTableView(_ notification: NSNotification){
        // call this method to re-load data
        self.tableView.reloadData()
    }
    
}
