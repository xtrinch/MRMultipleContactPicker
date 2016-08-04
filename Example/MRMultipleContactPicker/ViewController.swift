//
//  ViewController.swift
//  MRMultipleContactPicker
//
//  Created by Mojca Rojko on 08/01/2016.
//  Copyright (c) 2016 Mojca Rojko. All rights reserved.
//

import MRMultipleContactPicker
import UIKit

class ViewController: UIViewController, MRMultipleContactPickerDelegate {
    @IBAction func showContactsTapped(sender: AnyObject) {
        displayContactPicker()
    }

    func displayContactPicker() {
        // Do any additional setup after loading the view, typically from a nib.
        

        let podBundle = NSBundle(forClass: MRMultipleContactPickerController.self)
        let bundleURL = podBundle.URLForResource("MRMultipleContactPicker", withExtension: "bundle")
        let bundle = NSBundle(URL: bundleURL!)!

        let s = UIStoryboard (
            name: "Main", bundle: bundle
        )
        let vc = s.instantiateInitialViewController()!
        (vc as! MRMultipleContactPickerController).delegate = self
        (vc as! MRMultipleContactPickerController).titleText = "Choose"
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: MRMultipleContactPickerDelegate methods
    func contactsSelected(people:[Person]) {
        print(people)
    }

}

