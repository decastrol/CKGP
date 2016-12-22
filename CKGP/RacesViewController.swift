//
//  RacesViewController.swift
//  CKGP
//
//  Created by Luke de Castro on 3/1/16.
//  Copyright © 2016 Luke de Castro. All rights reserved.
//

import UIKit

class RacesViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var raceTableView: UITableView!
    
    let refresher = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        raceTableView.hidden = true
        Request.getRaces { (races) in
            print("we have the races")
            self.raceTableView.reloadData()
            self.raceTableView.hidden = false
        }
        
        raceTableView.scrollEnabled = false
        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if races.count >= 7 {
            return 7
        }
        return races.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Request.getRaces(raceTableView.reloadData())
        let cell: raceCell = raceTableView.dequeueReusableCellWithIdentifier("raceCell", forIndexPath: indexPath) as! raceCell
        
        let raceObj = races[indexPath.row]
        cell.raceName.text = raceObj.name
        cell.raceDistance.text = "\(raceObj.distance) mi"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        //cell.date.adjustsFontSizeToFitWidth = true
        cell.raceDate.text = dateFormatter.stringFromDate(raceObj.date)

        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func refresh() {
        raceTableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
