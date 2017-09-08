//
//  DetailedMapViewController.swift
//  OnTheMap
//
//  Created by stephen on 9/1/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import UIKit
import MapKit

class DetailedMapViewController: UIViewController {
    // MARK Variable
    var webUrl: String? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupMapView()
    }

    // setupMapView: Note Client.shareInstance() is guaranteed to have searchedPlaceMark because of previous error handlings
    func setupMapView() {
        DispatchQueue.main.async {
            let placeMark = Client.sharedInstance().searchedPlaceMark!
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(placeMark.coordinate, 1000, 1000)
            self.mapView.setRegion(coordinateRegion, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = placeMark.coordinate
            annotation.title = Client.sharedInstance().firstName! + " " + Client.sharedInstance().lastName!
            annotation.subtitle = Client.sharedInstance().addedWebUrl!
            self.mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func finishPressed(sender: Any) {
        // Part 1: Submit this location information to PARSE SEVER
        Client.sharedInstance().submitToParse(hostController: self) { (success, errorString) in
            if !success {
                Client.sharedInstance().showAlert(hostController: self, warningMsg: Message.UIError.Submit)
                return
            } else {
                // Success!!!
                // Part 2: Call Client.sharedInstance.dataModel since I took it out in viewDidLoad for efficiency reason
                Client.sharedInstance().getStudentLocationsData { (success, errorString) in
                    if !success {
                        Client.sharedInstance().showAlert(hostController: self, warningMsg: errorString!)
                    }
                    
                    // Go back to TabVC now ;)
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}
