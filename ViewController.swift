//
//  ViewController.swift
//  Swift-SampleApp
//
//  Created by Dustin Allen on 2/3/20.
//  Copyright © 2020 Gimbal. All rights reserved.
//

import UIKit
import Gimbal

class ViewController: UIViewController, GMBLCommunicationManagerDelegate, GMBLPlaceManagerDelegate, UITableViewDelegate {
    
    private var placeManager = GMBLPlaceManager()
    private var communicationManager = GMBLCommunicationManager()
    private var events: Array<Any> = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placeManager.delegate = self
        self.communicationManager.delegate = self
        
    }
    
    //MARK: Gimbal PlaceManager delegate methods
    
    func placeManager(_ manager: GMBLPlaceManager!, didBegin visit: GMBLVisit!) {
        addEventWithMessage(message: visit.place.name, date: visit.arrivalDate, icon: "placeEnter")
    }

    func placeManager(_ manager: GMBLPlaceManager!, didEnd visit: GMBLVisit!) {
        addEventWithMessage(message: visit.place.name, date: visit.departureDate, icon: "placeExit")
    }
    
    func placeManager(_ manager: GMBLPlaceManager!, didBegin visit: GMBLVisit!, withDelay delayTime: TimeInterval) {
        if delayTime > 5.0 {
            let message = "Delay \(String(describing: visit.place.name))"
            addEventWithMessage(message: message, date: Date(), icon: "placeDelay")
        }
    }
    
    //MARK: Gimbal CommunicationManager delegate methods
    func communicationManager(_ manager: GMBLCommunicationManager!, prepareNotificationForDisplay notification: UILocalNotification!, for communication: GMBLCommunication!) -> UILocalNotification! {
        let description = "\(String(describing: communication.descriptionText)) : CONTENT_DELIVERED"
        addEventWithMessage(message: description, date: Date(), icon: "commPresented")
        
        return notification
    }
    
    func communicationManager(_ manager: GMBLCommunicationManager!, prepareNotificationContentForDisplay notificationContent: UNMutableNotificationContent!, for communication: GMBLCommunication!, for visit: GMBLVisit!) -> UNMutableNotificationContent! {
        let description = "\(String(describing: communication.descriptionText)) : CONTENT_DELIVERED"
        addEventWithMessage(message: description, date: Date(), icon: "commPresented")
        
        return notificationContent
    }
    
    //MARK: TableView delegate methods
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return getEvents().count
    }
    
    
    

    //MARK: Utility methods
    func getEvents() -> Array<Any>  {
        return UserDefaults.init().object(forKey: "events") as! Array<Any>
    }

    func addCommuncation(communication: GMBLCommunication) {
        let description = "\(String(describing: communication.descriptionText)) : CONTENT_CLICKED"
        addEventWithMessage(message: description, date: Date(), icon: "commEnter.png")
    }

    func addEventWithMessage(message: String, date: Date, icon: String) {
        let item = ["message":message, "date":date, "icon":icon] as [String : Any]
        NSLog("Event ", item.description)
        events = getEvents()
        events.insert(item, at: 0)
        UserDefaults.init().set(events, forKey: "events")
    }
}
