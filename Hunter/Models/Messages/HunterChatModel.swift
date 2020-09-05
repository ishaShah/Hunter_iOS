//
//  HunterChatRecruiterModel.swift
//  Hunter
//
//  Created by Ajith Kumar on 05/01/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import Foundation

public class HunterChatModel {
    public var message : String?
    public var posted_by : String?
    
    func initWithDict(dictionary: NSDictionary) -> HunterChatModel{
        message = dictionary["message"] as? String
        posted_by = dictionary["posted_by"] as? String
        
        return self
    }
}
