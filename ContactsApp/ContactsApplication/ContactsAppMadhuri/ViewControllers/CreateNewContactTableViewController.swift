//
//  CreateNewContactTableViewController.swift
//  ContactsAppMadhuri
//
//  Created by M1066900 on 16/06/21.
//

import UIKit
import CoreData

//Contact delegate for creating and editing
protocol ContactControllerDelegate:AnyObject {
    
    func addContactControllerDidCancel(_ controller:CreateNewContactTableViewController)
    func addContactController(_ controller:CreateNewContactTableViewController, didFinishAdding contact:ContactItem)
    func addContactController(_ controller:CreateNewContactTableViewController, didFinishEditing contact:ContactItem)

}

var image:UIImage?

class CreateNewContactTableViewController: UITableViewController,UITextFieldDelegate
{
//MARK:- Properties
    @IBOutlet weak var nameOutlet: UITextField!
    @IBOutlet weak var phoneNumberOutlet: UITextField!
    @IBOutlet weak var altPhoneNumberOutlet: UITextField!
    @IBOutlet weak var emailOutlet: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    
    var favButtonOutlet:Bool = false
    
    @IBOutlet weak var saveOutlet: UIBarButtonItem!
    
    var editContact: ContactItem?
    
    var managedObjectContext: NSManagedObjectContext!
    
    weak var delegate: ContactControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        saveOutlet.isEnabled=true
        if let editContact=editContact{
            title="Edit Contact"
            if let image = image{
                if editContact.hasPhoto{
                    editContact.photoID = ContactItem.nextPhotoID() as NSNumber
                }
                if let data = image.jpegData(compressionQuality: 0.5){
                    do{
                        try data.write(to: editContact.photoURL, options: .atomic)
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            nameOutlet.text=editContact.name
            phoneNumberOutlet.text=editContact.phone
            altPhoneNumberOutlet.text=editContact.altPhone
            emailOutlet.text=editContact.email
            favButtonOutlet = editContact.favorited
            saveOutlet.isEnabled=true
        }
        saveOutlet.isEnabled=true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameOutlet.becomeFirstResponder()
    }
    
//MARK:- Actions
    
    @IBAction func photoButton(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    
    @IBAction func onClickFavorite(_ sender: UIButton) {
        checkFavoriteClicked()
    }
    
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        delegate?.addContactControllerDidCancel(self)
    }
    
    
    @IBAction func Save(_ sender: UIBarButtonItem) {
        let contact=ContactItem(context: managedObjectContext)
        do{
        contact.name=nameOutlet.text!
        
        contact.phone=phoneNumberOutlet.text!
        contact.altPhone=altPhoneNumberOutlet.text!
        contact.email=emailOutlet.text!
    if let editContact = editContact{
        if let image = image{
            if editContact.hasPhoto{
                editContact.photoID = ContactItem.nextPhotoID() as NSNumber
            }
            if let data = image.jpegData(compressionQuality: 0.5){
                do{
                    try data.write(to: editContact.photoURL, options: .atomic)
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        editContact.name=nameOutlet.text!
        editContact.phone=phoneNumberOutlet.text!
        editContact.altPhone=altPhoneNumberOutlet.text!
        editContact.email=emailOutlet.text!
        editContact.favorited = favButtonOutlet
            delegate?.addContactController(self, didFinishEditing: editContact)
        }
        else{
            if let image = image{
                if contact.hasPhoto{
                    contact.photoID = ContactItem.nextPhotoID() as NSNumber
                }
                if let data = image.jpegData(compressionQuality: 0.5){
                    do{
                        try data.write(to: contact.photoURL, options: .atomic)
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            contact.favorited = favButtonOutlet
            delegate?.addContactController(self, didFinishAdding: contact)
        }
            try managedObjectContext.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    //MARK:- Table view Delegate

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    

    func checkFavoriteClicked(){

        favButtonOutlet.toggle()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        saveOutlet.isEnabled = !newText.isEmpty
        return true
    }
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    saveOutlet.isEnabled = false
      return true
  }
    
}

extension CreateNewContactTableViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if let anImage = image{
            show(image: anImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func show(image:UIImage){
        imageView.image = image
        imageView.isHidden = false
        tableView.reloadData()
    }
}


