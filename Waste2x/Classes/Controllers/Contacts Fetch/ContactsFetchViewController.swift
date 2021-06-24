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
    @IBOutlet weak var mainView: UIView!
    var contacts = [CNContact]()
    var abc = [CNLabeledValue<CNPhoneNumber>]()
    var tableViewIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalObjectContainer?.tabbarHiddenView.isHidden = true
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
                    let number = phoneNumber.value
                        print("\(contact.givenName) -- \(number.stringValue)")
                }
            }
        } catch {
            print("unable to fetch contacts")
        }
        
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func contactPicker(picker: ContactsFetchViewController, didSelectContactProperty contactProperty: CNContactProperty) -> UIImage {
       let contact = contactProperty.contact
       if contact.imageDataAvailable {
          // there is an image for this contact
        return UIImage(data: contact.thumbnailImageData!)!
          // Do what ever you want with the contact image below
       }
        return UIImage(named: "noor")!
    }


}
extension ContactsFetchViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(ContactFetchTableViewCell.self, indexPath: indexPath)
        


        
            cell.imgView?.image = contactPicker(picker: ContactsFetchViewController(), didSelectContactProperty: CNContactProperty())
        cell.nameLabel.text = contacts[indexPath.row].givenName
        for phoneNumber in contacts[indexPath.row].phoneNumbers {
            let number = phoneNumber.value
            cell.numberLabel.text = number.stringValue
            print("\(contacts[indexPath.row].givenName) -- \(number.stringValue)")
        }
        
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableViewIndex = indexPath.row
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
}


