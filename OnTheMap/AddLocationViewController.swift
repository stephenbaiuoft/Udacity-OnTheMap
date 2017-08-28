//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by stephen on 8/27/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    // MARK: Variables
    
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var displayTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: IBAction 
    
    @IBAction func cancel(sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
}
