//
//  invitesDataModel.swift
//  dayger
//
//  Created by Evan Wesley on 7/31/21.
//

import Foundation
//this going to be the data model that shows tickets users can interact with and are invited too. Also it will be the used if the event is open invite. But thats backend
protocol inviteSerializeable {
    init?(dictionary:[String:Any])
}
struct Invites {
    //just makes shit easier to declare it here
    var docID : String
    var accepted : Bool = true
    
    var dictionary : [String:Any] {
        return ["docID":docID , "accepted" : accepted]
        
    }
}
extension Invites : inviteSerializeable {
    
    init?(dictionary: [String: Any]) {
        
        guard let docID = dictionary["docID"] as? String , let accepted = dictionary["accepted"] as? Bool else
       
        {return nil}
       
        self.init(docID : docID , accepted : accepted)
        
    }
    
}
