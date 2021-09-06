//
//  ContactItem+CoreDataProperties.swift
//  ContactsAppMadhuri
//
//  Created by M1066900 on 21/06/21.
//
//

import Foundation
import CoreData


extension ContactItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactItem> {
        return NSFetchRequest<ContactItem>(entityName: "ContactItem")
    }

    @NSManaged public var altPhone: String?
    @NSManaged public var email: String?
    @NSManaged public var favorited: Bool
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var photoID: NSNumber?

}

extension ContactItem : Identifiable {

}
