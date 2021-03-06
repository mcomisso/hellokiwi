//
//  FirstViewController.swift
//  kiwi
//
//  Created by Matteo Comisso on 03/01/15.
//  Copyright (c) 2015 Blue-Mate. All rights reserved.
//

import UIKit
import AVFoundation
import CoreBluetooth

class FirstViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, AVAudioPlayerDelegate, BWWalkthroughViewControllerDelegate, CBCentralManagerDelegate {

    //////////////////////////////////////////////////////
    //MARK: Properties
    //////////////////////////////////////////////////////
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var collectedStarsLabel: UILabel!
    
    //Places star
    @IBOutlet weak var hfarmStar: UIImageView!
    @IBOutlet weak var lifeStar: UIImageView!
    @IBOutlet weak var serraStar: UIImageView!
    @IBOutlet weak var conviviumStar: UIImageView!
    
    //People star
    @IBOutlet weak var edoStar: UIImageView!
    @IBOutlet weak var marcoStar: UIImageView!
    @IBOutlet weak var ennioStar: UIImageView!

    // class variables
    var starsFound = [String]()
    var audioPlayer: AVAudioPlayer?
    var bluetoothManager: CBCentralManager?
    
    //////////////////////////////////////////////////////
    //MARK:- View Controller methods
    //////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.addBeaconsObservers()
        self.setupViews()

        self.loadPointsStatus()
        
