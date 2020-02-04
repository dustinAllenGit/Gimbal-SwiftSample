//
//  SettingsViewController.swift
//  Swift-SampleApp
//
//  Created by Dustin Allen on 2/3/20.
//  Copyright © 2020 Gimbal. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var gimbalMonitoringSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gimbalMonitoringSwitch.setOn(Gimbal.isStarted(), animated: false)
    }
    
    @IBAction func toggleMonitoringSwitch(_ sender: UISwitch) {
        if sender.isOn {
            Gimbal.start()
            let subView = view.viewWithTag(5000)
            subView?.isUserInteractionEnabled = true
            subView?.alpha = 1.0
        } else {
            Gimbal.stop()
            let subView = view.viewWithTag(5000)
            subView?.isUserInteractionEnabled = false
            subView?.alpha = 0.2
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            Gimbal.resetApplicationInstanceIdentifier()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
