//
//  inboxDataModel.swift
//  dayger
//
//  Created by Evan Wesley on 7/8/21.
//

import Foundation
import Firebase
//for the inbox
//for now we are going to do host verification. Thru links // we'll eventually allow other ppl to verify on hosts behalf



protocol verificationDocumentSerializeable {
    init?(dictionary:[String:Any])
}

struct VerificationDataModel {
    
    var firstname : String //this is going to be full name
   
    var lastname : String
    
    var guestUid : String

    var event : String //name in this case
        
    var docID : String //the events unique ID
    
    var age : String
    
    var sex : String
    
    var handle : String
    //specific party
    

    
    //adding profile information
    //you can accept and decline from cell but click on cell for further details.
    
    var dictionary : [String:Any]{
        return ["firstname":firstname , "lastname" : lastname, "guestUid" : guestUid , "event" : event, "docID" : docID , "age" : age , "sex" : sex , "handle" : handle ]
        
        
        
        
    }
    
    
    //we are going to add function that keeps denied people in a cache, only so they dont appear in the inbox again.
    
    
    
    
}

extension VerificationDataModel : verificationDocumentSerializeable {
    
    
    init?(dictionary : [String:Any]){
        
        guard let firstname = dictionary["firstname"] as? String , let lastname = dictionary["lastname"] as? String ,
              let guestUid = dictionary["guestUid"] as? String ,
              let docID = dictionary["docID"] as? String , let event = dictionary["event"] as? String , let age = dictionary["age"] as? String , let sex = dictionary["sex"] as? String , let handle = dictionary["handle"] as? String
        
        else {return nil}
        self.init(firstname : firstname , lastname : lastname, guestUid : guestUid , event : event , docID : docID , age : age , sex : sex , handle : handle)
        
        
        
        
        
    }
    
}





