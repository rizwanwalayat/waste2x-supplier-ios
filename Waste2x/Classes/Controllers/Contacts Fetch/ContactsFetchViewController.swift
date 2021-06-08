//
//  ContactsFetchViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 08/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import Contacts

class ContactsFetchViewController: BaseViewController {
    var contacts = [CNContact]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let contactStore = CNContactStore()
        let keys = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                        CNContactPhoneNumbersKey,
                        CNContactEmailAddressesKey
                ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request){
                    (contact, stop) in
                // Array containing all unified contacts from everywhere
                self.contacts.append(contact)
                for phoneNumber in contact.phoneNumbers {
                    if let number = phoneNumber.value as? CNPhoneNumber,
                       let label = phoneNumber.label {
                        let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
                        print("\(contact.givenName) \(contact.familyName) tel:\(localizedLabel) -- \(number.stringValue), email: \(contact.emailAddresses)")
                    }
                }
            }
        } catch {
            print("unable to fetch contacts")
        }
        
    }

}
extension ContactsFetchViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(ContactFetchTableViewCell.self, indexPath: indexPath)
        cell.textLabel?.text = contacts[indexPath.row].givenName
        let phone = contacts[indexPath.row].phoneNumbers
        cell.textLabel?.text = "\(phone)"
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


