//
//  ViewController.swift
//  ContactPicker
//
//  Created by Andy Ibanez on 5/9/22.
//

import UIKit
import ContactsUI

class ViewController: UIViewController, CNContactPickerDelegate {
    
    @IBOutlet weak var selectedContactLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedContactLabel.isHidden = true
        
        // Do any additional setup after loading the view.
    }

    func promptContact() {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        picker.displayedPropertyKeys = [CNContactGivenNameKey, CNContactNamePrefixKey, CNContactNameSuffixKey]
        present(picker, animated: true)
    }
    
    // MARK: - IBAction
    
    @IBAction func selectContactTouchUpInside(_ sender: UIButton) {
        promptContact()
    }
    
    // MARK: - CNContactPickerDelegate
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        selectedContactLabel.text = "Cancelled"
        selectedContactLabel.textColor = .red
        selectedContactLabel.isHidden = false
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let nameFormatter = CNContactFormatter()
        nameFormatter.style = .fullName
        let contactName = nameFormatter.string(from: contact)
        selectedContactLabel.text = contactName
        selectedContactLabel.textColor = .black
        selectedContactLabel.isHidden = false
    }
}
