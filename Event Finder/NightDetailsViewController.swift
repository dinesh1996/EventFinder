//
//  NightDetailsViewController.swift
//  Bar Finder
//
//  Created by Dinesh Salhotra on 16/01/2018.
//  Copyright © 2018 Exanity. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

var nightBarsArray: [AnyObject] = []
var nightFriendsArray: [AnyObject] = []
var voteArray =  [Int: Int]()
class NightDetailsViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    @IBOutlet weak var labelVoteCount: UILabel!
    
    @IBOutlet weak var votePicker: UIPickerView!
    @IBOutlet weak var adminLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    var nightDetail:AnyObject?
    var ref: DatabaseReference!
    @IBOutlet weak var labelPlaceName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = nightDetail?.value(forKeyPath:"info.name") as? String
        if let admin =  nightDetail?.value(forKeyPath: "info.admin") as? String {
            adminLabel.text =  "Night Admin: \(admin)"
        }
        if let date = nightDetail?.value(forKeyPath: "info.date") as? String {
            dateAndTimeLabel.text = "Night Date and Time: \(date)"
        }
        
        self.ref = Database.database().reference()
        if let currentNightNameToSend = nightDetail?.value(forKeyPath:"info.name") as? String {
            self.ref.child("nights/" + currentNightNameToSend + "/bars").observe(DataEventType.value) { (snapshot) in
                let bars = snapshot.value as! [String : AnyObject]
                nightBarsArray.removeAll()
                 voteArray.removeAll()
                self.votePicker.reloadAllComponents()
                
                
                for bar in bars{
                    nightBarsArray.append(bar.value)
                }
                self.votePicker.reloadAllComponents()
                self.labelPlaceName.text = nightBarsArray[0].value(forKeyPath: "name") as? String
                
                
                for (index,bar) in nightBarsArray.enumerated(){
                    var votecount  = 0
                    self.ref.child("nights/" + currentNightNameToSend + "/vote").observe(DataEventType.value) { (snapshot) in
                        if  snapshot.hasChildren() {
                            let votes = snapshot.value as! [String : AnyObject]
                            for vote in votes{
                                if let voteBarId = vote.value.value(forKeyPath: "bar.id") {
                                    if let barId = bar.value(forKeyPath: "id")   {
                                        if voteBarId as! String  == barId as! String  {
                                            votecount += 1
                                            voteArray[index] = votecount
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if  voteArray[0] == nil {
                    self.labelVoteCount.text =  "No Vote Yet"
                }else {
                    self.labelVoteCount.text = "Votes : \(voteArray[0]!)"
                }
            }
        }
    }
    
    @IBAction func voteButton(_ sender: UIButton) {
        if  let username:String = ((currentUser as AnyObject).value(forKeyPath: "name") as? String){
            if let currentNightNameToSend = nightDetail?.value(forKeyPath:"info.name") as? String {
                
                if let dateEventString =  nightDetail?.value(forKeyPath: "info.date") as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
                    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                    dateFormatter.amSymbol = "AM"
                    dateFormatter.pmSymbol = "PM"
                    
                    if let dateEvent = dateFormatter.date(from:dateEventString) {
                        if(dateEvent.timeIntervalSinceNow > 10800){
                            let identif = self.ref.child("nights/" + currentNightNameToSend + "/vote/").childByAutoId()
                            self.ref.child("nights/" + currentNightNameToSend + "/vote").observe(DataEventType.value) { (snapshot) in
                                if  snapshot.hasChildren() {
                                    let votes = snapshot.value as! [String : AnyObject]
                                    var isVoted = false
                                    
                                    
                                    for vote in votes{
                                        if vote.value.value(forKey: "author") as? String  == username{
                                            isVoted = true
                                        }
                                    }
                                    if isVoted {
                                        let alert = UIAlertController(title: "Info", message: "Already Voted", preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true)
                                    }else {
                                        identif.child("bar").setValue(nightBarsArray[self.votePicker.selectedRow(inComponent: 0)])
                                        identif.child("author").setValue(username)
                                        let alert = UIAlertController(title: "Voted", message: "", preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true)
                                    }
                                }else{
                                    identif.child("bar").setValue(nightBarsArray[self.votePicker.selectedRow(inComponent: 0)])
                                    identif.child("author").setValue(username)
                                    let alert = UIAlertController(title: "Voted", message: "", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true)
                                }
                            }
                            
                            
                        }else {
                            let alert = UIAlertController(title: "To Late", message: "Vote ends 3 hours before the event", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true)
                        }
                        
                    }
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  nightBarsArray[row].value(forKeyPath: "name") as? String
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nightBarsArray.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        labelPlaceName.text = nightBarsArray[row].value(forKeyPath: "name") as? String
        if let count = voteArray[row]{
            labelVoteCount.text = "Votes : \(count)"
        }else{
                self.labelVoteCount.text =  "No Vote Yet"
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showBars" {
            
            guard let destVC = segue.destination as? NightInfoBarListTableViewController else { fatalError("bad type, expected NightInfoBarListTableViewController") }
            
            let currentNightName = nightDetail?.value(forKeyPath:"info.name") as? String
            destVC.nightName = currentNightName
            
        } else if segue.identifier == "showFriends" {
            guard let destVC = segue.destination as? NightInfoFriendListTableViewController else { fatalError("bad type, expected NightInfoFriendListTableViewController") }
            let currentNightName = nightDetail?.value(forKeyPath:"info.name") as? String
            destVC.nightName = currentNightName
        }
    }
}

