//
//  ViewController.swift
//  ContactPicker
//
//  Created by Andy Ibanez on 5/9/22.
//

import UIKit
import ContactsUI

class ViewController: UIViewController {
    
    @IBOutlet weak var selectedContactLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedContactLabel.isHidden = true
        
        // Do any additional setup after loading the view.
    }

    func promptContact() {
        Task {
            let contactPicker = ContactPicker(viewController: self)
            if let contact = await contactPicker.pickContact() {
                let nameFormatter = CNContactFormatter()
                nameFormatter.style = .fullName
                let contactName = nameFormatter.string(from: contact)
                selectedContactLabel.text = contactName
                selectedContactLabel.textColor = .black
                selectedContactLabel.isHidden = false
            } else {
                selectedContactLabel.text = "Cancelled"
                selectedContactLabel.textColor = .red
                selectedContactLabel.isHidden = false
            }
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func selectContactTouchUpInside(_ sender: UIButton) {
        promptContact()
    }
}
