//
//  SecondViewController.swift
//  kiwi
//
//  Created by Matteo Comisso on 03/01/15.
//  Copyright (c) 2015 Blue-Mate. All rights reserved.
//

import UIKit

class infoCells: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
}

class SecondViewController: UIViewController {

    let dataSource = [
        ["name":"LIFE interaction",
            "image":"lifeBackground",
            "description":""],
        ["name":"H-Farm Ventures",
            "image":"hfarmBackground",
            "description":""],
        ["name":"Team KiWi - Ex Machina",
            "image":"kiwiBackground",
            "description":""]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SecondViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Move to the selected "story"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "cellIdentifier"
        let cell: infoCells = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as infoCells
        
        let dataCell = self.dataSource[indexPath.row]
        
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
