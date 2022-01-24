//
//  cellDataModel.swift
//  dayger
//
//  Created by Evan Wesley on 6/18/21.
//

import Foundation
import Firebase
//this is how to create data models

protocol managerDocumentSerializeable {
    init?(dictionary:[String:Any])
}


struct ManagerDataModel {
    
    var name : String
    
    var date : String
    
    var time : String
    
    var address : String
    
    var location : GeoPoint
    
    var firstname : String
    
    var lastname : String
    
    var additionalInformation : String
    
    var qrCode : Bool
    
    var closed_invite : Bool
    
    var docID : String
    
    var hostBitmoji : String? //URL from snapchat, we'll deal with this later
    
    var dictionary : [String:Any]{
        return ["name":name,"date":date,"time":time , "address" : address , "location" : location , "firstname" : firstname , "lastname" : lastname , "additionalInformation" : additionalInformation , "qrCode" : qrCode , "closed_invite" : closed_invite , "docID" : docID]
        
    }
   
    
    
}
extension ManagerDataModel : managerDocumentSerializeable {
    init?(dictionary:[String:Any]){
    guard let name = dictionary["name"] as? String,
          let time = dictionary["time"] as? String,
          let date = dictionary["date"] as? String,
          let address = dictionary["address"]
              as? String,
          let location = dictionary["location"] as? GeoPoint, let firstname = dictionary["firstname"] as? String , let lastname = dictionary["lastname"] as? String, let additionalInformation = dictionary["additionalInformation"] as? String,
          let qrCode = dictionary["qrCode"] as? Bool,
          let closed_invite = dictionary["closed_invite"] as? Bool,
          let docID = dictionary["docID"] as? String
    else {return nil}
        self.init(name : name, date : date, time : time, address: address , location : location , firstname : firstname , lastname : lastname , additionalInformation : additionalInformation , qrCode : qrCode , closed_invite : closed_invite , docID : docID)
 
    }
}
