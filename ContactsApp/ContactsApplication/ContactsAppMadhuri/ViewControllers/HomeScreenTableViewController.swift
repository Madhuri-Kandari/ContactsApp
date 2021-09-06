//
//  HomeScreenTableViewController.swift
//  ContactsAppMadhuri
//
//  Created by M1066900 on 16/06/21.
//

import UIKit
import CoreData

var contacts = [ContactItem]()

class HomeScreenTableViewController: UITableViewController,ContactControllerDelegate,ShowContactDelegate {
    
    
    var favButton =  UIButton()
    
    var delegate3 = CreateNewContactTableViewController()
    
    let indexTitles = "😍ABCDEFGHIJKLMNOPQRSTUVWXYZ".map(String.init)
    
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var managedObjectContext: NSManagedObjectContext!
    
    func addContactControllerDidCancel(_ controller: CreateNewContactTableViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addContactController(_ controller: CreateNewContactTableViewController, didFinishAdding contact: ContactItem) {
        let newRowIndex = contacts.count
        contacts.append(contact)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
//        tableView.reloadData()
        tableView.insertRows(at: indexPaths, with: .automatic)
       tableView.reloadData()
//        do{
//                            try context.save()
           self.navigationController?.popViewController(animated: true)
//                        }catch{
//                            print(error.localizedDescription)
//                        }
    }
    
    func addContactController(_ controller: CreateNewContactTableViewController, didFinishEditing contact: ContactItem) {
        if let index = contacts.firstIndex(of: contact){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                let label = cell.viewWithTag(106) as! UILabel
                let img = cell.viewWithTag(108) as! UIImageView
                favButton = cell.viewWithTag(110) as! UIButton
                let contactItem = contacts[indexPath.row]
                img.image = contactItem.photoImage
                label.text = contactItem.name
                favButton.isHidden = !(contactItem.favorited)
            }
        }
        tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    func showContactController(_ controller:ContactDetailTableViewController , contact:ContactItem){
        if let index=contacts.firstIndex(of: contact){
        let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                let label = cell.viewWithTag(107) as! UILabel
                let img = cell.viewWithTag(112) as! UIImageView
                favButton = cell.viewWithTag(111) as! UIButton
             //   let contactItem = contacts[indexPath.row]
            //    print(contactItem.photoURL.absoluteURL)
                img.image=contact.photoImage
                label.text=contact.name
                print("-----")
                favButton.isHidden = !(contact.favorited)
            }
        }
        tableView.reloadData()
//        do{
//            try context.save()
//            
            self.navigationController?.popViewController(animated: true)
//        }catch{
//            print(error.localizedDescription)
//        }
    }
    
        
    override func viewDidLoad() {
        self.navigationController?.navigationBar.prefersLargeTitles=true
        super.viewDidLoad()
        let fetchRequest = NSFetchRequest<ContactItem>()
        let entity = ContactItem.entity()
        fetchRequest.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        tableView.reloadData()
        do{
            contacts = try context.fetch(fetchRequest)
        }
        catch{
            print(error.localizedDescription)
        }
    //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "showContactCell")

    }
    
    
    //MARK:- NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addContactSegue"{
            let controllerB = segue.destination as! CreateNewContactTableViewController
            controllerB.delegate = self
            controllerB.managedObjectContext = self.context
        }
        else if segue.identifier == "editContactSegue"{
            let controllerB = segue.destination as! CreateNewContactTableViewController
            controllerB.delegate = self
            controllerB.managedObjectContext = self.context
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                let contactTapped = contacts[indexPath.row]
                controllerB.editContact = contactTapped
            }
        }
            else if segue.identifier == "showContactSegue"{
                let controllerB = segue.destination as! ContactDetailTableViewController
                controllerB.showContactDelegate=self
                controllerB.managedObjectContext = self.context
                
                if let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
                {
                let contactTapped = contacts[indexPath.row]
                controllerB.showContact=contactTapped
                }
            }
        }
        

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let cell=tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "editContactSegue", sender: cell)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowContactCell", for: indexPath)
       // getAllContacts()
        let label = cell.viewWithTag(106) as! UILabel
        let contactItem = contacts[indexPath.row]
        let img = cell.viewWithTag(108) as! UIImageView
        favButton = cell.viewWithTag(110) as! UIButton
        label.text = contactItem.name
        img.image = contactItem.photoImage
        favButton.isHidden = !(contactItem.favorited)
        img.layer.cornerRadius = 70/3
        img.layer.masksToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let indexPaths=[indexPath]
        let contactItem = contacts[row]
        context.delete(contactItem)
        contacts.remove(at: row)
        tableView.deleteRows(at: indexPaths, with: .automatic)
     
        tableView.reloadData()
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "showContactSegue", sender: cell)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexTitles
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) ->Int {
                 index
             }
}
