//
//  SecondViewController.swift
//  kiwi
//
//  Created by Matteo Comisso on 03/01/15.
//  Copyright (c) 2015 Blue-Mate. All rights reserved.
//

import UIKit

//////////////////////////////////////////////////////
//MARK:- Cell class
//////////////////////////////////////////////////////

class infoCells: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
}

//////////////////////////////////////////////////////
//MARK:- ViewController class
//////////////////////////////////////////////////////

class SecondViewController: UIViewController, BWWalkthroughViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!

    let dataSource = [
        ["id":"111",
            "name":"LIFE interaction",
            "image":"lifeBackground"],
        ["id":"222",
            "name":"H-Farm Ventures",
            "image":"hfarmBackground"],
        ["id":"333",
            "name":"Team KiWi - Ex Machina",
            "image":"kiwiBackground"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.tabBarController?.tabBar.barTintColor = UIColor.blackColor()
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "details") {
            let indexPath = self.tableView.indexPathForSelectedRow()
            var destination = segue.destinationViewController as detailsViewController

            let destinationData = self.dataSource[indexPath!.row] as Dictionary
            destination.tabID = destinationData["id"] as String!
            destination.imageName = destinationData["image"] as String!
            destination.titleName = destinationData["name"] as String!
        }
    }
}

//////////////////////////////////////////////////////
//MARK:- BWWalkthroughViewControllerDelegate METHODS
//////////////////////////////////////////////////////

extension SecondViewController: BWWalkthroughViewControllerDelegate {
    
    @IBAction func showWalkthrough(sender: AnyObject) {
        let stb = UIStoryboard(name:"WT", bundle: nil)
        
        let walkthrough = stb.instantiateViewControllerWithIdentifier("master") as BWWalkthroughViewController
        let page1 = stb.instantiateViewControllerWithIdentifier("page1") as UIViewController
        let page2 = stb.instantiateViewControllerWithIdentifier("page2") as UIViewController

        walkthrough.delegate = self
        walkthrough.addViewController(page1)
        walkthrough.addViewController(page2)
        
        self.presentViewController(walkthrough, animated: true, completion: nil)
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func walkthroughPageDidChange(pageNumber: Int) {
        println("Current page\(pageNumber)")
    }
}

//////////////////////////////////////////////////////
//MARK:- UITableViewDataSource | UITableViewDelegate METHODS
//////////////////////////////////////////////////////

extension SecondViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "cellIdentifier"
        let cell: infoCells = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as infoCells
        
        let dataCell = self.dataSource[indexPath.row]
        cell.backgroundImageView.clipsToBounds = true
        cell.backgroundImageView.image = UIImage(named: dataCell["image"] as String!)
        cell.nameLabel.text = dataCell["name"]?.uppercaseString
        
        return cell
    }
    
    //Accessory methods
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}
