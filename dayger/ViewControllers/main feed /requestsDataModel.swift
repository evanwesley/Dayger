//
//  requestsDataModel.swift
//  dayger
//
//  Created by Evan Wesley on 7/31/21.
//

import Foundation

protocol requestSerializeable {
    init?(dictionary:[String:Any])
}
struct Requests {
    //just makes shit easier to declare it here
    var docID : String
    var accepted : Bool = false
    
    var dictionary : [String:Any] {
        return ["docID":docID , "accepted" : accepted]
        
    }
}
extension Requests : requestSerializeable {
    
    init?(dictionary: [String: Any]) {
        
        guard let docID = dictionary["docID"] as? String , let accepted = dictionary["accepted"] as? Bool else
       
        {return nil}
       
        self.init(docID : docID , accepted : accepted)
        
    }
    
}
