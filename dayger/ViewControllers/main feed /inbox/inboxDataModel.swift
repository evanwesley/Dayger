//
//  inboxDataModel.swift
//  dayger
//
//  Created by Evan Wesley on 7/8/21.
//

import Foundation
import Firebase
//for the inbox
//for now we are going to do host verification. Thru links



protocol verificationDocumentSerializeable {
    init?(dictionary:[String:Any])
}

struct VerificationDataModel {
    
    var guest : String //this is going to be full name
    
    var guestUid : String
    
    var invite_accepted : Bool
    
    var event : String
        
    var docID : String
    
    var age : String
    
    var sex : String
    
    var handle : String
    //specific party
    
    var bitmoji : String? // later
    
    //adding profile information
    //you can accept and decline from cell but click on cell for further details.
    
    var dictionary : [String:Any]{
        return ["guest":guest , "guestUid" : guestUid , "invite_accepted" : invite_accepted , "event" : event, "docID" : docID , "age" : age , "sex" : sex , "handle" : handle ]
        
        
        
        
    }
    
    
    //we are going to add function that keeps denied people in a cache, only so they dont appear in the inbox again.
    
    
    
    
}

extension VerificationDataModel : verificationDocumentSerializeable {
    
    
    init?(dictionary : [String:Any]){
        
        guard let guest = dictionary["guest"] as? String ,
              let guestUid = dictionary["guestUid"] as? String ,
              let invite_accepted = dictionary["invite_accepted"] as? Bool ,
              let docID = dictionary["docID"] as? String , let event = dictionary["event"] as? String , let age = dictionary["age"] as? String , let sex = dictionary["sex"] as? String , let handle = dictionary["handle"] as? String
        
        else {return nil}
        self.init(guest : guest , guestUid : guestUid , invite_accepted : invite_accepted , event : event , docID : docID , age : age , sex : sex , handle : handle)
        
        
        
        
        
    }
    
}





