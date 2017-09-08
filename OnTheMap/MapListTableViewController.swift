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
    
    /// View which contains the loading text and the spinner
    let loadingView = UIView()
    
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    /// Text shown during load the TableView
    let loadingLabel = UILabel()

        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLoadingScreen()
        spinner.hidesWhenStopped = true
    }
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner

        let x = (tableView.frame.width / 2)
        let y = (tableView.frame.height / 2) - (navigationController?.navigationBar.frame.height)!
        // Sets spinner
        spinner.activityIndicatorViewStyle = .gray
        spinner.frame = CGRect(x: x, y: y, width: 30, height: 30)
        //tableView.addSubview(loadingView)
        tableView.addSubview(spinner)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // reload data!
        tableView.reloadData()
    }
    
    @IBAction func freshTable(sender: Any) {
        spinner.startAnimating()
        Client.sharedInstance().getStudentLocationsData { (success, errorString) in
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
            if success {
                self.tableView.reloadData()
                
            } else {
                Client.sharedInstance().showAlert(hostController: self, warningMsg: Message.UIError.Data)
            }
        }
        

    }
    
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (Client.sharedInstance().studentInformationSet?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath)
        
        cell.imageView?.image = UIImage.init(named: "icon_pin")
        let index = indexPath.row
        let studentInfo = Client.sharedInstance().studentInformationSet?[index]
        cell.textLabel?.text = (studentInfo?.firstName)! + " " + (studentInfo?.lastName)!
        // Configure the cell...

        return cell
    }
    
    // Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let app = UIApplication.shared
        if let toOpen = Client.sharedInstance().studentInformationSet?[indexPath.row].mediaURL {
            if let url = URL.init(string: toOpen) {
                app.open(url, options: [:], completionHandler: { (success) in
                    if (success) {
                        print("Successfully open url")
                    } else {
                        Client.sharedInstance().showAlert(hostController: self, warningMsg: Client.WebUrlError.OpenUrl )
                    }
                })
            }
        }
    }
    
 
    // Outlet Section
    @IBAction func createLocation(sender: Any) {
        // check if previous submission exists
        Client.sharedInstance().checkSubmit { (postedLocation, error) in
            
            if error != nil {
                Client.sharedInstance().showAlert(hostController: self, warningMsg: error!)
                
            }
            else {
                DispatchQueue.main.async {
                    if postedLocation {
                        // set existed as true
                        self.showAlert()
                    }
                    else {
                        self.performSegue(withIdentifier: Client.SegueIdentifierConstant.TableVCToLocationVC, sender: self)
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
            Client.sharedInstance().log("Overwrite Pressed")
            // let mapViewController know/listen to mapPin is added event
            self.performSegue(withIdentifier: Client.SegueIdentifierConstant.TableVCToLocationVC, sender: self)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            Client.sharedInstance().log("Cancel Pressed")
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
