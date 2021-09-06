//
//  ContactStructure.swift
//  ContactsAppMadhuri
//
//  Created by M1066900 on 16/06/21.
//


import UIKit


class ContactStructure:NSObject{
    
    var displayPicture:UIImage=UIImage()
    var name:String=""
    var phone:String=""
    var alternatePhone:String=""
    var emailAddress:String=""
    var favoriteChecked:Bool=false
    
    func toggleCheck(){
        favoriteChecked.toggle()
    }
    
//    init(name:String){
//        self.name=name
//    }
}



