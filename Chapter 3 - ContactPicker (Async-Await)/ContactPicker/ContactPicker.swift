//
//  ContactPicker.swift
//  ContactPicker
//
//  Created by Andy Ibanez on 5/10/22.
//

import Foundation
import ContactsUI


class ContactPicker: NSObject, CNContactPickerDelegate {
    private typealias ContactCheckedContinuation = CheckedContinuation<CNContact?, Never>

    private unowned var viewController: UIViewController
    private var contactContinuation: ContactCheckedContinuation?
    private var picker: CNContactPickerViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
        picker = CNContactPickerViewController()
        super.init()
        picker.delegate = self
    }

    @MainActor
    func pickContact() async -> CNContact? {
        viewController.present(picker, animated: true)
        return await withCheckedContinuation({ (continuation: ContactCheckedContinuation) in
            self.contactContinuation = continuation
        })
    }
    
    @MainActor
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        contactContinuation?.resume(returning: contact)
        contactContinuation = nil
        picker.dismiss(animated: true, completion: nil)
    }
    
    @MainActor
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        contactContinuation?.resume(returning: nil)
        contactContinuation = nil
    }
}
