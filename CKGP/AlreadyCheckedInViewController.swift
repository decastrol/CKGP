//
//  AlreadyCheckedInViewController.swift
//  CKGP
//
//  Created by Luke de Castro on 4/12/16.
//  Copyright © 2016 Luke de Castro. All rights reserved.
//

import UIKit

class AlreadyCheckedInViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    var raceArr = [raceObject]()
    @IBAction func donePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func refresh() {
        getRunners()
        print("refreshed table")
    }
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var searchBar: UISearchBar!
    let refresher = UIRefreshControl()
    var runnersArr = [checkedPersonObject]()
    
    override func viewDidLoad() {
        tableView.hidden = true

        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(AlreadyCheckedInViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refresher)
        
        self.getRunners()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runnersArr.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:checkedCell = (self.tableView.dequeueReusableCellWithIdentifier("runnerCell", forIndexPath: indexPath) as? checkedCell)!
        let person = runnersArr[indexPath.row]
        
        //person.show()
        cell.bibNum.text = String(person.bibNumber)
        cell.name.adjustsFontSizeToFitWidth = true
        cell.name.text = "\(person.firstName) \(person.lastName)"
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        //cell.date.adjustsFontSizeToFitWidth = true]
        cell.date.text = dateFormatter.stringFromDate(person.date)
        if races.count > 0 {
            cell.raceName.text = self.raceArr[person.raceId - 1].name
        }
        else {
            cell.raceName.text = ""
        }
        return cell
    }
    
    
    func getRunners() {
       
        if races.count == 0 {
        
            Request.getRaces { (newRaces) in
                self.raceArr = newRaces
            }
        }
        Request.getPeople({ (runners) -> Void in
            self.runnersArr = runners
            self.raceArr = races
            self.raceArr.sortInPlace({ $0.raceid < $1.raceid })
            self.tableView.reloadData()
            self.tableView.hidden = false
            self.refresher.endRefreshing()
        }) { (error: NSError) -> Void in
            
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.hidden = true
    }
}