        // Bluetooth manager
        let options = ["CBCentralManagerOptionShowPowerAlertKey":"false"]
        bluetoothManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue(), options: options)
        self.centralManagerDidUpdateState(bluetoothManager)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.checkIfUserExists()
        
        if (PFUser.currentUser() != nil) {
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            if !userDefaults.boolForKey("wtPresented") {

                showWalkthrough()
                
                userDefaults.setBool(true, forKey: "wtPresented")
                userDefaults.synchronize()
            } else {
                
                let user: PFUser = PFUser.currentUser()
                self.emailLabel.text = user.email
                
                if PFFacebookUtils.isLinkedWithUser(user) {
                
                    self.nameLabel.text = user.objectForKey("first_name").stringByAppendingString(" ".stringByAppendingString(user.objectForKey("last_name") as String))
                    
                    FBRequestConnection.startForMeWithCompletionHandler({ (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                        if (error == nil) {
                            let facebookId = result.objectForKey("id") as String
                            let pictureID = "https://graph.facebook.com/".stringByAppendingString(facebookId).stringByAppendingString("/picture?type=large")
                            self.avatarImage.contentMode = UIViewContentMode.ScaleAspectFit
                            self.avatarImage.sd_setImageWithURL(NSURL(string: pictureID), placeholderImage: UIImage(named: "kiwiLogo"))
                            self.avatarImage.clipsToBounds = true
                            self.avatarImage.layer.cornerRadius = self.avatarImage.bounds.size.width / 2
                        }
                    })
                } else {
                    self.nameLabel.text = user.objectForKey("username").capitalizedString
                }
            }
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //////////////////////////////////////////////////////
    //MARK:- Walkthrough
    //////////////////////////////////////////////////////
    func showWalkthrough() {
        let stb = UIStoryboard(name:"WT", bundle: nil)
        
        let walkthrough = stb.instantiateViewControllerWithIdentifier("master") as BWWalkthroughViewController
        let page1 = stb.instantiateViewControllerWithIdentifier("page1") as UIViewController
        let page2 = stb.instantiateViewControllerWithIdentifier("page2") as UIViewController
        let page3 = stb.instantiateViewControllerWithIdentifier("page3") as UIViewController
        
        walkthrough.delegate = self
        walkthrough.addViewController(page1)
        walkthrough.addViewController(page2)
        walkthrough.addViewController(page3)
        
        self.presentViewController(walkthrough, animated: true, completion: nil)
    }

    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //////////////////////////////////////////////////////
    //MARK:- Personal Utils
    //////////////////////////////////////////////////////
    func setupViews() {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.tabBarController?.tabBar.barTintColor = UIColor.blackColor()
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
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
    
    func addBeaconsObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "foundPOI:", name: "BMFoundPOI", object: nil)
    }
    
    func loadPointsStatus() {
        if let starsFound = NSUserDefaults.standardUserDefaults().objectForKey("starsFound") as? [String] {

            for starName in starsFound {
                self.starsFound.append(starName)
                switch starName {
                case "edoardo":
                    edoStar.highlighted = true
                case "marco":
                    marcoStar.highlighted = true
                case "ennio":
                    ennioStar.highlighted = true
                case "serra":
                    serraStar.highlighted = true
                case "convivium":
                    conviviumStar.highlighted = true
                case "hfarm":
                    hfarmStar.highlighted = true
                case "life":
                    lifeStar.highlighted = true
                default:
                    println("Nope")
                }
            }
            self.setCollectedString()
        }
    }
    
    func foundPOI(notification: NSNotification!) {
        let userInfo = notification.userInfo as NSDictionary!
        let foundPOI = userInfo.objectForKey("poi") as String
        
        if (find(starsFound, foundPOI) != nil) {
            return
        }
        else {
            starsFound.append(foundPOI)
            let alert = SCLAlertView()
            
            alert.backgroundType = .Blur
            
            switch foundPOI {
            case "edoardo":
                edoStar.highlighted = true
                alert.showSuccess(self, title: "\(foundPOI.capitalizedString)", subTitle: "From designer to the signer", closeButtonTitle: "Ok", duration: 0.0)
            case "marco":
                marcoStar.highlighted = true
                alert.showSuccess(self, title: "\(foundPOI.capitalizedString)", subTitle: "The designed designer", closeButtonTitle: "Ok", duration: 0.0)
            case "ennio":
                ennioStar.highlighted = true
                alert.showSuccess(self, title: "\(foundPOI.capitalizedString)", subTitle: "Marketing? No problem", closeButtonTitle: "Ok", duration: 0.0)
            case "serra":
                serraStar.highlighted = true
                alert.showSuccess(self, title: "La \(foundPOI.capitalizedString)", subTitle: "Ti va un caffè?", closeButtonTitle: "Ok", duration: 0.0)
            case "convivium":
                conviviumStar.highlighted = true
                alert.showSuccess(self, title: "Il \(foundPOI.capitalizedString)", subTitle: "Le presentazioni verranno svolte qui!", closeButtonTitle: "Ok", duration: 0.0)
            case "hfarm":
                hfarmStar.highlighted = true
                alert.showSuccess(self, title: "\(foundPOI.capitalizedString)", subTitle: "Benvenuto in H-Farm", closeButtonTitle: "Ok", duration: 0.0)
            case "life":
                lifeStar.highlighted = true
                alert.showSuccess(self, title: "\(foundPOI.capitalizedString)", subTitle: "Benvenuto in Life", closeButtonTitle: "Ok", duration: 0.0)
            default:
                println("That's not the right beacon")
            }
            
            //Write the "stelle collezionate" string
            self.setCollectedString()
            NSUserDefaults.standardUserDefaults().setObject(starsFound, forKey: "starsFound")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func setCollectedString() {
        self.collectedStarsLabel.text = "Stelle collezionate: \(self.starsFound.count) di 7"
        if (self.starsFound.count == 7) {
            
            let audioSession = AVAudioSession.sharedInstance()
            let path = NSBundle.mainBundle().pathForResource("winner", ofType: "mp3")
            let error = NSErrorPointer()
            
            self.audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path!), error: error)
            
            audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nil)

            if (error == nil) {
                self.audioPlayer!.delegate = self
                self.audioPlayer!.prepareToPlay()
                self.audioPlayer!.play()
            } else {
                println("\(error.debugDescription)")
            }

            // SCLAlertView show alert
            let winnerAlert = SCLAlertView()
            winnerAlert.showAnimationType = .SlideInFromCenter

            winnerAlert.addButton("Si", actionBlock: { () -> Void in
                let shareString = "Ho visitato tutti i punti di interesse! #KiwiappKiwi"
                let shareView = UIActivityViewController(activityItems: [shareString], applicationActivities: nil)
                self.presentViewController(shareView, animated: true, completion: nil)
            })
            
            winnerAlert.showCustom(self, image: UIImage(named: "winner"), color: UIColor(red: 0.878431373, green: 0.529411765, blue: 0.019607843, alpha: 1), title: "Completato!", subTitle: "Congratulazioni, hai visitato tutti i punti di interesse! Vuoi condividerlo?", closeButtonTitle: "No", duration: 0.0)
        }
    }

    //////////////////////////////////////////////////////
    //MARK:- Button actions
    //////////////////////////////////////////////////////

    @IBAction func reloadData(sender: AnyObject) {
        let resetAlert = SCLAlertView()
        
        resetAlert.backgroundType = .Blur

        resetAlert.addButton("Cancella", actionBlock: { () -> Void in
            self.starsFound.removeAll(keepCapacity: false)
            NSUserDefaults.standardUserDefaults().setObject(self.starsFound, forKey: "starsFound")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            self.marcoStar.highlighted = false
            self.serraStar.highlighted = false
            self.edoStar.highlighted = false
            self.ennioStar.highlighted = false
            self.hfarmStar.highlighted = false
            self.conviviumStar.highlighted = false
            self.lifeStar.highlighted = false
            self.setCollectedString()
        })
        resetAlert.showWarning(self, title: "Attenzione!", subTitle: "Le stelle collezionate verranno ripristinate a 0", closeButtonTitle: "Annulla", duration: 0.0)
    }
    
    @IBAction func signOut(sender: AnyObject) {
        let alertView = SCLAlertView()
        
        alertView.backgroundType = .Blur
        
        alertView.addButton("Esci", actionBlock: { () -> Void in
            PFUser.logOut()
            self.nameLabel.text = "Welcome"
            self.avatarImage.image = UIImage(named: "startScreenLogo")
            self.checkIfUserExists()
        })
        
        alertView.showNotice(self, title: "Logout", subTitle: "Scollegarsi dall'applicazione?", closeButtonTitle: "Annulla", duration: 0.0)
    }
    
}

