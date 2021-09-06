//
//  ContactDetailTableViewController.swift
//  ContactsAppMadhuri
//
//  Created by M1066900 on 16/06/21.
//

import UIKit
import CoreData

protocol ShowContactDelegate:AnyObject{
    func showContactController(_ controller: ContactDetailTableViewController , contact:ContactItem)
}

class ContactDetailTableViewController: UITableViewController{
    
    var managedObjectContext: NSManagedObjectContext!
    
    var showContact:ContactItem?
    
    var showContactDelegate:ShowContactDelegate?
    
    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var phoneOne: UILabel!
    @IBOutlet weak var phoneTwo: UILabel!
    @IBOutlet weak var emailOutlet: UILabel!
    @IBOutlet weak var favShowOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let showContact=showContact{
            if let image = image{
                if showContact.hasPhoto{
                    showContact.photoID = ContactItem.nextPhotoID() as NSNumber
                }
                if let data = image.jpegData(compressionQuality: 0.5){
                    do{
                        try data.write(to: showContact.photoURL, options: .atomic)
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            imageOutlet.image = showContact.photoImage
            nameOutlet.text=showContact.name
            phoneOne.text=showContact.phone
            phoneTwo.text=showContact.altPhone
            emailOutlet.text=showContact.email
            favShowOutlet.isHidden = !(showContact.favorited)
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let showContact=showContact{
            if let image = image{
                if showContact.hasPhoto{
                    showContact.photoID = ContactItem.nextPhotoID() as NSNumber
                }
                if let data = image.jpegData(compressionQuality: 0.5){
                    do{
                        try data.write(to: showContact.photoURL, options: .atomic)
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            imageOutlet.image = showContact.photoImage
            nameOutlet.text=showContact.name
            phoneOne.text=showContact.phone
            phoneTwo.text=showContact.altPhone
            emailOutlet.text=showContact.email
            favShowOutlet.isHidden = !(showContact.favorited)
        showContactDelegate?.showContactController(self, contact: showContact)
        }
    }
}

