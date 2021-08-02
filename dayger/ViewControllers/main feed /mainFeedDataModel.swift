//
//  mainFeedDataModel.swift
//  dayger
//
//  Created by Evan Wesley on 6/22/21.
//

import Foundation
import Firebase
//this is how to create data models

protocol documentSerializeable {
    init?(dictionary:[String:Any])
}


struct ticketDataModel {
    
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
    
    var live : Bool
    
    var atCapacity : Bool
    
    var anonymous : Bool
    
    var docID : String
    
    var uid: String
 
    var likes : Int
    
    var shares : Int
    
    
    var hostBitmoji : String? //URL from snapchat, we'll deal with this later
    
    var dictionary : [String:Any]{
        return ["name":name,"date":date,"time":time , "address" : address , "location" : location , "firstname" : firstname , "lastname" : lastname , "additionalInformation" : additionalInformation , "qrCode" : qrCode , "closed_invite" : closed_invite ,"live" : live, "atCapacity" : atCapacity , "anonymous" : anonymous , "docID" : docID , "uid" : uid , "likes" : likes , "shares" : shares]
        
    }
   
    
    
}
extension ticketDataModel : documentSerializeable {
    init?(dictionary:[String:Any]){
    guard let name = dictionary["name"] as? String,
          let time = dictionary["time"] as? String,
          let date = dictionary["date"] as? String,
          let address = dictionary["address"]
              as? String,
          let location = dictionary["location"] as? GeoPoint, let firstname = dictionary["firstname"] as? String , let lastname = dictionary["lastname"] as? String, let additionalInformation = dictionary["additionalInformation"] as? String,
          let qrCode = dictionary["qrCode"] as? Bool,
          let closed_invite = dictionary["closed_invite"] as? Bool , let live = dictionary["live"] as? Bool , let atCapacity = dictionary["atCapacity"] as? Bool, let anonymous = dictionary["anonymous"] as? Bool , let docID = dictionary["docID"] as? String , let uid = dictionary["uid"] as? String , let likes = dictionary["likes"] as? Int , let shares = dictionary["shares"] as? Int
    else {return nil}
        self.init(name : name, date : date, time : time, address: address , location : location , firstname : firstname , lastname : lastname , additionalInformation : additionalInformation , qrCode : qrCode , closed_invite : closed_invite , live : live , atCapacity : atCapacity , anonymous : anonymous , docID : docID, uid : uid , likes : likes , shares : shares)
 
    }
}
