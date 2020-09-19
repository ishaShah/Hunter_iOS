//
//  HunterMatchesModel.swift
//  Hunter
//
//  Created by Ajith Kumar on 05/01/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import Foundation

public class HunterMatchesModel {
    public var company_name : String?
    public var square_logo : String?
    public var swipe_id : Int?
    public var job_title : String?
    public var un_read_messages : Int?
    //recruiter
    public var profile_img : String?
    public var candidate_id : Int?
    public var candidate_name : String?
    
    func initWithDict(dictionary: NSDictionary) -> HunterMatchesModel{
        company_name = dictionary["company_name"] as? String
        square_logo = dictionary["square_logo"] as? String
        swipe_id = dictionary["swipe_id"] as? Int
        job_title = dictionary["job_title"] as? String
        un_read_messages = dictionary["un_read_messages"] as? Int
        //recruiter
        profile_img = dictionary["profile_image"] as? String
        candidate_name = dictionary["candidate_name"] as? String
        candidate_id = dictionary["candidate_id"] as? Int
        
        return self
    }
}
