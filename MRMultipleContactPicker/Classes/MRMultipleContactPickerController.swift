//
//  MRMultipleContactPicker.swift
//  Pods
//
//  Created by Tovarna Idej on 01/08/16.
//
//

import Foundation
import UIKit
import AddressBook

@objc public protocol MRMultipleContactPickerDelegate {
    func contactsSelected(people:[Person])
}

public class Person:NSObject {
    var name:String?
    var phoneNumber:String?
    var email:String?
}

public class MRMultipleContactPickerController:UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    @IBAction func onDismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onContinue(sender: AnyObject) {
        var persons:[Person] = []
        for person in selectedPeople {
            
            let firstName = ABRecordCopyCompositeName(person).takeRetainedValue() as? String
            
            var emails:[String] = []
            let emailRecords = ABRecordCopyValue(person, kABPersonEmailProperty).takeRetainedValue() as ABMultiValueRef
            let emailsCount = ABMultiValueGetCount(emailRecords)
            for index in 0 ..< emailsCount {
                if let email = ABMultiValueCopyValueAtIndex(emailRecords, index).takeRetainedValue() as? String {
                    emails.append(email)
                }
            }
            
            var phoneNumbers:[String] = []
            let phoneRecords = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue() as ABMultiValueRef
            let phoneCount = ABMultiValueGetCount(phoneRecords)
            for index in 0 ..< phoneCount {
                if let phoneNumber = ABMultiValueCopyValueAtIndex(phoneRecords, index).takeRetainedValue() as? String {
                    phoneNumbers.append(phoneNumber)
                }
            }
            
            let person:Person = Person()
            person.name = firstName
            if phoneNumbers.count > 0 {
                person.phoneNumber = phoneNumbers[0]
            }
            if emails.count > 0 {
                person.email = emails[0]
            }
            persons.append(person)
        }
        
        guard let delegate = delegate else {
            return
        }
        
        self.dismissViewControllerAnimated(true, completion: { (void) in
            delegate.contactsSelected(persons)
        })
    }

    public var titleText = "Choose from contacts"
    public var continueText = "Done"
    public var delegate:MRMultipleContactPickerDelegate?
    let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    var people:[ABRecord]!
    var selectedPeople:[ABRecord] = []
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.topLabel.text = titleText
        self.button.setTitle(continueText, forState: UIControlState.Normal)
        button.layer.cornerRadius = 3.0
        tableView.rowHeight = 60
                
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if !granted {
                    print("Denied contact authorization")
                } else {
                    self.getContactNames()
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                }
            }
        }

    }
    
    func getContactNames() {
        people = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue() as NSArray as [ABRecord]
    }
    
    func contactExists(person:ABRecord)->Int {
        for (index,curr_person) in selectedPeople.enumerate() {
            if (ABRecordGetRecordID(person) == ABRecordGetRecordID(curr_person)) {
                return index
            }
        }
        return -1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people!.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        let person = people![indexPath.row]
        let index = contactExists(person)
        if index < 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("ContactTableViewCell") as! ContactTableViewCell
            (cell as! ContactTableViewCell).name.text = ABRecordCopyCompositeName(person).takeRetainedValue() as String
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("SelectedContactTableViewCell") as! SelectedContactTableViewCell
            (cell as! SelectedContactTableViewCell).name.text = ABRecordCopyCompositeName(person).takeRetainedValue() as String
        }
        
        return cell!
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let person = people![indexPath.row]
        let index = contactExists(person)
        if index < 0 {
            selectedPeople.append(person)
        } else {
            selectedPeople.removeAtIndex(index)
        }
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
}

class SelectedContactTableViewCell:UITableViewCell {
    @IBOutlet var name: UILabel!
}

class ContactTableViewCell:UITableViewCell {
    @IBOutlet var name: UILabel!
}