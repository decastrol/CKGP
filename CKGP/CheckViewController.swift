//
//  CheckViewController.swift
//  CKGP
//
//  Created by Luke de Castro on 3/1/16.
//  Copyright © 2016 Luke de Castro. All rights reserved.
//

import UIKit


class CheckViewController: UIViewController, UIAlertViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate {

    @IBOutlet var bibNumber: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var submitButton: UIButton!
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        let newPerson = newCheckedPerson()
        var formCompleted = true
        var fieldsNotDone = [String]()
        
        
        
        if firstName.text?.characters.count == 0 {
            formCompleted = false
            fieldsNotDone.append("first name")
        }
        if lastName.text?.characters.count == 0 {
            formCompleted = false
            fieldsNotDone.append("last name")
        }
        if bibNumber.text?.characters.count == 0 {
            formCompleted = false
            fieldsNotDone.append("bib number")
        }
        if email.text?.characters.count == 0 {
            formCompleted = false
            fieldsNotDone.append("email")
        }
        if pickeRaceLabel.text == "Please Select A Race" {
            formCompleted = false
            fieldsNotDone.append("race name")
        }
        print(fieldsNotDone)
        
        var postError = false
        if formCompleted {
            
            loadingIndicator.hidden = false
            loadingIndicator.startAnimating()
            submitButton.hidden = true
            
            print("\nform has been completed\n")
            newPerson.firstName = firstName.text!
            newPerson.lastName = lastName.text!
            newPerson.email = email.text!
            newPerson.raceId = pickedRace.raceid
//            let today = NSDate()
//            let dateformatter = NSDateFormatter()
//            dateformatter.dateStyle = NSDateFormatterStyle.NoStyle
            //newPerson.date = today
            
            newPerson.bibNumber = Int(bibNumber.text!)!
            
            Request.getPeople({ (people) in
                newPerson.personId = people[0].personId + 1
                newPerson.show()
                
                Request.getToken({ (token) in
                    
//                    let dateFormatter = NSDateFormatter()
//                    dateFormatter.dateFormat = "YYYY-MM-DD"
//                    RKEntityMapping.addDefaultDateFormatter(dateFormatter)
//                    RKObjectMapping.addDefaultDateFormatter(dateFormatter)
                    let objRequestMap = RKObjectMapping.requestMapping()
                    
                    
                    let personDict = ["id":"personId", "checkin_race_id": "raceId", "checkin_bib": "bibNumber","email":"email", "firstname":"firstName", "lastname":"lastName",  ]
                    objRequestMap.addAttributeMappingsFromDictionary(personDict)
                    
                    let reqDes = RKRequestDescriptor(mapping: objRequestMap.inverseMapping(), objectClass: newCheckedPerson.self, rootKeyPath: nil, method: RKRequestMethod.Any)
                    
                    let objResponseMap = RKObjectMapping(forClass: NSObject.self)
                    let repDes = RKResponseDescriptor(mapping: objResponseMap, method: RKRequestMethod.POST, pathPattern: nil, keyPath: nil, statusCodes: nil)
                    
                    //RKMIMETypeSerialization.registerClass(RKNSJSONSerialization.self, forMIMEType: "application/json")
                    let objManager = RKObjectManager(baseURL: NSURL(string: "https://boiling-chamber-8329.herokuapp.com/"))
                    
                    
                    objManager.addRequestDescriptor(reqDes)
                    objManager.addResponseDescriptor(repDes)
                    //objManager.setAcceptHeaderWithMIMEType("application/json")
                    
                    //objManager.HTTPClient.setAuthorizationHeaderWithToken("JWT \(token.token)")
                    

                    objManager.HTTPClient.setDefaultHeader("Authorization", value: "JWT \(token.token)")
                    
                    objManager.postObject(newPerson, path: "/api/checkin/", parameters: /*paramsDict*/ nil, success: { (requestOp, result) in
                        
                            self.showAlert("All done!", desc: "Thank you for checking into the CKGP")
                        }, failure: { (requestOp, error) in
                            let code = requestOp.HTTPRequestOperation.response.statusCode
                            if code == 500 {
                                self.showAlert("All done!", desc: "Thank you for checking into CKGP")
                            }
                            if code == 400 {
                                self.showAlert("Error", desc: "Please enter valid email")
                            }
                            self.showAlert("Error", desc: "Something went wrong. Please try later")
                            
                    })
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.hidden = true
                    self.submitButton.hidden = false
                })
                
                }, errorCompletion: { (error) in
                    postError = true
                    //print(error)
                    
                    self.showAlert("Whoops", desc: "Something went wrong. Please try later")
                    self.loadingIndicator.stopAnimating()
            })
            
            
        }
        else {
            loadingIndicator.stopAnimating()
            let notDone = NSMutableString()
            if fieldsNotDone.count == 1 {
                notDone.appendString(fieldsNotDone[0])
            }
            else if fieldsNotDone.count > 1 {
            for i in 0 ..< fieldsNotDone.count - 1 {
                notDone.appendString("\(fieldsNotDone[i]), ")
            }
            notDone.appendString("and \(fieldsNotDone[fieldsNotDone.count - 1])")
            }
            else{ notDone.appendString("\(fieldsNotDone[0])")}
            print(notDone)
            showAlert("Incomplete Form", desc: "It looks like you haven't completed your \(notDone).")
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        bibNumber.delegate = self
        email.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CheckViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        loadingIndicator.hidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        racePickerView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == bibNumber {
            bibNumber.resignFirstResponder()
            email.becomeFirstResponder()
        }
        if textField == email {
            email.resignFirstResponder()
            firstName.becomeFirstResponder()
        }
        if textField == firstName {
            firstName.resignFirstResponder()
            lastName.becomeFirstResponder()
        }
        else {
            lastName.resignFirstResponder()
        }
        return true

    }
    func textFieldDidBeginEditing(textField: UITextField) {
        racePickerView.hidden = true
        let myScreenRect: CGRect = UIScreen.mainScreen().bounds
        let keyboardHeight : CGFloat = 236
        
        UIView.beginAnimations( "animateView", context: nil)
       //yea var movementDuration:NSTimeInterval = 0.35
        var needToMove: CGFloat = 0
        
        var frame : CGRect = self.view.frame
        if (textField.frame.origin.y + textField.frame.size.height + /*self.navigationController.navigationBar.frame.size.height + */UIApplication.sharedApplication().statusBarFrame.size.height > (myScreenRect.size.height - keyboardHeight)) {
            needToMove = (textField.frame.origin.y + textField.frame.size.height + /*self.navigationController.navigationBar.frame.size.height +*/ UIApplication.sharedApplication().statusBarFrame.size.height) - (myScreenRect.size.height - keyboardHeight);
        }
        
        frame.origin.y = -needToMove
        self.view.frame = frame
        UIView.commitAnimations()
    }
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.beginAnimations( "animateView", context: nil)
        //var movementDuration:NSTimeInterval = 0.35
        var frame : CGRect = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
        UIView.commitAnimations()
    }
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
    @IBAction func peopleButtonPressed(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("alreadyChecked")
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        presentViewController(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func donePressed(sender: AnyObject) {
        racePickerView.hidden = true
    }
    @IBOutlet var racePicker: UIPickerView!
    @IBOutlet var racePickerView: UIView!

    @IBAction func pickRacePressed(sender: AnyObject) {
        self.view.endEditing(true)
        if races.count == 0 {
            self.racePicker.hidden = true
            Request.getRaces { (newRaces) in
                races = newRaces

                self.racePicker.reloadAllComponents()
                self.racePicker.hidden = false
            }
        }
        
        self.racePickerView.hidden = false
        self.racePicker.reloadAllComponents()
    }

    @IBOutlet var pickeRaceLabel: UILabel!
    var pickedRace = raceObject()
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if races.count >= 7 {
            return 7
        }
        return races.count
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return races[row].name
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedRace = races[row]
        pickeRaceLabel.text = pickedRace.name
    }
    func showAlert(title: String, desc: String) {
        let doneMessage = UIAlertController(title: title, message: desc, preferredStyle: UIAlertControllerStyle.Alert)
        doneMessage.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(doneMessage, animated: true, completion: nil)
    }
}
