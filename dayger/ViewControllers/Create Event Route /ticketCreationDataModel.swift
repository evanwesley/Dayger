//
//  ticketCreationDataModel.swift
//  dayger
//
//  Created by Evan Wesley on 6/23/21.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol createEventDocumentSerializeable {
    init?(dictionary:[String:Any])
}

struct StoredTicketInfo {
    //creating the ticket
    
    var name: String
    
    var date: String
    
    var time: String
    
    var address : String
    
    var firstname : String
    
    var lastname : String
    
    var location : GeoPoint
    
    var additionalInformation : String
    
    var qrCode : Bool
    
    var closed_invite : Bool
 
    var live : Bool
    
    var atCapacity : Bool
    
    var anonymous : Bool
    
    var fun : Int = 0 //later
    

    var dictionary : [String:Any]{
        return ["name":name,"date":date,"time":time , "address" : address, "firstname" : firstname , "lastname" : lastname, "location" : location , "additionalInformation" : additionalInformation, "qrCode" : qrCode , "closed_invite" : closed_invite , "live" : live, "atCapacity" : atCapacity , "anonymous" : anonymous]
        
    }
    
    
    
    
}
extension StoredTicketInfo : createEventDocumentSerializeable {
    init?(dictionary:[String:Any]){
    guard let name = dictionary["name"] as? String,
          let time = dictionary["date"] as? String,
          let date = dictionary["time"] as? String,
          let address = dictionary["address"] as? String,
          let firstname = dictionary["firstname"] as? String,
          let lastname = dictionary["lastname"] as? String,
          let location = dictionary["location"] as? GeoPoint,
          let additionalInformation = dictionary["additionalInformation"] as? String,
          let qrCode = dictionary["qrCode"] as? Bool,
          let closed_invite = dictionary["closed_invite"] as? Bool, let live = dictionary["live"] as? Bool , let atCapacity = dictionary["atCapacity"] as? Bool, let anonymous = dictionary["anonymous"] as? Bool
    
    
          else {return nil}
        self.init(name : name, date : date, time : time , address : address, firstname : firstname , lastname : lastname, location : location , additionalInformation : additionalInformation , qrCode : qrCode , closed_invite : closed_invite , live : live , atCapacity : atCapacity , anonymous : anonymous )
 
    }
    
    
    
    
}
