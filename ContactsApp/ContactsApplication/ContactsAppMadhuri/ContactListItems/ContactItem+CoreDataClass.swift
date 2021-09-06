//
//  ContactItem+CoreDataClass.swift
//  ContactsAppMadhuri
//
//  Created by M1066900 on 21/06/21.
//
//

import UIKit
import CoreData

@objc(ContactItem)
public class ContactItem: NSManagedObject {

    var hasPhoto:Bool{
        return photoID != nil
    }

    var documentsDirectory: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }()
    var photoURL:URL{
        assert(photoID != nil, "No photo ID set")
        let fileName = "photo-\(photoID!.intValue).jpg"
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    static func nextPhotoID() -> Int{
        let userDefaults = UserDefaults.standard
        let nextID = userDefaults.integer(forKey: "PhotoID") + 1
        userDefaults.set(nextID, forKey: "PhotoID")
        return nextID
    }
    var photoImage: UIImage?{
        return UIImage(contentsOfFile: photoURL.path)
    }
    
}

