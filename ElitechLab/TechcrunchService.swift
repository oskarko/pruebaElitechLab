//
//  TechcrunchService.swift
//  ElitechLab
//
//  Created by Óscar Rodríguez Garrucho on 11/7/17.
//  Copyright © 2017 Óscar Rodríguez Garrucho. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class TechcrunchService {
    
    // Get TechcrunchItems
    func callAPI(completionHandler: @escaping ([[String:String]]?) -> Void) {
        
        let url = URL(string: "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Ftechcrunch.com%2Ffeed%2F")!
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).validate().responseJSON() { response in
            
            switch response.result {
            case .success:
                
                var result = [[String:String]]()
                
                if let value = response.result.value {
                    //print(value)
                    let json = JSON(value) // parseamos el JSON con SwiftJson
                    let jsonItems = json["items"].arrayValue
                    for jsonItem in jsonItems {
 
                        var techcrunchitem = [String:String]()
                        techcrunchitem["title"] = jsonItem["title"].stringValue
                        techcrunchitem["date"] = jsonItem["pubDate"].stringValue
                        result.append(techcrunchitem)
                    }
                    
                }
                completionHandler(result)
            case .failure(let error):
                print(error)
                completionHandler(nil)
            }
            
        }
        
    }
    

    
    
}
