//
//  coHostCellDataModel.swift
//  dayger
//
//  Created by Evan Wesley on 11/24/21.
//

import Foundation
import Firebase

protocol CoHostDocumentSerializeable {
    init?(dictionary:[String:Any])
}

struct CoHostDataModel {
    
    var email : String
    
    var uid : String
    
    
    var dictionary : [String:Any]{
        return ["email": email, "uid": uid]
        
    }
    
    
    
}
extension CoHostDataModel : CoHostDocumentSerializeable {
    init?(dictionary:[String:Any]){
    guard let email = dictionary["email"] as? String,
          let uid = dictionary["uid"] as? String
          
    else {return nil}
        self.init(email: email , uid : uid)
 
    }
}
