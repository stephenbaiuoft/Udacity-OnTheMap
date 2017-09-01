//
//  ClientObserver.swift
//  OnTheMap
//
//  Created by stephen on 8/30/17.
//  Copyright © 2017 Bai Cloud Tech Co. All rights reserved.
//

import Foundation
import UIKit

extension Client {

    
    // let chosenViewController received notification, addMapPinWillShow
    func subscribeToAddLocationViewController( chosenViewController: UIViewController, type: Int ) {
        if (type == 0){
            let chosenViewController = chosenViewController as! MapViewController
            NotificationCenter.default.addObserver(chosenViewController, selector: #selector( chosenViewController.addedMapPinWillShow(_:)), name: NSNotification.Name.init(Client.NotificationConstant.MapPinAdded), object: nil)
        } else {
            let chosenViewController = chosenViewController as! MapListTableViewController
            NotificationCenter.default.addObserver(chosenViewController, selector: #selector( chosenViewController.reloadTableView(_:)), name: NSNotification.Name.init(Client.NotificationConstant.MapPinAdded), object: nil)
        }
    }
    
    // unsubscribe chosenViewControler from the notification, addMapPinWillShow
    func unsubscribeFromAddLocationViewController(chosenViewController: UIViewController) {
        NotificationCenter.default.removeObserver(chosenViewController, name: NSNotification.Name.init(Client.NotificationConstant.MapPinAdded), object: nil)
        
    }
}
