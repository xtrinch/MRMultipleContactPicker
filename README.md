# MRMultipleContactPicker

[![CI Status](http://img.shields.io/travis/xtrinch/MRMultipleContactPicker.svg?style=flat)](https://travis-ci.org/xtrinch/MRMultipleContactPicker)
[![Version](https://img.shields.io/cocoapods/v/MRMultipleContactPicker.svg?style=flat)](http://cocoapods.org/pods/MRMultipleContactPicker)
[![License](https://img.shields.io/cocoapods/l/MRMultipleContactPicker.svg?style=flat)](http://cocoapods.org/pods/MRMultipleContactPicker)
[![Platform](https://img.shields.io/cocoapods/p/MRMultipleContactPicker.svg?style=flat)](http://cocoapods.org/pods/MRMultipleContactPicker)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

    import MRMultipleContactPicker
    import UIKit
    
    class ViewController: UIViewController, MRMultipleContactPickerDelegate {
        @IBAction func showContactsTapped(sender: AnyObject) {
            displayContactPicker()
        }
    
        func displayContactPicker() {
            super.viewDidLoad()
            let s = UIStoryboard (
                name: "Main", bundle: NSBundle(forClass: MRMultipleContactPickerController.self)
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

## Requirements

## Installation

MRMultipleContactPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MRMultipleContactPicker"
```

## Author

Mojca Rojko, mojca.rojko@gmail.com

## License

MRMultipleContactPicker is available under the MIT license. See the LICENSE file for more info.
