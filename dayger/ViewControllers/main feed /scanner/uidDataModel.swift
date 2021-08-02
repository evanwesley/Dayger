//
//  File.swift
//  dayger
//
//  Created by Evan Wesley on 7/21/21.
//

import Foundation

protocol uidDocumentSerializeable {
    init?(dictionary:[String:Any])
}

struct UidDataModel {
    
    
    var uid : String
    
    //eventually we are going to want to retrieve an image too
    
    var dictionary : [String:Any] {
        return ["uid" : uid]
    }
}
    extension UidDataModel : uidDocumentSerializeable {
        
        init? (dictionary: [String:Any]){
            
            
            guard  let uid = dictionary["uid"] as? String
                  
            else {return nil}
            self.init(uid: uid)
            
        }
    }
