//
//  MainAppController.swift
//  AppX
//
//  Created by Pranay Kumar on 05/07/16.
//  Copyright © 2016 Pranay Kumar. All rights reserved.
//

import UIKit

class MainAppController: UIViewController {
    
    var currentUser : User?
    
    let keyChain = KeychainSwift()
    
    @IBAction func logoutUser(sender: AnyObject) {
        keyChain.delete("uname-x")
        keyChain.delete("passw-x")
        let loginViewController = getLoginViewToPresent()
        loginViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(loginViewController, animated: true, completion: nil)
    }
   
    @IBOutlet var userLabel: UILabel!
    var username : String = ""
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let spinner = CustomSpinner(text: Constants.SIGNING_IN_TEXT)
        self.view.addSubview(spinner)
        spinner.show()
        let tempUsername = self.keyChain.get(Constants.USERNAME_KEY) ?? nil
        let tempPassword = self.keyChain.get(Constants.PASSWORD_KEY) ?? nil
        let userAuthenticator = BasicAuthenticator()
        
        if let userName = tempUsername, let password = tempPassword {
            self.currentUser = userAuthenticator.authenticate(userName, password: password)
            if currentUser != nil {
                for view in self.view.subviews{
                    if let label = view as? UILabel{
                        label.alpha = 1
                    }
                }
                userLabel.text = currentUser?.name
            }
            else{
                let loginViewController = getLoginViewToPresent()
                loginViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                self.presentViewController(loginViewController, animated: true, completion: nil)
            }
        }else{
            let loginViewController = getLoginViewToPresent()
            loginViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            self.presentViewController(loginViewController, animated: true, completion: nil)
        }
        //navigationItem.title = "App X"
        spinner.hide()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for view in self.view.subviews{
            view.alpha = 0
        }
        
        

    }
    
}
