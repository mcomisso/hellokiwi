//
//  FirstViewController.swift
//  kiwi
//
//  Created by Matteo Comisso on 03/01/15.
//  Copyright (c) 2015 Blue-Mate. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.checkIfUserExists()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func checkIfUserExists() {
        if (PFUser.currentUser() == nil) {
            var loginViewController = PFLogInViewController()

            loginViewController.logInView.logo = UIImageView(image: UIImage(named: "kiwiLogo"))
            loginViewController.logInView.logo.contentMode = UIViewContentMode.ScaleAspectFit
            loginViewController.facebookPermissions = []
            loginViewController.fields = PFLogInFields.Default | PFLogInFields.Facebook | PFLogInFields.Twitter
            loginViewController.delegate = self
            
            var signupController = PFSignUpViewController()
            signupController.fields = PFSignUpFields.Default
            signupController.signUpView.logo = UIImageView(image: UIImage(named: "kiwiLogo"))
            signupController.signUpView.logo.contentMode = UIViewContentMode.ScaleAspectFit
            signupController.delegate = self
            
            //Set the signup controller
            loginViewController.signUpController = signupController
            
            self.presentViewController(loginViewController, animated: true, completion: nil)
        }
    }
    
    func setupDataInView() {
        
    }
}

    


// LOGIN DELEGATE METHODS
extension FirstViewController {
    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        //Print errors
        println("\(error.localizedDescription, error.localizedFailureReason)")
    }

    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        println("The user successfully logged in")

        if(user.isNew){
            FBRequestConnection.startForMeWithCompletionHandler({ (connection: FBRequestConnection!, response: AnyObject!, error: NSError!) -> Void in
                if (error == nil) {
                    var userData = response as NSDictionary
                    var firstName = userData["first_name"] as String
                    var lastName = userData["last_name"] as String
                    var email = userData["email"] as String
                    
                    println("User Data: \(userData.description)")
                    
                    let parseUser = PFUser.currentUser()
                    parseUser.setValue(firstName, forKey: "first_name")
                    parseUser.setValue(lastName, forKey: "last_name")
                    parseUser.setValue(email, forKey: "email")
                    
                    parseUser.saveInBackgroundWithBlock(nil)
                }
                else
                {
                    println("\(error.localizedFailureReason)")
                }
            })
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController!) {
        //Tell the user that the login or registration is required.

        //AlertView
    }
}

// SIGNUP DELEGATE METHODS
extension FirstViewController {
    
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, shouldBeginSignUp info: [NSObject : AnyObject]!) -> Bool {
        //TODO: Change to a cooler method
        return true
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!) {
        //Tell the user that is needed
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didFailToSignUpWithError error: NSError!) {
        //Print errors
        println("\(error.localizedDescription, error.localizedFailureReason)")
    }
    
}