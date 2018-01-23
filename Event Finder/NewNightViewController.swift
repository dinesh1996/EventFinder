//
//  NewNightViewController.swift
//  Bar Finder
//
//  Created by Dinesh Salhotra on 15/01/2018.
//  Copyright © 2018 Exanity. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class NewNightViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var datePicket: UIDatePicker!
    @IBOutlet weak var nightName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func saveNight(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        if let userName : String = (currentUser as AnyObject).value(forKeyPath: "name") as? String{
            
            
            
            self.ref = Database.database().reference()
            
            if (nightName.text != "") {
                if(addedFriendsArray.count > 0){
                    if(addedBarArray.count > 0){
                        
                        let nightNameValue = nightName.text!
                        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
                        let dateEvent = formatter.string(from: datePicket.date)
                        let identifier =  self.ref.child("nights/\(nightNameValue)")
                        identifier.child("info/admin").setValue(userName)
                        identifier.child("info/date").setValue(dateEvent)
                        identifier.child("info/name").setValue(nightNameValue)
                        
                        for (friend) in addedFriendsArray {
                            identifier.child("friends").childByAutoId().setValue(friend)
                        }
                        for (bar) in addedBarArray {
                            identifier.child("bars").childByAutoId().setValue(bar)
                        }
                        addedFriendsArray.removeAll()
                        addedBarArray.removeAll()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nightLoad"), object: nil)
                        dismiss(animated: true)
                        print("OK")
                        
                    }else {
                        let alert = UIAlertController(title: "No Place", message: "1 place is mandatory", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    
                }else {
                    let alert = UIAlertController(title: "No Friends", message: "1 friend is mandatory", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true)
                }
            }else {
                let alert = UIAlertController(title: "No Name", message: "THe name is mandatory", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

