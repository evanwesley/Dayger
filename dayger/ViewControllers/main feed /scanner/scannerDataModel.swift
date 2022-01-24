//
//  scannerDataModel.swift
//  dayger
//
//  Created by Evan Wesley on 7/21/21.
//

import Foundation
import Firebase

protocol eventInfoDocumentSerializeable {
    init?(dictionary:[String:Any])
}

struct EventInfoDataModel {
    
    var name : String
    
    var docID : String
    
    var dictionary : [String:Any] {
        
        return ["name" : name , "docID" : docID]
    
    }
}
extension EventInfoDataModel : eventInfoDocumentSerializeable {
    
    init? (dictionary: [String:Any]){
        
        
        guard  let name = dictionary["name"] as? String, let docID = dictionary["docID"] as? String
               else {return nil}
        self.init(name : name , docID : docID)
        
    }
    
    
}
