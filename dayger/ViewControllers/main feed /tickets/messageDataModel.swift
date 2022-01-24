//
//  messageDataModel.swift
//  dayger
//
//  Created by Evan Wesley on 11/26/21.
//

import Foundation

protocol messageDocumentSerializeable {
    init?(dictionary:[String:Any])
}

struct MessageDataModel {
    
    
    var message: String
    var timeStamp: String
    var email: String
    var uid : String
    var docID : String
    
    var dictionary : [String:Any] {
        return ["message" : message ,
                "timeStamp" : timeStamp ,
                "email" : email ,
                "uid" : uid ,
                "docID" : docID
        
        
        ]
    }
}
    extension MessageDataModel : messageDocumentSerializeable {
        
        init? (dictionary: [String:Any]){

            
            guard  let message = dictionary["message"] as? String ,
                   let timeStamp = dictionary["timeStamp"] as? String ,
                   let email = dictionary["email"] as? String,
                   let uid = dictionary["uid"] as? String ,
            
                    let docID = dictionary["docID"] as? String
                   
                  
            
            else {return nil}
            self.init(message: message , timeStamp : timeStamp , email : email , uid : uid , docID : docID )
            
        }
    }


