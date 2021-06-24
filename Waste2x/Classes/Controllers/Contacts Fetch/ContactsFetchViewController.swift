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
    @IBOutlet weak var tableView: UITableView!
    var contacts = [CNContact]()
    var tableViewIndex = -1
    var number = ""
    var name = ""
    var dataModel = [ContactFetchModelResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiCall()
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
                self.tableView.reloadData()
                for phoneNumber in contact.phoneNumbers {
                    let number = phoneNumber.value
                        print("\(contact.givenName) -- \(number.stringValue)")
                }
            }
        } catch {
            print("unable to fetch contacts")
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        mainView.layer.cornerRadius = 36
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainView.layer.masksToBounds = true
        globalObjectContainer?.tabbarHiddenView.isHidden = true
        
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func contactPicker(picker: ContactsFetchViewController, didSelectContactProperty contactProperty: CNContactProperty) -> UIImage {
       let contact = contactProperty.contact
       if contact.imageDataAvailable {
          // there is an image for this contact
        return UIImage(data: contact.imageData!)!
          // Do what ever you want with the contact image below
       }
        return UIImage(named: "defaultUser")!
    }
    @objc func actionApi(_ sender:UIButton){
        
        
        for phoneNumber in contacts[sender.tag].phoneNumbers {
            let number = phoneNumber.value
            self.number = number.stringValue
        }
        self.name = "\(contacts[sender.tag].givenName)"
        ContactSendModel.contactSendApiCall(name: self.name, number: self.number) { result, error, status, message in
            if error == nil{
                print(result?.result?.inviteId ?? "Noting",result?.result?.inviteTo ?? "Noting")
                self.apiCall()
            }
        }
        
    }


}
extension ContactsFetchViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(ContactFetchTableViewCell.self, indexPath: indexPath)
        self.cellConfig(cell: cell, indexPath: indexPath)
//        cell.config(index: indexPath.row,data:self.dataModel,contacts:contacts)
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    //MARK: - Cell Function
    func cellConfig(cell:ContactFetchTableViewCell,indexPath:IndexPath){
        cell.imgView?.image = contactPicker(picker: ContactsFetchViewController(), didSelectContactProperty: CNContactProperty())
        cell.nameLabel.text = contacts[indexPath.row].givenName
        for phoneNumber in contacts[indexPath.row].phoneNumbers {
            let number = phoneNumber.value
            cell.numberLabel.text = number.stringValue
        }
        cell.inviteButton.tag = indexPath.row
        cell.inviteButton.addTarget(self, action: #selector(actionApi(_:)), for: .touchUpInside)
    }
    
}
extension ContactsFetchViewController{
    func apiCall(){
        ContactFetchModel.contactFetchApiCall { result, error, status, message in
            self.dataModel = result!.result
            self.tableView.reloadData()
            print(self.dataModel.count)
        }
    }
    
}


