//
//  OptInViewController.swift
//  Swift-SampleApp
//
//  Created by Dustin Allen on 2/3/20.
//  Copyright © 2020 Gimbal. All rights reserved.
//

import UIKit
import Gimbal

class OptInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func presentMainViewController() {
        UserDefaults.init().set(true, forKey: "HasBeenPresentedWithOptInScreen")
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController() else {return}
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(vc, animated: true) {
            // Will need to look more into this, as SceneDelegate now controls the window/rootViewController instead of the AppDelegate as of iOS 13.
        }
        
    }

    @IBAction func didEnable(_ sender: Any) {
        Gimbal.start()
        presentMainViewController()
    }
    
    @IBAction func didNotEnable(_ sender: Any) {
        presentMainViewController()
    }
    
    @IBAction func didPressPrivacyPolicy(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://your-privacy-policy-url")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func didPressTermsOfUse(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://your-terms-of-use-url")!, options: [:], completionHandler: nil)
    }
    
}
