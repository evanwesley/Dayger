//
//  guestListDataModel.swift
//  dayger
//
//  Created by Evan Wesley on 7/19/21.
//

import Foundation
import Firebase

protocol guestListDocumentSerializeable {
    init?(dictionary:[String:Any])
}

struct GuestListDataModel {
   
    var eventID : String
    
    var firstname : String
    var lastname : String
    var uid : String
    
    var icename : String
    var icenumber : String
   
    var sex : String
    var social : String
    
    var dictionary : [String:Any]{
        return ["firstname": firstname , "lastname" : lastname , "uid" : uid , "icename" : icename , "icenumber" : icenumber , "sex" : sex , "social" : social , "eventID" : eventID]

    }
}
extension GuestListDataModel : guestListDocumentSerializeable {
    init?(dictionary:[String:Any]){

        guard let firstname = dictionary["firstname"] as? String ,
              let lastname = dictionary["lastname"] as? String ,
              let uid = dictionary["uid"] as? String ,
              let eventID = dictionary["eventID"] as? String ,
              let icename = dictionary["icename"] as? String ,
              let icenumber = dictionary["icenumber"] as? String ,
              let social = dictionary["social"] as? String,
              let sex = dictionary["sex"] as? String
    else {return nil}
        self.init(eventID : eventID, firstname : firstname , lastname : lastname , uid : uid , icename : icename , icenumber : icenumber, sex : sex  , social : social)
    }
}
