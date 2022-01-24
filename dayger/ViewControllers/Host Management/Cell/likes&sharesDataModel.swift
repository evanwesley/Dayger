//
//  likes&sharesDataModel.swift
//  dayger
//
//  Created by Evan Wesley on 8/3/21.
//

import Foundation

protocol lsSerializeable {
    init?(dictionary : [String:Any])
}

struct LikesShares {
    
    var likes : Int
    
    var shares : Int
    
    var dictionary : [String:Any] {
        
        return ["likes" : likes , "shares" : shares]
    }
}
extension LikesShares : lsSerializeable {
    init?(dictionary: [String: Any]) {
        
        guard let likes = dictionary["likes"] as? Int , let shares = dictionary["shares"] as? Int else
        {return nil}
        self.init(likes : likes , shares : shares)
    }
}