//////////////////////////////////////////////////////
//MARK:- LOGIN DELEGATE METHODS
//////////////////////////////////////////////////////

extension FirstViewController {

    func centralManagerDidUpdateState(central: CBCentralManager!) {
        var state = ""
        
        switch central.state {
        case .PoweredOff:
            state = "PoweredOff"
            let alertNotification = UIAlertController(title: "Attenzione", message: "Per usufruire della migliore esperienza d'uso è necessario accendere il bluetooth.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
            alertNotification.addAction(okAction)
            self.presentViewController(alertNotification, animated: true, completion: nil)
        case .PoweredOn:
            state = "Powered On"
        case .Resetting:
            state = "Resetting"
        case .Unauthorized:
            state = "Unauthorized"
        case .Unsupported:
            state = "Unsupported"
        case .Unknown:
            state = "Unknown"
        }
        
//        println("The state of bluetooth is \(state)")
    }
}

//////////////////////////////////////////////////////
//MARK:- LOGIN DELEGATE METHODS
//////////////////////////////////////////////////////

extension FirstViewController {
    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        //Print errors
        println("\(error.localizedDescription, error.localizedFailureReason)")
    }

    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        println("The user successfully logged in")

        if PFFacebookUtils.isLinkedWithUser(user) {

            //Request data from facebook to fill the missing params
            FBRequestConnection.startForMeWithCompletionHandler({ (connection: FBRequestConnection!, response: AnyObject!, error: NSError!) -> Void in
                if (error == nil) {
                    var userData = response as NSDictionary
                    var firstName = userData["first_name"] as String?
                    var lastName = userData["last_name"] as String?
                    var email = userData["email"] as String?
                    
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
        let alertView = SCLAlertView()
        alertView.backgroundType = .Blur
        alertView.showError(self, title: "Attenzione", subTitle: "È richiesta una registrazione per il corretto funzionamento di questa applicazione.", closeButtonTitle: "Ok", duration: 0.0)
    }
}

//////////////////////////////////////////////////////
//MARK:- SIGNUP DELEGATE METHODS
//////////////////////////////////////////////////////
extension FirstViewController {
    
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, shouldBeginSignUp info: [NSObject : AnyObject]!) -> Bool {
        let password = info["password"] as NSString
        let username = info["username"] as NSString
        let email = info["email"] as NSString
        
        if ((email.length == 0) | (username.length == 0) | (password.length == 0)) {
            let alertView = SCLAlertView()
            alertView.backgroundType = .Blur
            alertView.showError(self, title: "Attenzione", subTitle: "È richiesto il completamento di ogni campo", closeButtonTitle: "Ok", duration: 0.0)

            return false
        }
        
        return true
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didFailToSignUpWithError error: NSError!) {
        //Print errors
        println("\(error.localizedDescription, error.localizedFailureReason)")
    }
    
}