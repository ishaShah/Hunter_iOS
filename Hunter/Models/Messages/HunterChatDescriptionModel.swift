//
//  HunterChatDescriptionModel.swift
//  Hunter
//
//  Created by Ajith Kumar on 12/02/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import Foundation

public class HunterChatDescriptionModel {
    public var job_id : String?
    public var recruiter_id : String?
    public var company_name : String?
    public var square_logo : String?
    public var job_title : String?
    public var matched_on : String?
    
    //recruiter objects
    public var candidate_id : String?
    public var candidate_name : String?
    public var profile_img : String?
    
    func initWithDict(dictionary: NSDictionary) -> HunterChatDescriptionModel{
        job_id = dictionary["job_id"] as? String
        recruiter_id = dictionary["recruiter_id"] as? String
        company_name = dictionary["company_name"] as? String
        square_logo = dictionary["square_logo"] as? String
        job_title = dictionary["job_title"] as? String
        matched_on = dictionary["matched_on"] as? String
        
        //recruiter
        candidate_id = dictionary["candidate_id"] as? String
        candidate_name = dictionary["candidate_name"] as? String
        profile_img = dictionary["profile_img"] as? String
        
        return self
    }
}
